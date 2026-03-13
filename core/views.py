from django.shortcuts import render, redirect
from django.http import HttpResponseForbidden
from django.urls import reverse
from django.contrib import messages
from django.contrib.auth.hashers import make_password
from .forms import LoginForm
from .models import Usuario, Role, Sede
from .models import ItemRiesgo, Area, Riesgo, Control, ItemResponsable, RegistroCheck, Auditoria
from .forms import ItemRiesgoForm, RiesgoForm, ControlForm, ItemResponsableForm, UsuarioForm
from django.shortcuts import get_object_or_404
from django.db import IntegrityError
import logging
import traceback
from datetime import date, datetime
from django.db.models import Q

logger = logging.getLogger(__name__)


def _record_audit(request, tabla_afectada, id_registro, accion, descripcion=None):
	"""Registra una fila en Auditoria describiendo la acción del usuario.

	Parámetros: tabla_afectada (str), id_registro (int), accion (str), descripcion (opcional).
	Mantener esta función simple: intenta construir una descripción legible y crea el registro.
	"""
	logger = logging.getLogger('core.audit')
	user_id = request.session.get('user_id')
	if not user_id:
		logger.debug('Sin usuario en sesión; omitiendo auditoría %s %s', tabla_afectada, accion)
		return
	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		logger.warning('Audit: session user_id %s not found in DB; skipping audit', user_id)
		return
	ip = request.META.get('REMOTE_ADDR') or request.META.get('HTTP_X_FORWARDED_FOR', '')
	# mapear acciones a términos en español (legibilidad en auditoría)
	action_map = {
		'CREAR': 'CREAR',
		'INSERT': 'CREAR',
		'EDITAR': 'EDITAR',
		'UPDATE': 'EDITAR',
		'ELIMINAR': 'ELIMINAR',
		'DELETE': 'ELIMINAR',
		'ASIGNAR': 'ASIGNAR',
		'INSPECCION': 'INSPECCION',
	}
	accion_normalizada = action_map.get(str(accion).upper(), str(accion).upper())
	# Intentar construir una descripción estandarizada y legible cuando sea posible
	try:
		model_map = {
			'items_riesgos': ItemRiesgo,
			'riesgos': Riesgo,
			'controles': Control,
			'item_responsable': ItemResponsable,
			'registro_checks': RegistroCheck,
		}

		extractors = {
			'items_riesgos': (lambda o: getattr(o, 'nombre', str(o))),
			'riesgos': (lambda o: getattr(o, 'nombre', str(o))),
			'controles': (lambda o: getattr(o, 'nombre', str(o))),
			'item_responsable': (lambda o: f"{getattr(getattr(o, 'id_item_riesgo', None), 'nombre', '')} -> {getattr(getattr(o, 'id_usuario', None), 'nombre', '')}"),
			'registro_checks': (lambda o: getattr(getattr(o, 'id_control', None), 'nombre', str(o))),
		}

		verb_map = {
			'CREAR': 'creó',
			'EDITAR': 'editó',
			'ELIMINAR': 'eliminó',
			'INSPECCION': 'inspeccionó',
			'ASIGNAR': 'asignó',
		}

		constructed = None
		tbl = str(tabla_afectada)
		try:
			if tbl in model_map:
				ModelCls = model_map[tbl]
				try:
					obj = ModelCls.objects.get(pk=id_registro)
				except Exception:
					obj = None
				label = None
				if obj is not None:
					extractor = extractors.get(tbl)
					if extractor:
						try:
							label = extractor(obj)
						except Exception:
							label = str(obj)
				if not label:
					label = str(id_registro)
				verb = verb_map.get(accion_normalizada, accion_normalizada.lower())
				now = date.today().isoformat()
				constructed = f'Usuario "{usuario.nombre}" {verb} "{label}" identificado "{id_registro}" el dia "{now}" afectando la tabla "{tabla_afectada}".'
		except Exception:
			constructed = None

		# Si existe una descripción proporcionada, anexionarla con cuidado para evitar duplicados
		final_desc = None
		if constructed and descripcion:
			try:
				if constructed.strip() in descripcion.strip():
					final_desc = constructed
				else:
					final_desc = constructed + f' Detalle: {descripcion}'
			except Exception:
				final_desc = constructed + f' Detalle: {descripcion}'
		elif constructed:
			final_desc = constructed
		else:
			final_desc = descripcion

		Auditoria.objects.create(tabla_afectada=tabla_afectada, id_registro=id_registro, accion=accion_normalizada, descripcion=final_desc, id_usuario=usuario, ip_origen=ip)
		logger.info('Audit recorded: %s id=%s by user=%s ip=%s (accion=%s) desc=%s', tabla_afectada, id_registro, usuario.nombre, ip, accion_normalizada, final_desc)
	except Exception as exc:
		# Registrar traza completa para depuración si falla la inserción
		logger.error('No se pudo registrar auditoría para %s id=%s acción=%s user=%s; exc: %s', tabla_afectada, id_registro, accion, user_id, exc)
		logger.error(traceback.format_exc())


def login_view(request):
	if request.method == 'POST':
		form = LoginForm(request.POST)
		if form.is_valid():
			correo = form.cleaned_data['correo']
			password = form.cleaned_data['password']
			try:
				user = Usuario.objects.get(correo=correo)
			except Usuario.DoesNotExist:
				return render(request, 'core/login.html', {'form': form, 'error': 'Credenciales inválidas'})

			# Validar estado: impedir inicio de sesión si el usuario no está en estado 'activo'.
			if str(getattr(user, 'estado', '')).lower() != 'activo':
				# Devolver mensaje claro para que la interfaz muestre el motivo del bloqueo
				return render(request, 'core/login.html', {'form': form, 'error': 'Usuario inactivo'})

			if user.check_password(password):
				# guardar información en sesión
				request.session['user_id'] = user.id_usuario
				request.session['user_nombre'] = user.nombre
				request.session['user_rol'] = user.id_rol.id_rol

				# redirigir según rol
				rol = user.id_rol.id_rol
				if rol == 1:
					# Redirigir superadmin a su perfil
						return redirect('superadmin_profile')
				elif rol == 2:
					# Admin: redirigir a perfil
					return redirect('admin_profile')
				elif rol == 3:
					# Responsable: redirigir a perfil
					return redirect('responsable_profile')
				else:
					# rol desconocido: redirigir a login con mensaje
					return render(request, 'core/login.html', {'form': form, 'error': 'Rol no autorizado'})
			else:
				return render(request, 'core/login.html', {'form': form, 'error': 'Credenciales inválidas o usuario inactivo'})
	else:
		form = LoginForm()
	return render(request, 'core/login.html', {'form': form})


def logout_view(request):
	request.session.flush()
	return redirect(reverse('login'))


def role_required(allowed_roles):
	def decorator(view_func):
		def _wrapped(request, *args, **kwargs):
			rol = request.session.get('user_rol')
			if rol is None:
				return redirect('login')
			if rol not in allowed_roles:
				return HttpResponseForbidden('No tienes permiso para ver esta página')
			return view_func(request, *args, **kwargs)

		return _wrapped

	return decorator


@role_required([2])
def admin_profile(request):
	"""Display the logged-in admin's profile information."""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')
	try:
		usuario = Usuario.objects.select_related('id_rol', 'id_sede', 'id_area').get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	return render(request, 'core/admin/profile.html', {'usuario': usuario})


@role_required([3])
def responsable_profile(request):
	"""Display the logged-in responsable's profile using independent template/CSS."""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')
	try:
		usuario = Usuario.objects.select_related('id_rol', 'id_sede', 'id_area').get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	return render(request, 'core/responsable/profile_responsable.html', {'usuario': usuario})


@role_required([2])
def admin_change_password(request):
	"""Allow the logged-in admin to change their password.

	Expects POST with 'old_password', 'new_password', 'confirm_password'.
	"""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	if request.method == 'POST':
		old = request.POST.get('old_password', '')
		new = request.POST.get('new_password', '')
		confirm = request.POST.get('confirm_password', '')

		errors = []
		if not usuario.check_password(old):
			errors.append('La contraseña anterior no es correcta.')
		if not new:
			errors.append('La nueva contraseña no puede estar vacía.')
		if new != confirm:
			errors.append('La confirmación no coincide con la nueva contraseña.')

		if errors:
			for e in errors:
				messages.error(request, e)
		else:
			usuario.password_hash = make_password(new)
			usuario.save()
			messages.success(request, 'Contraseña actualizada correctamente.')
			return redirect('admin_profile')

	return render(request, 'core/admin/change_password.html', {'usuario': usuario})


