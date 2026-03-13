from django import forms
from .models import ItemRiesgo, Area

class LoginForm(forms.Form):
	correo = forms.EmailField(label='Correo', max_length=150)
	password = forms.CharField(label='Contraseña', widget=forms.PasswordInput)


class ItemRiesgoForm(forms.ModelForm):
	class Meta:
		model = ItemRiesgo
		fields = ['nombre', 'descripcion', 'id_area', 'criticidad', 'estado']
		widgets = {
			'descripcion': forms.Textarea(attrs={'rows':4, 'cols':60}),
		}

	def clean_estado(self):
		"""Normalize estado values to 'activo' or 'inactivo'."""
		val = self.cleaned_data.get('estado')
		if val is None or val == '':
			# preserve existing instance value if editing, otherwise default to 'activo'
			return getattr(self.instance, 'estado', 'activo')
		s = str(val).strip().lower()
		if s in ('1', '1.0', 'activo'):
			return 'activo'
		if s in ('0', '0.0', 'inactivo'):
			return 'inactivo'
		# fallback: return lowercased value
		return s

# Opciones comunes para display (coinciden con valores por defecto del modelo)
ESTADO_CHOICES = [
	('activo', 'Activo'),
	('inactivo', 'Inactivo'),
]

CRITICIDAD_CHOICES = [
	('3', 'Alto'),
	('2', 'Medio'),
	('1', 'Bajo'),
]

class ItemRiesgoForm(forms.ModelForm):
	# override fields to use select widgets
	criticidad = forms.ChoiceField(choices=CRITICIDAD_CHOICES)
	estado = forms.ChoiceField(choices=ESTADO_CHOICES)

	class Meta:
		model = ItemRiesgo
		fields = ['nombre', 'descripcion', 'id_area', 'criticidad', 'estado']
		widgets = {
			'descripcion': forms.Textarea(attrs={'rows':4, 'cols':60}),
		}



from .models import Riesgo, Control


class RiesgoForm(forms.ModelForm):
	nivel_riesgo = forms.ChoiceField(choices=CRITICIDAD_CHOICES)
	estado = forms.ChoiceField(choices=ESTADO_CHOICES)

	class Meta:
		model = Riesgo
		fields = ['id_item_riesgo', 'nombre', 'descripcion', 'nivel_riesgo', 'estado']
		widgets = {
			'descripcion': forms.Textarea(attrs={'rows':4, 'cols':60}),
		}

	def clean_estado(self):
		val = self.cleaned_data.get('estado')
		if val is None or val == '':
			return getattr(self.instance, 'estado', 'activo')
		s = str(val).strip().lower()
		if s in ('1', '1.0', 'activo'):
			return 'activo'
		if s in ('0', '0.0', 'inactivo'):
			return 'inactivo'
		return s


class ControlForm(forms.ModelForm):
	estado = forms.ChoiceField(choices=ESTADO_CHOICES)

	class Meta:
		model = Control
		# Excluir 'frecuencia' del formulario para que no sea editable en la UI
		fields = ['id_riesgo', 'nombre', 'descripcion', 'estado']
		widgets = {
			'descripcion': forms.Textarea(attrs={'rows':4, 'cols':60}),
		}

	def clean_estado(self):
		val = self.cleaned_data.get('estado')
		if val is None or val == '':
			return getattr(self.instance, 'estado', 'activo')
		s = str(val).strip().lower()
		if s in ('1', '1.0', 'activo'):
			return 'activo'
		if s in ('0', '0.0', 'inactivo'):
			return 'inactivo'
		return s


from .models import ItemResponsable


class ItemResponsableForm(forms.ModelForm):
	"""Form para asignar un responsable a un ItemRiesgo."""
	estado = forms.ChoiceField(choices=ESTADO_CHOICES)

	class Meta:
		model = ItemResponsable
		fields = ['id_item_riesgo', 'id_usuario', 'estado']
		widgets = {
			
		}

	def clean(self):
		"""Prevent duplicate (id_item_riesgo, id_usuario) assignments and
		attach a single Spanish error to the `id_usuario` field.
		"""
		cleaned = super().clean()
		item = cleaned.get('id_item_riesgo') or getattr(self.instance, 'id_item_riesgo', None)
		usuario = cleaned.get('id_usuario') or getattr(self.instance, 'id_usuario', None)
		if item and usuario:
			qs = ItemResponsable.objects.filter(id_item_riesgo=item, id_usuario=usuario)
			if self.instance and getattr(self.instance, 'pk', None):
				qs = qs.exclude(pk=self.instance.pk)
			if qs.exists():
				# Agregar error no asociado a campo para mostrarlo bajo los inputs
				self.add_error(None, 'El usuario ya tiene asignado este item')
		return cleaned

		def clean_estado(self):
			val = self.cleaned_data.get('estado')
			if val is None or val == '':
				return getattr(self.instance, 'estado', 'activo')
			s = str(val).strip().lower()
			if s in ('1', '1.0', 'activo'):
				return 'activo'
			if s in ('0', '0.0', 'inactivo'):
				return 'inactivo'
			return s


from .models import Usuario, Role, Sede


class UsuarioForm(forms.ModelForm):
	"""Form para crear/editar Usuario en la UI de superadmin.

	Includes an optional password field; when provided, it's hashed and stored
	in the model's password_hash field.
	"""
	password = forms.CharField(required=False, widget=forms.PasswordInput, label='Contraseña')
	estado = forms.ChoiceField(choices=ESTADO_CHOICES)

	class Meta:
		model = Usuario
		fields = ['nombre', 'correo', 'id_rol', 'id_sede', 'id_area', 'estado']

	def save(self, commit=True):
		u = super().save(commit=False)
		pwd = self.cleaned_data.get('password')
		if pwd:
			from django.contrib.auth.hashers import make_password
			u.password_hash = make_password(pwd)
		if commit:
			u.save()
		return u
