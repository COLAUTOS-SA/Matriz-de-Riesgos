from django.db import models
from django.contrib.auth.hashers import check_password
 


class Role(models.Model):
	id_rol = models.AutoField(primary_key=True)
	nombre = models.CharField(max_length=50, unique=True)
	descripcion = models.CharField(max_length=255, blank=True, null=True)

	class Meta:
		db_table = 'roles'

	def __str__(self):
		return self.nombre


class Sede(models.Model):
	id_sede = models.AutoField(primary_key=True)
	nombre = models.CharField(max_length=100)
	direccion = models.CharField(max_length=255, blank=True, null=True)
	estado = models.CharField(max_length=10, default='activo')

	class Meta:
		db_table = 'sedes'

	def __str__(self):
		return self.nombre


class Area(models.Model):
	id_area = models.AutoField(primary_key=True)
	id_sede = models.ForeignKey(Sede, on_delete=models.CASCADE, db_column='id_sede')
	nombre = models.CharField(max_length=100)
	descripcion = models.CharField(max_length=255, blank=True, null=True)
	estado = models.CharField(max_length=10, default='activo')

	class Meta:
		db_table = 'areas'

	def __str__(self):
		return self.nombre


class Usuario(models.Model):
	id_usuario = models.AutoField(primary_key=True)
	nombre = models.CharField(max_length=100)
	correo = models.CharField(max_length=150, unique=True)
	password_hash = models.CharField(max_length=255)
	estado = models.CharField(max_length=10, default='activo')
	fecha_creacion = models.DateTimeField(auto_now_add=True)
	id_rol = models.ForeignKey(Role, on_delete=models.PROTECT, db_column='id_rol')
	id_sede = models.ForeignKey(Sede, on_delete=models.PROTECT, db_column='id_sede')
	id_area = models.ForeignKey(Area, on_delete=models.PROTECT, db_column='id_area')


	class Meta:
		db_table = 'usuarios'

	def __str__(self):
		return self.nombre

	def check_password(self, raw_password: str) -> bool:
		"""
		Intentar primero el verificador de contraseñas de Django; si falla, comparar por igualdad simple.
		Esto permite compatibilidad con valores importados que no estaban hasheados.
		"""
		try:
			if check_password(raw_password, self.password_hash):
				return True
		except Exception:
			pass
		return raw_password == self.password_hash


class ItemRiesgo(models.Model):
	id_item_riesgo = models.AutoField(primary_key=True)
	id_area = models.ForeignKey(Area, on_delete=models.CASCADE, db_column='id_area')
	nombre = models.CharField(max_length=150)
	descripcion = models.TextField(blank=True, null=True)
	criticidad = models.CharField(max_length=10)
	estado = models.CharField(max_length=10, default='activo')
	fecha_creacion = models.DateTimeField(auto_now_add=True)
	creado_por = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True, db_column='creado_por')

	class Meta:
		db_table = 'items_riesgos'

	def __str__(self):
		return self.nombre

	def get_criticidad_display(self):
		val = str(self.criticidad)
		if val == '3' or val == '3.0' or val == 'Alto':
			return 'Alto'
		if val == '2' or val == '2.0' or val == 'Medio':
			return 'Medio'
		if val == '1' or val == '1.0' or val == 'Bajo':
			return 'Bajo'
		# fallback
		return self.criticidad

	def get_estado_display(self):
		val = str(self.estado)
		if val == '1' or val == '1.0' or val.lower() == 'activo':
			return 'Activo'
		if val == '0' or val == '0.0' or val.lower() == 'inactivo':
			return 'Inactivo'
		return self.estado