@role_required([3])
def responsable_change_password(request):
	"""Allow the logged-in responsable to change their password using independent template/CSS."""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	if request.method == 'POST':
		old = request.POST.get('old_password', '')
		new = request.POST.get('new_password', '')
		confirm = request.POST.get('confirm_password', '')

		errors = []
		if not usuario.check_password(old):
			errors.append('La contraseña anterior no es correcta.')
		if not new:
			errors.append('La nueva contraseña no puede estar vacía.')
		if new != confirm:
			errors.append('La confirmación no coincide con la nueva contraseña.')

		if errors:
			for e in errors:
				messages.error(request, e)
		else:
			usuario.password_hash = make_password(new)
			usuario.save()
			messages.success(request, 'Contraseña actualizada correctamente.')
			return redirect('responsable_profile')

	return render(request, 'core/responsable/change_password_responsable.html', {'usuario': usuario})


@role_required([2])

def admin_items(request):
	# Listar ítems con búsqueda opcional por nombre
	q = request.GET.get('q', '').strip()
	estado = request.GET.get('estado', '').strip()
	area = request.GET.get('area', '').strip()
	items = ItemRiesgo.objects.select_related('id_area', 'creado_por')
	if q:
		items = items.filter(nombre__icontains=q)

	# Filtrar por estado; aceptar 'activo'/'inactivo' o valores heredados '1'/'0'.
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			items = items.filter(estado__iexact=st)

	# Soporte de filtro por área (Item -> Area)
	if area:
		try:
			aid = int(area)
			items = items.filter(id_area=aid)
		except Exception:
			pass

	areas = Area.objects.order_by('nombre')

	return render(request, 'core/admin/items.html', {'items': items, 'q': q, 'estado': estado, 'areas': areas, 'area': area})


@role_required([2])
def admin_item_inspect(request, pk):
	item = get_object_or_404(ItemRiesgo.objects.select_related('id_area', 'creado_por'), pk=pk)
	return render(request, 'core/admin/item_inspect.html', {'item': item})


@role_required([2])
def admin_item_create(request):
	if request.method == 'POST':
		form = ItemRiesgoForm(request.POST)
		if form.is_valid():
			item = form.save(commit=False)
			# set creador from session
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					item.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			item.save()
			# auditoria (detalle)
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Item "{item.nombre}" identificado "{item.id_item_riesgo}" fue creado por "{user_name}". '
					f'Área: "{getattr(item.id_area, "nombre", "")}". '
					f'Criticidad: "{item.get_criticidad_display()}". Estado: "{item.get_estado_display()}".'
				)
				_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Item creado correctamente.')
			return redirect('admin_items')
	else:
		form = ItemRiesgoForm()
	return render(request, 'core/admin/item_form.html', {'form': form, 'action': 'Crear Item'})


