from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from django.contrib.auth.hashers import make_password

from core.models import Role, Sede, Area, Usuario


class Command(BaseCommand):
    help = 'Crear un Usuario Superadmin de prueba (rol id 1) con sede y área asociadas.'

    def add_arguments(self, parser):
        parser.add_argument('--nombre', required=True, help='Nombre del usuario (mostrar)')
        parser.add_argument('--correo', required=True, help='Correo único del usuario')
        parser.add_argument('--password', required=True, help='Contraseña en texto plano (se hasheará)')
        parser.add_argument('--sede', default='Default Sede', help='Nombre de la sede a crear/usar')
        parser.add_argument('--area', default='Default Area', help='Nombre del área a crear/usar (asociada a la sede)')

    @transaction.atomic
    def handle(self, *args, **options):
        nombre = options['nombre']
        correo = options['correo']
        password = options['password']
        sede_name = options['sede']
        area_name = options['area']

    # Asegurar existencia del rol con id_rol == 1 (Superadmin)
        role = None
        try:
            role = Role.objects.filter(id_rol=1).first()
        except Exception:
            role = None

        if not role:
            # Intentar crear el rol con pk=1; si ya existe, la lógica anterior lo reutilizará
            role = Role(id_rol=1, nombre='Super Administrador')
            role.save()
            self.stdout.write(self.style.SUCCESS('Created Role id_rol=1 (Super Administrador)'))
        else:
            self.stdout.write(self.style.NOTICE(f'Using existing Role id_rol=1: {role.nombre}'))

    # Asegurar existencia de la Sede indicada
        sede = Sede.objects.filter(nombre=sede_name).first()
        if not sede:
            sede = Sede(nombre=sede_name)
            sede.save()
            self.stdout.write(self.style.SUCCESS(f'Created Sede: {sede.nombre} (id_sede={sede.id_sede})'))
        else:
            self.stdout.write(self.style.NOTICE(f'Using existing Sede: {sede.nombre} (id_sede={sede.id_sede})'))

    # Asegurar existencia del Área asociada a la sede
        area = Area.objects.filter(nombre=area_name, id_sede=sede).first()
        if not area:
            area = Area(id_sede=sede, nombre=area_name)
            area.save()
            self.stdout.write(self.style.SUCCESS(f'Created Area: {area.nombre} (id_area={area.id_area})'))
        else:
            self.stdout.write(self.style.NOTICE(f'Using existing Area: {area.nombre} (id_area={area.id_area})'))

        # Verificar que no exista un Usuario con el mismo correo
        if Usuario.objects.filter(correo=correo).exists():
            raise CommandError(f'A user with correo "{correo}" already exists.')

    # Crear la instancia Usuario y persistirla en la base de datos
        usuario = Usuario(
            nombre=nombre,
            correo=correo,
            password_hash=make_password(password),
            estado='activo',
            id_rol=role,
            id_sede=sede,
            id_area=area,
        )
        usuario.save()

        self.stdout.write(self.style.SUCCESS(f'Created Superadmin Usuario: {usuario.nombre} (id_usuario={usuario.id_usuario})'))
        self.stdout.write(self.style.SUCCESS('You can now login with this user at the login page.'))