class Riesgo(models.Model):
	id_riesgo = models.AutoField(primary_key=True)
	id_item_riesgo = models.ForeignKey(ItemRiesgo, on_delete=models.CASCADE, db_column='id_item_riesgo')
	nombre = models.CharField(max_length=150)
	descripcion = models.TextField(blank=True, null=True)
	nivel_riesgo = models.CharField(max_length=10)
	estado = models.CharField(max_length=10, default='activo')
	fecha_creacion = models.DateTimeField(auto_now_add=True)
	creado_por = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True, db_column='creado_por')

	class Meta:
		db_table = 'riesgos'

	def __str__(self):
		return self.nombre

	def get_nivel_riesgo_display(self):
		val = str(self.nivel_riesgo)
		if val == '3' or val == '3.0' or val == 'Alto':
			return 'Alto'
		if val == '2' or val == '2.0' or val == 'Medio':
			return 'Medio'
		if val == '1' or val == '1.0' or val == 'Bajo':
			return 'Bajo'
		return self.nivel_riesgo

	def get_estado_display(self):
		val = str(self.estado)
		if val == '1' or val == '1.0' or val.lower() == 'activo':
			return 'Activo'
		if val == '0' or val == '0.0' or val.lower() == 'inactivo':
			return 'Inactivo'
		return self.estado


class Control(models.Model):
	id_control = models.AutoField(primary_key=True)
	id_riesgo = models.ForeignKey(Riesgo, on_delete=models.CASCADE, db_column='id_riesgo')
	nombre = models.CharField(max_length=150)
	descripcion = models.TextField(blank=True, null=True)
	frecuencia = models.CharField(max_length=20, default='DIARIO')
	estado = models.CharField(max_length=10, default='activo')
	fecha_creacion = models.DateTimeField(auto_now_add=True)
	creado_por = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True, db_column='creado_por')

	class Meta:
		db_table = 'controles'

	def __str__(self):
		return self.nombre

	def get_estado_display(self):
		val = str(self.estado)
		if val == '1' or val == '1.0' or val.lower() == 'activo':
			return 'Activo'
		if val == '0' or val == '0.0' or val.lower() == 'inactivo':
			return 'Inactivo'
		return self.estado


class ItemResponsable(models.Model):
	id = models.AutoField(primary_key=True)
	id_item_riesgo = models.ForeignKey(ItemRiesgo, on_delete=models.CASCADE, db_column='id_item_riesgo')
	id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, db_column='id_usuario')
	fecha_asignacion = models.DateTimeField(auto_now_add=True)
	asignado_por = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True, related_name='asignado_por', db_column='asignado_por')
	estado = models.CharField(max_length=10, default='activo')

	class Meta:
		db_table = 'item_responsable'
		unique_together = (('id_item_riesgo', 'id_usuario'),)

	# Unicidad a nivel de modelo gestionada por la tupla unique_together.
	# Se valida también al nivel de formulario (ItemResponsableForm.clean) para
	# ofrecer un mensaje de error asociado al campo y evitar mensajes duplicados.

	def get_estado_display(self):
		val = str(self.estado)
		if val == '1' or val == '1.0' or val.lower() == 'activo':
			return 'Activo'
		if val == '0' or val == '0.0' or val.lower() == 'inactivo':
			return 'Inactivo'
		return self.estado


class RegistroCheck(models.Model):
	id_check = models.AutoField(primary_key=True)
	id_control = models.ForeignKey(Control, on_delete=models.CASCADE, db_column='id_control')
	id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, db_column='id_usuario')
	fecha_check = models.DateField()
	hora_check = models.DateTimeField(auto_now_add=True)
	estado = models.CharField(max_length=20)
	observaciones = models.TextField(blank=True, null=True)

	class Meta:
		db_table = 'registro_checks'
		unique_together = (('id_control', 'id_usuario', 'fecha_check'),)


class Auditoria(models.Model):
	id_auditoria = models.AutoField(primary_key=True)
	tabla_afectada = models.CharField(max_length=100)
	id_registro = models.IntegerField()
	# Permitir acciones legibles y de texto libre (p. ej. INSPECCION, CREAR, EDITAR)
	accion = models.CharField(max_length=50)
	# detalle libre para describir exactamente qué se cambió o se vio
	descripcion = models.TextField(blank=True, null=True)
	id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, db_column='id_usuario')
	fecha_hora = models.DateTimeField(auto_now_add=True)
	ip_origen = models.CharField(max_length=45, blank=True, null=True)

	class Meta:
		db_table = 'auditoria'

	def __str__(self):
		return f"{self.accion} on {self.tabla_afectada}#{self.id_registro}"