@role_required([2])
def admin_item_edit(request, pk):
	item = get_object_or_404(ItemRiesgo, pk=pk)
	if request.method == 'POST':
		form = ItemRiesgoForm(request.POST, instance=item)
		if form.is_valid():
			# Calcular los campos modificados para generar una descripción legible en auditoría
			changed = form.changed_data
			old_values = {f: getattr(item, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_area': 'Área', 'criticidad': 'Criticidad', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó el item {obj.nombre.upper()} con id {obj.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó el item {obj.nombre.upper()} con id {obj.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos sin cambios detectados.')
				_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Item actualizado correctamente.')
			return redirect('admin_items')
	else:
		form = ItemRiesgoForm(instance=item)
	return render(request, 'core/admin/item_form.html', {'form': form, 'action': 'Editar Item'})


@role_required([2])
def admin_item_delete(request, pk):
	item = get_object_or_404(ItemRiesgo, pk=pk)
	if request.method == 'POST':
		# Capturar información clave antes de eliminar para que la auditoría tenga contexto
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó el item {item.nombre.upper()} identificado {item.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos.'
		except Exception:
			desc = None
		item.delete()
		# auditoria
		try:
			_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Item eliminado correctamente.')
		return redirect('admin_items')
	# Si es GET, mostrar confirmación simple
	return render(request, 'core/admin/item_delete_confirm.html', {'item': item})


@role_required([2])
def admin_amenazas(request):
	# list riesgos with optional search by nombre and optional area/estado filters
	q = request.GET.get('q', '').strip()
	area = request.GET.get('area', '').strip()
	estado = request.GET.get('estado', '').strip()

	riesgos = Riesgo.objects.select_related('id_item_riesgo', 'creado_por')
	if q:
		riesgos = riesgos.filter(nombre__icontains=q)

	# estado filter support
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			riesgos = riesgos.filter(estado__iexact=st)

	# apply area filter if provided (expects Area pk)
	if area:
		try:
			aid = int(area)
			riesgos = riesgos.filter(id_item_riesgo__id_area=aid)
		except Exception:
			# ignore invalid area value
			pass

	# Lista de áreas para el selector en la plantilla
	areas = Area.objects.order_by('nombre')

	return render(request, 'core/admin/amenazas.html', {'riesgos': riesgos, 'q': q, 'areas': areas, 'area': area, 'estado': estado})


@role_required([2])
def admin_riesgo_inspect(request, pk):
	riesgo = get_object_or_404(Riesgo.objects.select_related('id_item_riesgo', 'creado_por'), pk=pk)
	return render(request, 'core/admin/riesgo_inspect.html', {'riesgo': riesgo})


@role_required([2])
def admin_riesgo_create(request):
	if request.method == 'POST':
		form = RiesgoForm(request.POST)
		if form.is_valid():
			r = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					r.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			r.save()
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Riesgo "{r.nombre}" identificado "{r.id_riesgo}" fue creado por "{user_name}". '
					f'Item: "{getattr(r.id_item_riesgo, "nombre", "")}". '
					f'Nivel: "{r.get_nivel_riesgo_display()}". Estado: "{r.get_estado_display()}".'
				)
				_record_audit(request, 'riesgos', r.id_riesgo, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Amenaza creada correctamente.')
			return redirect('admin_amenazas')
	else:
		form = RiesgoForm()
	return render(request, 'core/admin/riesgo_form.html', {'form': form, 'action': 'Crear Amenaza'})


@role_required([2])
def admin_riesgo_edit(request, pk):
	riesgo = get_object_or_404(Riesgo, pk=pk)
	if request.method == 'POST':
		form = RiesgoForm(request.POST, instance=riesgo)
		if form.is_valid():
			changed = form.changed_data
			old_values = {f: getattr(riesgo, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_item_riesgo': 'Item', 'nivel_riesgo': 'Nivel', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó la amenaza {obj.nombre.upper()} con id {obj.id_riesgo} el día {fecha} afectando la tabla riesgos '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó la amenaza {obj.nombre.upper()} con id {obj.id_riesgo} el día {fecha} afectando la tabla riesgos sin cambios detectados.')
				_record_audit(request, 'riesgos', riesgo.id_riesgo, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Amenaza actualizada correctamente.')
			return redirect('admin_amenazas')
	else:
		form = RiesgoForm(instance=riesgo)
	return render(request, 'core/admin/riesgo_form.html', {'form': form, 'action': 'Editar Amenaza'})


@role_required([2])
def admin_riesgo_delete(request, pk):
	riesgo = get_object_or_404(Riesgo, pk=pk)
	if request.method == 'POST':
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó la amenaza {riesgo.nombre.upper()} identificada {riesgo.id_riesgo} el día {fecha} afectando la tabla riesgos.'
		except Exception:
			desc = None
		riesgo.delete()
		try:
			_record_audit(request, 'riesgos', riesgo.id_riesgo, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Amenaza eliminada correctamente.')
		return redirect('admin_amenazas')
	return render(request, 'core/admin/riesgo_delete_confirm.html', {'riesgo': riesgo})


@role_required([2])
def admin_controles(request):
	# list controles with optional search by nombre
	q = request.GET.get('q', '').strip()
	estado = request.GET.get('estado', '').strip()
	area = request.GET.get('area', '').strip()

	controles = Control.objects.select_related('id_riesgo', 'creado_por')
	if q:
		controles = controles.filter(nombre__icontains=q)

	# estado filter support
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			controles = controles.filter(estado__iexact=st)

	# area filter support (Control -> Riesgo -> ItemRiesgo -> Area)
	if area:
		try:
			aid = int(area)
			controles = controles.filter(id_riesgo__id_item_riesgo__id_area=aid)
		except Exception:
			pass

	areas = Area.objects.order_by('nombre')

	return render(request, 'core/admin/controles.html', {'controles': controles, 'q': q, 'estado': estado, 'areas': areas, 'area': area})


@role_required([2])
def admin_control_inspect(request, pk):
	control = get_object_or_404(Control.objects.select_related('id_riesgo', 'creado_por'), pk=pk)
	return render(request, 'core/admin/control_inspect.html', {'control': control})


@role_required([2])
def admin_control_create(request):
	if request.method == 'POST':
		form = ControlForm(request.POST)
		if form.is_valid():
			c = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					c.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			c.save()
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Control "{c.nombre}" identificado "{c.id_control}" fue creado por "{user_name}". '
					f'Riesgo: "{getattr(c.id_riesgo, "nombre", "")}". '
					f'Frecuencia: "{c.frecuencia}". Estado: "{c.get_estado_display()}".'
				)
				_record_audit(request, 'controles', c.id_control, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Control creado correctamente.')
			return redirect('admin_controles')
	else:
		form = ControlForm()
	return render(request, 'core/admin/control_form.html', {'form': form, 'action': 'Crear Control'})


@role_required([2])
def admin_control_edit(request, pk):
	control = get_object_or_404(Control, pk=pk)
	if request.method == 'POST':
		form = ControlForm(request.POST, instance=control)
		if form.is_valid():
			changed = form.changed_data
			old_values = {f: getattr(control, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_riesgo': 'Riesgo', 'frecuencia': 'Frecuencia', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó el control {obj.nombre.upper()} con id {obj.id_control} el día {fecha} afectando la tabla controles '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó el control {obj.nombre.upper()} con id {obj.id_control} el día {fecha} afectando la tabla controles sin cambios detectados.')
				_record_audit(request, 'controles', control.id_control, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Control actualizado correctamente.')
			return redirect('admin_controles')
	else:
		form = ControlForm(instance=control)
	return render(request, 'core/admin/control_form.html', {'form': form, 'action': 'Editar Control'})


@role_required([2])
def admin_control_delete(request, pk):
	control = get_object_or_404(Control, pk=pk)
	if request.method == 'POST':
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó el control {control.nombre.upper()} identificado {control.id_control} el día {fecha}.'
		except Exception:
			desc = None
		control.delete()
		try:
			_record_audit(request, 'controles', control.id_control, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Control eliminado correctamente.')
		return redirect('admin_controles')
	return render(request, 'core/admin/control_delete_confirm.html', {'control': control})


@role_required([2])
def admin_asignacion(request):
	# list assignments with optional search by usuario name or item name
	q = request.GET.get('q', '').strip()
	asignaciones = ItemResponsable.objects.select_related('id_item_riesgo', 'id_usuario', 'asignado_por')
	if q:
		asignaciones = asignaciones.filter(id_usuario__nombre__icontains=q) | asignaciones.filter(id_item_riesgo__nombre__icontains=q)

	return render(request, 'core/admin/asignacion.html', {'asignaciones': asignaciones, 'q': q})


@role_required([2])
def admin_asignacion_inspect(request, pk):
	asign = get_object_or_404(ItemResponsable.objects.select_related('id_item_riesgo', 'id_usuario', 'asignado_por'), pk=pk)
	return render(request, 'core/admin/asignacion_inspect.html', {'asign': asign})


@role_required([2])
def admin_asignacion_create(request):
	if request.method == 'POST':
		form = ItemResponsableForm(request.POST)
		if form.is_valid():
			a = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					quien = Usuario.objects.get(pk=user_id)
					a.asignado_por = quien
				except Usuario.DoesNotExist:
					pass
			try:
				a.save()
				# auditoria
				try:
					user_name = request.session.get('user_nombre', '')
					desc = f'Asignación creada: item "{getattr(a.id_item_riesgo, "nombre", "")}" asignado a "{getattr(a.id_usuario, "nombre", "")}" por "{user_name}".'
					_record_audit(request, 'item_responsable', a.id, 'ASIGNAR', desc)
				except Exception:
					pass
				messages.success(request, 'Responsable asignado correctamente.')
				return redirect('admin_asignacion')
			except IntegrityError:
				messages.error(request, 'Ya existe una asignación para este usuario y item.')
	else:
		form = ItemResponsableForm()
	return render(request, 'core/admin/asignacion_form.html', {'form': form, 'action': 'Crear Asignación'})


@role_required([2])
def admin_asignacion_edit(request, pk):
	asign = get_object_or_404(ItemResponsable, pk=pk)
	if request.method == 'POST':
		form = ItemResponsableForm(request.POST, instance=asign)
		if form.is_valid():
			try:
				# capture old values
				old_item_name = getattr(asign.id_item_riesgo, 'nombre', '')
				old_responsable_name = getattr(asign.id_usuario, 'nombre', '')
				form.save()
				# Obtener valores actuales de la instancia después del save
				new_item_name = getattr(asign.id_item_riesgo, 'nombre', '')
				new_responsable_name = getattr(asign.id_usuario, 'nombre', '')
				messages.success(request, 'Asignación actualizada correctamente.')
				# auditoria with enhanced description
				try:
					user_name = request.session.get('user_nombre', '')
					fecha = date.today().isoformat()
					desc = (f'El usuario {user_name} editó la asignación del item {old_item_name.upper()} asignado a {old_responsable_name.upper()} '
						f'con id {asign.id} el día {fecha} afectando la tabla item_responsable cambiando ITEM de {old_item_name.upper()} a {new_item_name.upper()} '
						f'y RESPONSABLE de {old_responsable_name.upper()} a {new_responsable_name.upper()}.')
					_record_audit(request, 'item_responsable', asign.id, 'EDITAR', desc)
				except Exception:
					pass
				return redirect('admin_asignacion')
			except IntegrityError:
				messages.error(request, 'La actualización causó un conflicto con una asignación existente.')
	else:
		form = ItemResponsableForm(instance=asign)
	return render(request, 'core/admin/asignacion_form.html', {'form': form, 'action': 'Editar Asignación'})


@role_required([2])
def admin_asignacion_delete(request, pk):
	asign = get_object_or_404(ItemResponsable, pk=pk)
	if request.method == 'POST':
		# capture data before deletion
		try:
			user_name = request.session.get('user_nombre', '')
			item_name = getattr(asign.id_item_riesgo, 'nombre', '')
			responsable_name = getattr(asign.id_usuario, 'nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó la asignación del item {item_name.upper()} asignado a {responsable_name.upper()} con id {asign.id} el día {fecha} afectando la tabla item_responsable.'
		except Exception:
			desc = None
		asign.delete()
		# auditoria
		try:
			_record_audit(request, 'item_responsable', asign.id, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Asignación eliminada correctamente.')
		return redirect('admin_asignacion')
	return render(request, 'core/admin/asignacion_delete_confirm.html', {'asign': asign})


@role_required([2])
def admin_auditoria(request):
	q = request.GET.get('q', '').strip()
	fecha_inicio = request.GET.get('fecha_inicio', '').strip()
	fecha_fin = request.GET.get('fecha_fin', '').strip()

	auditorias = Auditoria.objects.select_related('id_usuario').order_by('-fecha_hora')
	if q:
		auditorias = auditorias.filter(tabla_afectada__icontains=q) | auditorias.filter(accion__icontains=q) | auditorias.filter(id_usuario__nombre__icontains=q)

	# Filtrar por rango de fechas sobre 'fecha_hora' usando únicamente la porción de fecha
	if fecha_inicio:
		try:
			start_date = datetime.strptime(fecha_inicio, '%Y-%m-%d').date()
			auditorias = auditorias.filter(fecha_hora__date__gte=start_date)
		except Exception:
			pass

	if fecha_fin:
		try:
			end_date = datetime.strptime(fecha_fin, '%Y-%m-%d').date()
			auditorias = auditorias.filter(fecha_hora__date__lte=end_date)
		except Exception:
			pass

	return render(request, 'core/admin/auditoria.html', {'auditorias': auditorias, 'q': q, 'fecha_inicio': fecha_inicio, 'fecha_fin': fecha_fin})


@role_required([2])
def admin_auditoria_inspect(request, pk):
	audit = get_object_or_404(Auditoria.objects.select_related('id_usuario'), pk=pk)
	return render(request, 'core/admin/auditoria_inspect.html', {'audit': audit})


@role_required([2])
def admin_registro_chequeos(request):
	"""List all RegistroCheck entries (admin view)."""
	q = request.GET.get('q', '').strip()
	fecha_inicio = request.GET.get('fecha_inicio', '').strip()
	fecha_fin = request.GET.get('fecha_fin', '').strip()

	registros = RegistroCheck.objects.select_related('id_control__id_riesgo__id_item_riesgo', 'id_usuario').order_by('-fecha_check', '-hora_check')
	if q:
		registros = registros.filter(id_usuario__nombre__icontains=q) | registros.filter(id_control__nombre__icontains=q)

	# Filtrar por rango de fechas (formato esperado YYYY-MM-DD)
	if fecha_inicio:
		try:
			start_date = datetime.strptime(fecha_inicio, '%Y-%m-%d').date()
			registros = registros.filter(fecha_check__gte=start_date)
		except Exception:
			# ignore invalid date
			pass

	if fecha_fin:
		try:
			end_date = datetime.strptime(fecha_fin, '%Y-%m-%d').date()
			registros = registros.filter(fecha_check__lte=end_date)
		except Exception:
			pass

	return render(request, 'core/admin/registro_chequeos.html', {'registros': registros, 'q': q, 'fecha_inicio': fecha_inicio, 'fecha_fin': fecha_fin})


@role_required([2])
def admin_registro_inspect(request, pk):
	"""Show a detailed view for a single RegistroCheck (admin)."""
	rc = get_object_or_404(RegistroCheck.objects.select_related('id_control__id_riesgo__id_item_riesgo', 'id_usuario'), pk=pk)
	return render(request, 'core/admin/registro_inspect.html', {'rc': rc})


@role_required([2])
def admin_revision(request):
	"""Show controls assigned to the logged-in user (via ItemResponsable) and allow daily checks.

	- Lists controls whose item's id_item_riesgo is assigned to the current user.
	- Allows checking controls (one RegistroCheck per control/user/date). If a control
	  has already been checked today, the checkbox is shown as checked and disabled.
	- On POST, creates RegistroCheck rows for newly checked controls and records auditoria.
	"""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	from datetime import date

	today = date.today()

	# find assigned item ids for this user, but only assignments and items that are active
	# support legacy stored values ('1'/'0') as well as 'activo'/'inactivo'
	active_states_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	active_item_state_q = Q(id_item_riesgo__estado__iexact='activo') | Q(id_item_riesgo__estado__in=['1', '1.0'])

	assigned_item_ids = ItemResponsable.objects.filter(
		id_usuario=usuario
	).filter(
		active_states_q,
		active_item_state_q
	).values_list('id_item_riesgo', flat=True)

	# find controls for those items; only include controls that are active and whose related amenaza is active
	control_active_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	riesgo_active_q = Q(id_riesgo__estado__iexact='activo') | Q(id_riesgo__estado__in=['1', '1.0'])

	controles = Control.objects.filter(
		id_riesgo__id_item_riesgo__in=assigned_item_ids
	).filter(
		control_active_q,
		riesgo_active_q
	).select_related('id_riesgo__id_item_riesgo').order_by('nombre')

	# map control.id_control -> RegistroCheck if exists for today
	existing_checks = RegistroCheck.objects.filter(id_usuario=usuario, fecha_check=today, id_control__in=[c.id_control for c in controles])
	checked_map = {rc.id_control_id: rc for rc in existing_checks}

	if request.method == 'POST':
		# posted 'check' values are control ids
		posted = request.POST.getlist('check')
		posted_ids = set()
		for v in posted:
			try:
				posted_ids.add(int(v))
			except Exception:
				continue

		created = []
		skipped = []
		for c in controles:
			cid = c.id_control
			if cid in posted_ids:
				# El usuario marcó este control
				if cid in checked_map:
					# already checked today -> skip
					skipped.append(c.nombre)
					continue
				# create RegistroCheck
				try:
					# allow an observation per control (field name: obs_<control_id>)
					obs_key = f'obs_{cid}'
					obs_val = request.POST.get(obs_key, '').strip()
					rc = RegistroCheck.objects.create(id_control=c, id_usuario=usuario, fecha_check=today, estado='CUMPLE', observaciones=obs_val)
					created.append(c.nombre)
					# record audit per check
					try:
						# more human-readable audit description
						desc = (
							f'Control "{c.nombre}" identificado "{c.id_control}" fue marcado por "{usuario.nombre}" el dia "{today.isoformat()}".'
						)
						if obs_val:
							desc += f' Observaciones: "{obs_val}"'
						_record_audit(request, 'registro_checks', rc.id_check, 'CREAR', desc)
					except Exception:
						pass
				except Exception as exc:
					logger.error('Failed to create RegistroCheck for control %s user %s: %s', c.id_control, usuario.id_usuario, exc)
			else:
				# No se envió esta casilla; si ya existe un check hoy, no se elimina
				if cid in checked_map:
					# attempted uncheck - not allowed same day
					skipped.append(c.nombre)

		if created:
			messages.success(request, f"Se registraron {len(created)} chequeo(s): {', '.join(created)}")
		if skipped and not created:
			messages.warning(request, f"Los siguientes controles ya estaban marcados hoy y no se pueden desmarcar: {', '.join(skipped)}")
		elif skipped and created:
			messages.info(request, f"Algunos controles ya estaban marcados y se dejaron sin cambios: {', '.join(skipped)}")

		# refresh page to show updated state
		return redirect('admin_revision')

	# prepare list with flag whether checked today
	controles_with_state = []
	for c in controles:
		is_checked = c.id_control in checked_map
		observation = ''
		if is_checked:
			rc = checked_map.get(c.id_control)
			try:
				observation = rc.observaciones or ''
			except Exception:
				observation = ''
		controles_with_state.append({'control': c, 'is_checked': is_checked, 'observation': observation})

	# Formatear 'today' como cadena legible en español para mostrar (ej.: '4 de marzo de 2026')
	try:
		months = [
			'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
			'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
		]
		today_display = f"{today.day} de {months[today.month - 1]} de {today.year}"
	except Exception:
		today_display = str(today)

	return render(request, 'core/admin/revision.html', {'controles': controles_with_state, 'usuario': usuario, 'today': today_display})


@role_required([3])
def responsable_revision(request):
	"""Same logic as admin_revision but for Responsable role and templates/urls separated."""
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	from datetime import date

	today = date.today()

	active_states_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	active_item_state_q = Q(id_item_riesgo__estado__iexact='activo') | Q(id_item_riesgo__estado__in=['1', '1.0'])

	assigned_item_ids = ItemResponsable.objects.filter(
		id_usuario=usuario
	).filter(
		active_states_q,
		active_item_state_q
	).values_list('id_item_riesgo', flat=True)

	control_active_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	riesgo_active_q = Q(id_riesgo__estado__iexact='activo') | Q(id_riesgo__estado__in=['1', '1.0'])

	controles = Control.objects.filter(
		id_riesgo__id_item_riesgo__in=assigned_item_ids
	).filter(
		control_active_q,
		riesgo_active_q
	).select_related('id_riesgo__id_item_riesgo').order_by('nombre')

	existing_checks = RegistroCheck.objects.filter(id_usuario=usuario, fecha_check=today, id_control__in=[c.id_control for c in controles])
	checked_map = {rc.id_control_id: rc for rc in existing_checks}

	if request.method == 'POST':
		posted = request.POST.getlist('check')
		posted_ids = set()
		for v in posted:
			try:
				posted_ids.add(int(v))
			except Exception:
				continue

		created = []
		skipped = []
		for c in controles:
			cid = c.id_control
			if cid in posted_ids:
				if cid in checked_map:
					skipped.append(c.nombre)
					continue
				try:
					obs_key = f'obs_{cid}'
					obs_val = request.POST.get(obs_key, '').strip()
					rc = RegistroCheck.objects.create(id_control=c, id_usuario=usuario, fecha_check=today, estado='CUMPLE', observaciones=obs_val)
					created.append(c.nombre)
					try:
						desc = (
							f'Control "{c.nombre}" identificado "{c.id_control}" fue marcado por "{usuario.nombre}" el dia "{today.isoformat()}".'
						)
						if obs_val:
							desc += f' Observaciones: "{obs_val}"'
						_record_audit(request, 'registro_checks', rc.id_check, 'CREAR', desc)
					except Exception:
						pass
				except Exception as exc:
					logger.error('Failed to create RegistroCheck for control %s user %s: %s', c.id_control, usuario.id_usuario, exc)
			else:
				if cid in checked_map:
					skipped.append(c.nombre)

		if created:
			messages.success(request, f"Se registraron {len(created)} chequeo(s): {', '.join(created)}")
		if skipped and not created:
			messages.warning(request, f"Los siguientes controles ya estaban marcados hoy y no se pueden desmarcar: {', '.join(skipped)}")
		elif skipped and created:
			messages.info(request, f"Algunos controles ya estaban marcados y se dejaron sin cambios: {', '.join(skipped)}")

		return redirect('responsable_revision')

	controles_with_state = []
	for c in controles:
		is_checked = c.id_control in checked_map
		observation = ''
		if is_checked:
			rc = checked_map.get(c.id_control)
			try:
				observation = rc.observaciones or ''
			except Exception:
				observation = ''
		controles_with_state.append({'control': c, 'is_checked': is_checked, 'observation': observation})

	try:
		months = [
			'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
			'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
		]
		today_display = f"{today.day} de {months[today.month - 1]} de {today.year}"
	except Exception:
		today_display = str(today)

	return render(request, 'core/responsable/revision_responsable.html', {'controles': controles_with_state, 'usuario': usuario, 'today': today_display})


# Vista 'inicio_responsable' eliminada; responsables se redirigen a 'responsable_profile' en el login.


# -----------------------------
# Vistas para Superadmin (rol 1)
# Duplican plantillas en core/superadmin/*.html. Mantener la lógica ya existente sin refactorizar.
# -----------------------------


@role_required([1])
def superadmin_profile(request):
	user_id = request.session.get('user_id')
	usuario = None
	if user_id:
		try:
			usuario = Usuario.objects.get(pk=user_id)
		except Usuario.DoesNotExist:
			usuario = None
	return render(request, 'core/superadmin/profile_superadmin.html', {'usuario': usuario, 'today': date.today()})


@role_required([1])
def superadmin_change_password(request):
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	if request.method == 'POST':
		old = request.POST.get('old_password', '')
		new = request.POST.get('new_password', '')
		confirm = request.POST.get('confirm_password', '')

		errors = []
		if not usuario.check_password(old):
			errors.append('La contraseña anterior no es correcta.')
		if not new:
			errors.append('La nueva contraseña no puede estar vacía.')
		if new != confirm:
			errors.append('La confirmación no coincide con la nueva contraseña.')

		if errors:
			for e in errors:
				messages.error(request, e)
		else:
			usuario.password_hash = make_password(new)
			usuario.save()
			messages.success(request, 'Contraseña actualizada correctamente.')
			return redirect('superadmin_profile')

	return render(request, 'core/superadmin/change_password_superadmin.html', {'usuario': usuario})


@role_required([1])

def superadmin_items(request):
	# Igual que admin_items: aplicar búsqueda por nombre y filtros de estado y área
	q = request.GET.get('q', '').strip()
	estado = request.GET.get('estado', '').strip()
	area = request.GET.get('area', '').strip()

	items = ItemRiesgo.objects.select_related('id_area', 'creado_por')
	if q:
		items = items.filter(nombre__icontains=q)

	# estado filter support
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			items = items.filter(estado__iexact=st)

	# area filter support
	if area:
		try:
			aid = int(area)
			items = items.filter(id_area=aid)
		except Exception:
			pass

	areas = Area.objects.order_by('nombre')

	return render(request, 'core/superadmin/items_superadmin.html', {'items': items, 'q': q, 'estado': estado, 'areas': areas, 'area': area})


@role_required([1])
def superadmin_item_inspect(request, pk):
	item = get_object_or_404(ItemRiesgo, pk=pk)
	return render(request, 'core/superadmin/item_inspect_superadmin.html', {'item': item})


@role_required([1])
def superadmin_item_create(request):
	if request.method == 'POST':
		form = ItemRiesgoForm(request.POST)
		if form.is_valid():
			item = form.save(commit=False)
			# set creador from session
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					item.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			item.save()
			# auditoria (detalle)
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Item "{item.nombre}" identificado "{item.id_item_riesgo}" fue creado por "{user_name}". '
					f'Área: "{getattr(item.id_area, "nombre", "")}". '
					f'Criticidad: "{item.get_criticidad_display()}". Estado: "{item.get_estado_display()}".'
				)
				_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Item creado correctamente.')
			return redirect('superadmin_items')
	else:
		form = ItemRiesgoForm()
	return render(request, 'core/superadmin/item_form_superadmin.html', {'form': form, 'action': 'Crear Item'})


@role_required([1])
def superadmin_item_edit(request, pk):
	item = get_object_or_404(ItemRiesgo, pk=pk)
	if request.method == 'POST':
		form = ItemRiesgoForm(request.POST, instance=item)
		if form.is_valid():
			changed = form.changed_data
			old_values = {f: getattr(item, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_area': 'Área', 'criticidad': 'Criticidad', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó el item {obj.nombre.upper()} con id {obj.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó el item {obj.nombre.upper()} con id {obj.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos sin cambios detectados.')
				_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Item actualizado correctamente.')
			return redirect('superadmin_items')
	else:
		form = ItemRiesgoForm(instance=item)
	return render(request, 'core/superadmin/item_form_superadmin.html', {'form': form, 'action': 'Editar Item', 'item': item})


@role_required([1])

def superadmin_amenazas(request):
	# Igual que admin_amenazas: búsqueda por nombre y filtros de área/estado
	q = request.GET.get('q', '').strip()
	area = request.GET.get('area', '').strip()
	estado = request.GET.get('estado', '').strip()

	riesgos = Riesgo.objects.select_related('id_item_riesgo', 'creado_por')
	if q:
		riesgos = riesgos.filter(nombre__icontains=q)

	# estado filter support
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			riesgos = riesgos.filter(estado__iexact=st)

	# area filter (via riesgo -> item -> area)
	if area:
		try:
			aid = int(area)
			riesgos = riesgos.filter(id_item_riesgo__id_area=aid)
		except Exception:
			pass

	areas = Area.objects.order_by('nombre')

	return render(request, 'core/superadmin/amenazas_superadmin.html', {'riesgos': riesgos, 'q': q, 'areas': areas, 'area': area, 'estado': estado})


@role_required([1])
def superadmin_riesgo_create(request):
	if request.method == 'POST':
		form = RiesgoForm(request.POST)
		if form.is_valid():
			r = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					r.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			r.save()
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Riesgo "{r.nombre}" identificado "{r.id_riesgo}" fue creado por "{user_name}". '
					f'Item: "{getattr(r.id_item_riesgo, "nombre", "")}". '
					f'Nivel: "{r.get_nivel_riesgo_display()}". Estado: "{r.get_estado_display()}".'
				)
				_record_audit(request, 'riesgos', r.id_riesgo, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Amenaza creada correctamente.')
			return redirect('superadmin_amenazas')
	else:
		form = RiesgoForm()
	return render(request, 'core/superadmin/riesgo_form_superadmin.html', {'form': form, 'action': 'Crear Amenaza'})


@role_required([1])
def superadmin_riesgo_edit(request, pk):
	riesgo = get_object_or_404(Riesgo, pk=pk)
	if request.method == 'POST':
		form = RiesgoForm(request.POST, instance=riesgo)
		if form.is_valid():
			changed = form.changed_data
			old_values = {f: getattr(riesgo, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_item_riesgo': 'Item', 'nivel_riesgo': 'Nivel', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó la amenaza {obj.nombre.upper()} con id {obj.id_riesgo} el día {fecha} afectando la tabla riesgos '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó la amenaza {obj.nombre.upper()} con id {obj.id_riesgo} el día {fecha} afectando la tabla riesgos sin cambios detectados.')
				_record_audit(request, 'riesgos', riesgo.id_riesgo, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Amenaza actualizada correctamente.')
			return redirect('superadmin_amenazas')
	else:
		form = RiesgoForm(instance=riesgo)
	return render(request, 'core/superadmin/riesgo_form_superadmin.html', {'form': form, 'action': 'Editar Amenaza'})


@role_required([1])
def superadmin_riesgo_inspect(request, pk):
	riesgo = get_object_or_404(Riesgo, pk=pk)
	return render(request, 'core/superadmin/riesgo_inspect_superadmin.html', {'riesgo': riesgo})


@role_required([1])

def superadmin_controles(request):
	# Igual que admin_controles: búsqueda por nombre y filtros de estado/área
	q = request.GET.get('q', '').strip()
	estado = request.GET.get('estado', '').strip()
	area = request.GET.get('area', '').strip()

	controles = Control.objects.select_related('id_riesgo', 'creado_por')
	if q:
		controles = controles.filter(nombre__icontains=q)

	# estado filter support
	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			controles = controles.filter(estado__iexact=st)

	# area filter support (Control -> Riesgo -> ItemRiesgo -> Area)
	if area:
		try:
			aid = int(area)
			controles = controles.filter(id_riesgo__id_item_riesgo__id_area=aid)
		except Exception:
			pass

	areas = Area.objects.order_by('nombre')

	return render(request, 'core/superadmin/controles_superadmin.html', {'controles': controles, 'q': q, 'estado': estado, 'areas': areas, 'area': area})


@role_required([1])
def superadmin_control_inspect(request, pk):
	control = get_object_or_404(Control, pk=pk)
	return render(request, 'core/superadmin/control_inspect_superadmin.html', {'control': control})


@role_required([1])
def superadmin_control_create(request):
	if request.method == 'POST':
		form = ControlForm(request.POST)
		if form.is_valid():
			c = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					creador = Usuario.objects.get(pk=user_id)
					c.creado_por = creador
				except Usuario.DoesNotExist:
					pass
			c.save()
			try:
				user_name = request.session.get('user_nombre', '')
				desc = (
					f'Control "{c.nombre}" identificado "{c.id_control}" fue creado por "{user_name}". '
					f'Riesgo: "{getattr(c.id_riesgo, "nombre", "")}". '
					f'Frecuencia: "{c.frecuencia}". Estado: "{c.get_estado_display()}".'
				)
				_record_audit(request, 'controles', c.id_control, 'CREAR', desc)
			except Exception:
				pass
			messages.success(request, 'Control creado correctamente.')
			return redirect('superadmin_controles')
	else:
		form = ControlForm()
	return render(request, 'core/superadmin/control_form_superadmin.html', {'form': form, 'action': 'Crear Control'})


@role_required([1])
def superadmin_control_edit(request, pk):
	control = get_object_or_404(Control, pk=pk)
	if request.method == 'POST':
		form = ControlForm(request.POST, instance=control)
		if form.is_valid():
			changed = form.changed_data
			old_values = {f: getattr(control, f) for f in changed}
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				fecha = date.today().isoformat()
				field_labels = {'nombre': 'Nombre', 'descripcion': 'Descripción', 'id_riesgo': 'Riesgo', 'frecuencia': 'Frecuencia', 'estado': 'Estado'}
				if changed:
					parts = []
					for f in changed:
						old = old_values.get(f)
						new = getattr(obj, f)
						if hasattr(old, 'nombre'):
							old = getattr(old, 'nombre', str(old))
						if hasattr(new, 'nombre'):
							new = getattr(new, 'nombre', str(new))
						label = field_labels.get(f, f)
						parts.append(f'{label.upper()} que contenía {str(old).upper()} ahora siendo {label.upper()} que contiene {str(new).upper()}')
					parts_str = '; '.join(parts)
					desc = (f'El usuario {user_name} editó el control {obj.nombre.upper()} con id {obj.id_control} el día {fecha} afectando la tabla controles '
						f'cambiando {parts_str}.')
				else:
					desc = (f'El usuario {user_name} editó el control {obj.nombre.upper()} con id {obj.id_control} el día {fecha} afectando la tabla controles sin cambios detectados.')
				_record_audit(request, 'controles', control.id_control, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Control actualizado correctamente.')
			return redirect('superadmin_controles')
	else:
		form = ControlForm(instance=control)
	return render(request, 'core/superadmin/control_form_superadmin.html', {'form': form, 'action': 'Editar Control'})


@role_required([1])

def superadmin_asignacion(request):
	# Igual que admin_asignacion: permitir búsqueda por nombre de usuario o del item
	q = request.GET.get('q', '').strip()
	asignaciones = ItemResponsable.objects.select_related('id_item_riesgo', 'id_usuario', 'asignado_por')
	if q:
		asignaciones = asignaciones.filter(id_usuario__nombre__icontains=q) | asignaciones.filter(id_item_riesgo__nombre__icontains=q)

	return render(request, 'core/superadmin/asignacion_superadmin.html', {'asignaciones': asignaciones, 'q': q})


@role_required([1])
def superadmin_asignacion_create(request):
	if request.method == 'POST':
		form = ItemResponsableForm(request.POST)
		if form.is_valid():
			a = form.save(commit=False)
			user_id = request.session.get('user_id')
			if user_id:
				try:
					quien = Usuario.objects.get(pk=user_id)
					a.asignado_por = quien
				except Usuario.DoesNotExist:
					pass
			try:
				a.save()
				try:
					user_name = request.session.get('user_nombre', '')
					desc = f'Asignación creada: item "{getattr(a.id_item_riesgo, "nombre", "")}" asignado a "{getattr(a.id_usuario, "nombre", "")}" por "{user_name}".'
					_record_audit(request, 'item_responsable', a.id, 'ASIGNAR', desc)
				except Exception:
					pass
				messages.success(request, 'Responsable asignado correctamente.')
				return redirect('superadmin_asignacion')
			except IntegrityError:
				messages.error(request, 'Ya existe una asignación para este usuario y item.')
	else:
		form = ItemResponsableForm()
	return render(request, 'core/superadmin/asignacion_form_superadmin.html', {'form': form, 'action': 'Crear Asignación'})


@role_required([1])
def superadmin_asignacion_inspect(request, pk):
	asign = get_object_or_404(ItemResponsable, pk=pk)
	return render(request, 'core/superadmin/asignacion_inspect_superadmin.html', {'asign': asign})


@role_required([1])
def superadmin_asignacion_edit(request, pk):
	asign = get_object_or_404(ItemResponsable, pk=pk)
	if request.method == 'POST':
		form = ItemResponsableForm(request.POST, instance=asign)
		if form.is_valid():
			try:
				# capture old values
				old_item_name = getattr(asign.id_item_riesgo, 'nombre', '')
				old_responsable_name = getattr(asign.id_usuario, 'nombre', '')
				form.save()
				new_item_name = getattr(asign.id_item_riesgo, 'nombre', '')
				new_responsable_name = getattr(asign.id_usuario, 'nombre', '')
				messages.success(request, 'Asignación actualizada correctamente.')
				# auditoria with enhanced description
				try:
					user_name = request.session.get('user_nombre', '')
					fecha = date.today().isoformat()
					desc = (f'El usuario {user_name} editó la asignación del item {old_item_name.upper()} asignado a {old_responsable_name.upper()} '
						f'con id {asign.id} el día {fecha} afectando la tabla item_responsable cambiando ITEM de {old_item_name.upper()} a {new_item_name.upper()} '
						f'y RESPONSABLE de {old_responsable_name.upper()} a {new_responsable_name.upper()}.')
					_record_audit(request, 'item_responsable', asign.id, 'EDITAR', desc)
				except Exception:
					pass
				return redirect('superadmin_asignacion')
			except IntegrityError:
				messages.error(request, 'La actualización causó un conflicto con una asignación existente.')
	else:
		form = ItemResponsableForm(instance=asign)
	return render(request, 'core/superadmin/asignacion_form_superadmin.html', {'form': form, 'action': 'Editar Asignación'})


@role_required([1])
def superadmin_auditoria(request):
	q = request.GET.get('q', '').strip()
	fecha_inicio = request.GET.get('fecha_inicio', '').strip()
	fecha_fin = request.GET.get('fecha_fin', '').strip()

	auditorias = Auditoria.objects.select_related('id_usuario').order_by('-fecha_hora')
	if q:
		auditorias = auditorias.filter(tabla_afectada__icontains=q) | auditorias.filter(accion__icontains=q) | auditorias.filter(id_usuario__nombre__icontains=q)

	# date range filtering on fecha_hora (use date portion). Accept common formats.
	def _parse_date(s):
		for fmt in ('%Y-%m-%d', '%d/%m/%Y'):
			try:
				return datetime.strptime(s, fmt).date()
			except Exception:
				continue
		return None

	if fecha_inicio:
		sd = _parse_date(fecha_inicio)
		if sd:
			try:
				auditorias = auditorias.filter(fecha_hora__date__gte=sd)
			except Exception:
				pass

	if fecha_fin:
		ed = _parse_date(fecha_fin)
		if ed:
			try:
				auditorias = auditorias.filter(fecha_hora__date__lte=ed)
			except Exception:
				pass

	return render(request, 'core/superadmin/auditoria_superadmin.html', {'auditorias': auditorias, 'q': q, 'fecha_inicio': fecha_inicio, 'fecha_fin': fecha_fin})


@role_required([1])
def superadmin_auditoria_inspect(request, pk):
	log = get_object_or_404(Auditoria, pk=pk)
	# La plantilla espera la variable 'audit' (coincide con la nomenclatura usada en admin)
	return render(request, 'core/superadmin/auditoria_inspect_superadmin.html', {'audit': log})


@role_required([1])

def superadmin_registro_chequeos(request):
	# Igual que admin_registro_chequeos: soporte de búsqueda y rango de fechas; ordenar por fecha/hora descendente
	q = request.GET.get('q', '').strip()
	fecha_inicio = request.GET.get('fecha_inicio', '').strip()
	fecha_fin = request.GET.get('fecha_fin', '').strip()

	registros = RegistroCheck.objects.select_related('id_control__id_riesgo__id_item_riesgo', 'id_usuario').order_by('-fecha_check', '-hora_check')
	if q:
		registros = registros.filter(id_usuario__nombre__icontains=q) | registros.filter(id_control__nombre__icontains=q)

	# date range filtering (expects YYYY-MM-DD)
	if fecha_inicio:
		try:
			start_date = datetime.strptime(fecha_inicio, '%Y-%m-%d').date()
			registros = registros.filter(fecha_check__gte=start_date)
		except Exception:
			pass

	if fecha_fin:
		try:
			end_date = datetime.strptime(fecha_fin, '%Y-%m-%d').date()
			registros = registros.filter(fecha_check__lte=end_date)
		except Exception:
			pass

	return render(request, 'core/superadmin/registro_chequeos_superadmin.html', {'registros': registros, 'q': q, 'fecha_inicio': fecha_inicio, 'fecha_fin': fecha_fin})


@role_required([1])

def superadmin_registro_inspect(request, pk):
	# Comportamiento análogo a admin: usar select_related para obtener campos relacionados y registrar auditoría de inspección
	rc = get_object_or_404(RegistroCheck.objects.select_related('id_control__id_riesgo__id_item_riesgo', 'id_usuario'), pk=pk)
	return render(request, 'core/superadmin/registro_inspect_superadmin.html', {'rc': rc})


@role_required([1])
def superadmin_usuarios(request):
	"""List and filter Usuarios for superadmin."""
	q = request.GET.get('q', '').strip()
	estado = request.GET.get('estado', '').strip()
	sede = request.GET.get('sede', '').strip()
	area = request.GET.get('area', '').strip()
	rol = request.GET.get('rol', '').strip()

	usuarios = Usuario.objects.select_related('id_rol', 'id_sede', 'id_area')
	if q:
		# Usar Q para combinar condiciones OR de forma segura al encadenar filtros
		usuarios = usuarios.filter(Q(nombre__icontains=q) | Q(correo__icontains=q))

	if estado:
		st = estado.lower()
		if st in ('1', '0'):
			st = 'activo' if st == '1' else 'inactivo'
		if st in ('activo', 'inactivo'):
			usuarios = usuarios.filter(estado__iexact=st)

	if sede:
		try:
			sid = int(sede)
			usuarios = usuarios.filter(id_sede=sid)
		except Exception:
			pass

	if area:
		try:
			aid = int(area)
			usuarios = usuarios.filter(id_area=aid)
		except Exception:
			pass

	# Filtrar por rol (id_rol)
	if rol:
		try:
			rid = int(rol)
			usuarios = usuarios.filter(id_rol=rid)
		except Exception:
			# permitir filtrar también por nombre de rol
			usuarios = usuarios.filter(id_rol__nombre__icontains=rol)

	roles = Role.objects.order_by('nombre')
	sedes = Sede.objects.order_by('nombre')
	areas = Area.objects.order_by('nombre')

	return render(request, 'core/superadmin/usuarios_superadmin.html', {
		'usuarios': usuarios,
		'q': q,
		'estado': estado,
		'roles': roles,
		'sedes': sedes,
		'areas': areas,
		'sede': sede,
		'area': area,
		'rol': rol,
	})


@role_required([1])
def superadmin_usuario_inspect(request, pk):
	u = get_object_or_404(Usuario.objects.select_related('id_rol', 'id_sede', 'id_area'), pk=pk)
	return render(request, 'core/superadmin/usuario_inspect_superadmin.html', {'usuario': u})


@role_required([1])
def superadmin_usuario_create(request):
	if request.method == 'POST':
		form = UsuarioForm(request.POST)
		# Validar el formulario antes de procesar datos
		if form.is_valid():
				# Si el creador es Superadmin (rol 1), exigir contraseña y todos los campos
			creator_role = request.session.get('user_rol')
			if creator_role == 1:
				pwd = request.POST.get('password', '').strip()
				if not pwd:
					# Añadir error de formulario explícito para que la plantilla muestre el campo contraseña
					form.add_error('password', 'Contraseña obligatoria cuando un Superadministrador crea un usuario.')
					# Se re-renderizará el formulario con los errores
				else:
					# Todos los datos válidos: guardar instancia
					u = form.save()
					try:
						user_name = request.session.get('user_nombre', '')
						desc = f'Usuario "{u.nombre}" creado por "{user_name}".'
						_record_audit(request, 'usuarios', u.id_usuario, 'CREAR', desc)
					except Exception:
						pass
					messages.success(request, 'Usuario creado correctamente.')
					return redirect('superadmin_usuarios')
			else:
				# creator is not superadmin — normal behavior
				u = form.save()
				try:
					user_name = request.session.get('user_nombre', '')
					desc = f'Usuario "{u.nombre}" creado por "{user_name}".'
					_record_audit(request, 'usuarios', u.id_usuario, 'CREAR', desc)
				except Exception:
					pass
				messages.success(request, 'Usuario creado correctamente.')
				return redirect('superadmin_usuarios')
	else:
		form = UsuarioForm()
	return render(request, 'core/superadmin/usuario_form_superadmin.html', {'form': form, 'action': 'Crear Usuario'})


@role_required([1])
def superadmin_usuario_edit(request, pk):
	u = get_object_or_404(Usuario, pk=pk)
	if request.method == 'POST':
		form = UsuarioForm(request.POST, instance=u)
		if form.is_valid():
			obj = form.save()
			try:
				user_name = request.session.get('user_nombre', '')
				desc = f'Usuario "{obj.nombre}" id {obj.id_usuario} editado por "{user_name}".'
				_record_audit(request, 'usuarios', obj.id_usuario, 'EDITAR', desc)
			except Exception:
				pass
			messages.success(request, 'Usuario actualizado correctamente.')
			return redirect('superadmin_usuarios')
	else:
		form = UsuarioForm(instance=u)
	return render(request, 'core/superadmin/usuario_form_superadmin.html', {'form': form, 'action': 'Editar Usuario', 'usuario': u})


@role_required([1])
def superadmin_usuario_reset_password(request, pk):
	"""Allow superadmin to reset the password of a selected user (no old password required).

	GET: show form with 'new' and 'confirm' fields.
	POST: validate both match and set hashed password on the Usuario.password_hash.
	"""
	u = get_object_or_404(Usuario, pk=pk)
	if request.method == 'POST':
		new = request.POST.get('new_password', '')
		confirm = request.POST.get('confirm_password', '')
		errors = []
		if not new:
			errors.append('La nueva contraseña no puede estar vacía.')
		if new != confirm:
			errors.append('La confirmación no coincide con la nueva contraseña.')

		if errors:
			for e in errors:
				messages.error(request, e)
		else:
			try:
				u.password_hash = make_password(new)
				u.save()
				# auditoria
				try:
					user_name = request.session.get('user_nombre', '')
					desc = f'Contraseña del usuario "{u.nombre}" (id {u.id_usuario}) reestablecida por "{user_name}".'
					_record_audit(request, 'usuarios', u.id_usuario, 'EDITAR', desc)
				except Exception:
					pass
				messages.success(request, 'Contraseña actualizada correctamente.')
				return redirect('superadmin_usuario_inspect', pk=u.id_usuario)
			except Exception as exc:
				messages.error(request, 'Error al actualizar la contraseña.')

	return render(request, 'core/superadmin/usuario_reset_password_superadmin.html', {'usuario': u})


@role_required([1])
def superadmin_usuario_delete(request, pk):
	u = get_object_or_404(Usuario, pk=pk)
	if request.method == 'POST':
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó el usuario {u.nombre.upper()} identificado {u.id_usuario} el día {fecha} afectando la tabla usuarios.'
		except Exception:
			desc = None
		u.delete()
		try:
			_record_audit(request, 'usuarios', u.id_usuario, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Usuario eliminado correctamente.')
		return redirect('superadmin_usuarios')
	return render(request, 'core/superadmin/usuario_delete_confirm_superadmin.html', {'usuario': u})


@role_required([1])
def superadmin_revision(request):
	# Replica de admin_revision: mostrar controles asignados al usuario
	user_id = request.session.get('user_id')
	if not user_id:
		return redirect('login')

	try:
		usuario = Usuario.objects.get(pk=user_id)
	except Usuario.DoesNotExist:
		return redirect('login')

	from datetime import date

	today = date.today()

	# find assigned item ids for this user (only active assignments/items)
	active_states_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	active_item_state_q = Q(id_item_riesgo__estado__iexact='activo') | Q(id_item_riesgo__estado__in=['1', '1.0'])

	assigned_item_ids = ItemResponsable.objects.filter(
		id_usuario=usuario
	).filter(
		active_states_q,
		active_item_state_q
	).values_list('id_item_riesgo', flat=True)

	# find controls for those items; only include controls that are active and whose related amenaza is active
	control_active_q = Q(estado__iexact='activo') | Q(estado__in=['1', '1.0'])
	riesgo_active_q = Q(id_riesgo__estado__iexact='activo') | Q(id_riesgo__estado__in=['1', '1.0'])

	controles = Control.objects.filter(
		id_riesgo__id_item_riesgo__in=assigned_item_ids
	).filter(
		control_active_q,
		riesgo_active_q
	).select_related('id_riesgo__id_item_riesgo').order_by('nombre')

	# map control.id_control -> RegistroCheck if exists for today
	existing_checks = RegistroCheck.objects.filter(id_usuario=usuario, fecha_check=today, id_control__in=[c.id_control for c in controles])
	checked_map = {rc.id_control_id: rc for rc in existing_checks}

	if request.method == 'POST':
		posted = request.POST.getlist('check')
		posted_ids = set()
		for v in posted:
			try:
				posted_ids.add(int(v))
			except Exception:
				continue

		created = []
		skipped = []
		for c in controles:
			cid = c.id_control
			if cid in posted_ids:
				if cid in checked_map:
					skipped.append(c.nombre)
					continue
				try:
					obs_key = f'obs_{cid}'
					obs_val = request.POST.get(obs_key, '').strip()
					rc = RegistroCheck.objects.create(id_control=c, id_usuario=usuario, fecha_check=today, estado='CUMPLE', observaciones=obs_val)
					created.append(c.nombre)
					try:
						desc = (f'Control "{c.nombre}" identificado "{c.id_control}" fue marcado por "{usuario.nombre}" el dia "{today.isoformat()}".')
						if obs_val:
							desc += f' Observaciones: "{obs_val}"'
						_record_audit(request, 'registro_checks', rc.id_check, 'CREAR', desc)
					except Exception:
						pass
				except Exception as exc:
					logger.error('Failed to create RegistroCheck for control %s user %s: %s', c.id_control, usuario.id_usuario, exc)
			else:
				if cid in checked_map:
					skipped.append(c.nombre)

		if created:
			messages.success(request, f"Se registraron {len(created)} chequeo(s): {', '.join(created)}")
		if skipped and not created:
			messages.warning(request, f"Los siguientes controles ya estaban marcados hoy y no se pueden desmarcar: {', '.join(skipped)}")
		elif skipped and created:
			messages.info(request, f"Algunos controles ya estaban marcados y se dejaron sin cambios: {', '.join(skipped)}")

		return redirect('superadmin_revision')

	controles_with_state = []
	for c in controles:
		is_checked = c.id_control in checked_map
		observation = ''
		if is_checked:
			rc = checked_map.get(c.id_control)
			try:
				observation = rc.observaciones or ''
			except Exception:
				observation = ''
		controles_with_state.append({'control': c, 'is_checked': is_checked, 'observation': observation})

	try:
		months = [
			'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
			'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
		]
		today_display = f"{today.day} de {months[today.month - 1]} de {today.year}"
	except Exception:
		today_display = str(today)

	return render(request, 'core/superadmin/revision_superadmin.html', {'controles': controles_with_state, 'usuario': usuario, 'today': today_display})


@role_required([1])
def superadmin_item_delete(request, pk):
	item = get_object_or_404(ItemRiesgo, pk=pk)
	if request.method == 'POST':
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó el item {item.nombre.upper()} identificado {item.id_item_riesgo} el día {fecha} afectando la tabla items_riesgos.'
		except Exception:
			desc = None
		item.delete()
		try:
			_record_audit(request, 'items_riesgos', item.id_item_riesgo, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Item eliminado correctamente.')
		return redirect('superadmin_items')
	return render(request, 'core/superadmin/item_delete_confirm_superadmin.html', {'item': item})


@role_required([1])
def superadmin_riesgo_delete(request, pk):
	riesgo = get_object_or_404(Riesgo, pk=pk)
	if request.method == 'POST':
		try:
			user_name = request.session.get('user_nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó la amenaza {riesgo.nombre.upper()} identificada {riesgo.id_riesgo} el día {fecha} afectando la tabla riesgos.'
		except Exception:
			desc = None
		riesgo.delete()
		try:
			_record_audit(request, 'riesgos', riesgo.id_riesgo, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Amenaza eliminada correctamente.')
		return redirect('superadmin_amenazas')
	return render(request, 'core/superadmin/riesgo_delete_confirm_superadmin.html', {'riesgo': riesgo})


@role_required([1])
def superadmin_control_delete(request, pk):
	control = get_object_or_404(Control, pk=pk)
	if request.method == 'POST':
		# capture id and description before deleting the DB row so audit has correct id
		try:
			user_name = request.session.get('user_nombre', '')
			rid = control.id_control
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó el control {control.nombre.upper()} identificado {rid} el día {fecha}.'
		except Exception:
			rid = None
			desc = None
		control.delete()
		try:
			if rid is not None:
				_record_audit(request, 'controles', rid, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Control eliminado correctamente.')
		return redirect('superadmin_controles')
	return render(request, 'core/superadmin/control_delete_confirm_superadmin.html', {'control': control})


@role_required([1])
def superadmin_asignacion_delete(request, pk):
	asign = get_object_or_404(ItemResponsable, pk=pk)
	if request.method == 'POST':
		# save id and desc first so audit will reference the correct record id
		try:
			user_name = request.session.get('user_nombre', '')
			rid = asign.id
			item_name = getattr(asign.id_item_riesgo, 'nombre', '')
			responsable_name = getattr(asign.id_usuario, 'nombre', '')
			fecha = date.today().isoformat()
			desc = f'El usuario {user_name} eliminó la asignación del item {item_name.upper()} asignado a {responsable_name.upper()} con id {rid} el día {fecha} afectando la tabla item_responsable.'
		except Exception:
			rid = None
			desc = None
		asign.delete()
		try:
			if rid is not None:
				_record_audit(request, 'item_responsable', rid, 'ELIMINAR', desc)
		except Exception:
			pass
		messages.success(request, 'Asignación eliminada correctamente.')
		return redirect('superadmin_asignacion')
	return render(request, 'core/superadmin/asignacion_delete_confirm_superadmin.html', {'asign': asign})


