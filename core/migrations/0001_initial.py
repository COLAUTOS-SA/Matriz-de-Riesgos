# Generada por Django 5.2.8 el 2026-02-27 21:36

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Area',
            fields=[
                ('id_area', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=100)),
                ('descripcion', models.CharField(blank=True, max_length=255, null=True)),
                ('estado', models.CharField(default='activo', max_length=10)),
            ],
            options={
                'db_table': 'areas',
            },
        ),
        migrations.CreateModel(
            name='Role',
            fields=[
                ('id_rol', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=50, unique=True)),
                ('descripcion', models.CharField(blank=True, max_length=255, null=True)),
            ],
            options={
                'db_table': 'roles',
            },
        ),
        migrations.CreateModel(
            name='Sede',
            fields=[
                ('id_sede', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=100)),
                ('direccion', models.CharField(blank=True, max_length=255, null=True)),
                ('estado', models.CharField(default='activo', max_length=10)),
            ],
            options={
                'db_table': 'sedes',
            },
        ),
        migrations.CreateModel(
            name='ItemRiesgo',
            fields=[
                ('id_item_riesgo', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=150)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('criticidad', models.CharField(max_length=10)),
                ('estado', models.CharField(default='activo', max_length=10)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('id_area', models.ForeignKey(db_column='id_area', on_delete=django.db.models.deletion.CASCADE, to='core.area')),
            ],
            options={
                'db_table': 'items_riesgos',
            },
        ),
        migrations.AddField(
            model_name='area',
            name='id_sede',
            field=models.ForeignKey(db_column='id_sede', on_delete=django.db.models.deletion.CASCADE, to='core.sede'),
        ),
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id_usuario', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=100)),
                ('correo', models.CharField(max_length=150, unique=True)),
                ('password_hash', models.CharField(max_length=255)),
                ('estado', models.CharField(default='activo', max_length=10)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('id_area', models.ForeignKey(db_column='id_area', on_delete=django.db.models.deletion.PROTECT, to='core.area')),
                ('id_rol', models.ForeignKey(db_column='id_rol', on_delete=django.db.models.deletion.PROTECT, to='core.role')),
                ('id_sede', models.ForeignKey(db_column='id_sede', on_delete=django.db.models.deletion.PROTECT, to='core.sede')),
            ],
            options={
                'db_table': 'usuarios',
            },
        ),
        migrations.CreateModel(
            name='Riesgo',
            fields=[
                ('id_riesgo', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=150)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('nivel_riesgo', models.CharField(max_length=10)),
                ('estado', models.CharField(default='activo', max_length=10)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('id_item_riesgo', models.ForeignKey(db_column='id_item_riesgo', on_delete=django.db.models.deletion.CASCADE, to='core.itemriesgo')),
                ('creado_por', models.ForeignKey(db_column='creado_por', null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.usuario')),
            ],
            options={
                'db_table': 'riesgos',
            },
        ),
        migrations.AddField(
            model_name='itemriesgo',
            name='creado_por',
            field=models.ForeignKey(db_column='creado_por', null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.usuario'),
        ),
        migrations.CreateModel(
            name='Control',
            fields=[
                ('id_control', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=150)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('frecuencia', models.CharField(default='DIARIO', max_length=20)),
                ('estado', models.CharField(default='activo', max_length=10)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('id_riesgo', models.ForeignKey(db_column='id_riesgo', on_delete=django.db.models.deletion.CASCADE, to='core.riesgo')),
                ('creado_por', models.ForeignKey(db_column='creado_por', null=True, on_delete=django.db.models.deletion.SET_NULL, to='core.usuario')),
            ],
            options={
                'db_table': 'controles',
            },
        ),
        migrations.CreateModel(
            name='Auditoria',
            fields=[
                ('id_auditoria', models.AutoField(primary_key=True, serialize=False)),
                ('tabla_afectada', models.CharField(max_length=100)),
                ('id_registro', models.IntegerField()),
                ('accion', models.CharField(max_length=50)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('fecha_hora', models.DateTimeField(auto_now_add=True)),
                ('ip_origen', models.CharField(blank=True, max_length=45, null=True)),
                ('id_usuario', models.ForeignKey(db_column='id_usuario', on_delete=django.db.models.deletion.CASCADE, to='core.usuario')),
            ],
            options={
                'db_table': 'auditoria',
            },
        ),
        migrations.CreateModel(
            name='RegistroCheck',
            fields=[
                ('id_check', models.AutoField(primary_key=True, serialize=False)),
                ('fecha_check', models.DateField()),
                ('hora_check', models.DateTimeField(auto_now_add=True)),
                ('estado', models.CharField(max_length=20)),
                ('observaciones', models.TextField(blank=True, null=True)),
                ('id_control', models.ForeignKey(db_column='id_control', on_delete=django.db.models.deletion.CASCADE, to='core.control')),
                ('id_usuario', models.ForeignKey(db_column='id_usuario', on_delete=django.db.models.deletion.CASCADE, to='core.usuario')),
            ],
            options={
                'db_table': 'registro_checks',
                'unique_together': {('id_control', 'id_usuario', 'fecha_check')},
            },
        ),
        migrations.CreateModel(
            name='ItemResponsable',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('fecha_asignacion', models.DateTimeField(auto_now_add=True)),
                ('estado', models.CharField(default='activo', max_length=10)),
                ('id_item_riesgo', models.ForeignKey(db_column='id_item_riesgo', on_delete=django.db.models.deletion.CASCADE, to='core.itemriesgo')),
                ('asignado_por', models.ForeignKey(db_column='asignado_por', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='asignado_por', to='core.usuario')),
                ('id_usuario', models.ForeignKey(db_column='id_usuario', on_delete=django.db.models.deletion.CASCADE, to='core.usuario')),
            ],
            options={
                'db_table': 'item_responsable',
                'unique_together': {('id_item_riesgo', 'id_usuario')},
            },
        ),
    ]
