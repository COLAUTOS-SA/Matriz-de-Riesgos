from django.urls import path
from . import views

urlpatterns = [
	path('', views.login_view, name='login'),
	path('logout/', views.logout_view, name='logout'),

	# Rutas específicas de administración (prefijo 'panel/' para evitar conflicto con el admin de Django)
	path('panel/profile/', views.admin_profile, name='admin_profile'),
	path('panel/change-password/', views.admin_change_password, name='admin_change_password'),
	path('panel/items/', views.admin_items, name='admin_items'),
	path('panel/items/create/', views.admin_item_create, name='admin_item_create'),
	path('panel/items/<int:pk>/', views.admin_item_inspect, name='admin_item_inspect'),
	path('panel/items/<int:pk>/edit/', views.admin_item_edit, name='admin_item_edit'),
	path('panel/items/<int:pk>/delete/', views.admin_item_delete, name='admin_item_delete'),
	path('panel/amenazas/', views.admin_amenazas, name='admin_amenazas'),
	path('panel/amenazas/create/', views.admin_riesgo_create, name='admin_riesgo_create'),
	path('panel/amenazas/<int:pk>/', views.admin_riesgo_inspect, name='admin_riesgo_inspect'),
	path('panel/amenazas/<int:pk>/edit/', views.admin_riesgo_edit, name='admin_riesgo_edit'),
	path('panel/amenazas/<int:pk>/delete/', views.admin_riesgo_delete, name='admin_riesgo_delete'),
	path('panel/controles/', views.admin_controles, name='admin_controles'),
	path('panel/controles/create/', views.admin_control_create, name='admin_control_create'),
	path('panel/controles/<int:pk>/', views.admin_control_inspect, name='admin_control_inspect'),
	path('panel/controles/<int:pk>/edit/', views.admin_control_edit, name='admin_control_edit'),
	path('panel/controles/<int:pk>/delete/', views.admin_control_delete, name='admin_control_delete'),
	path('panel/asignacion/', views.admin_asignacion, name='admin_asignacion'),
	path('panel/asignacion/create/', views.admin_asignacion_create, name='admin_asignacion_create'),
	path('panel/asignacion/<int:pk>/', views.admin_asignacion_inspect, name='admin_asignacion_inspect'),
	path('panel/asignacion/<int:pk>/edit/', views.admin_asignacion_edit, name='admin_asignacion_edit'),
	path('panel/asignacion/<int:pk>/delete/', views.admin_asignacion_delete, name='admin_asignacion_delete'),
	path('panel/auditoria/', views.admin_auditoria, name='admin_auditoria'),
    path('panel/auditoria/<int:pk>/', views.admin_auditoria_inspect, name='admin_auditoria_inspect'),
	# Revisión (controles asignados al usuario autenticado)
	path('panel/revision/', views.admin_revision, name='admin_revision'),
	# Registro de Chequeos (listado de registros)
	path('panel/registro-chequeos/', views.admin_registro_chequeos, name='admin_registro_chequeos'),
	path('panel/registro-chequeos/<int:pk>/', views.admin_registro_inspect, name='admin_registro_inspect'),
]

# Responsable routes (independent views/templates/css)
urlpatterns += [
	path('responsable/profile/', views.responsable_profile, name='responsable_profile'),
	path('responsable/change-password/', views.responsable_change_password, name='responsable_change_password'),
	path('responsable/revision/', views.responsable_revision, name='responsable_revision'),
]

# Superadmin routes (separate namespace, role checks handled in views)
urlpatterns += [
	path('superadmin/profile/', views.superadmin_profile, name='superadmin_profile'),
	path('superadmin/change-password/', views.superadmin_change_password, name='superadmin_change_password'),

	path('superadmin/items/', views.superadmin_items, name='superadmin_items'),
	path('superadmin/items/create/', views.superadmin_item_create, name='superadmin_item_create'),
	path('superadmin/items/<int:pk>/', views.superadmin_item_inspect, name='superadmin_item_inspect'),
	path('superadmin/items/<int:pk>/edit/', views.superadmin_item_edit, name='superadmin_item_edit'),
	path('superadmin/items/<int:pk>/delete/', views.superadmin_item_delete, name='superadmin_item_delete'),

	path('superadmin/amenazas/', views.superadmin_amenazas, name='superadmin_amenazas'),
	path('superadmin/amenazas/create/', views.superadmin_riesgo_create, name='superadmin_riesgo_create'),
	path('superadmin/amenazas/<int:pk>/', views.superadmin_riesgo_inspect, name='superadmin_riesgo_inspect'),
	path('superadmin/amenazas/<int:pk>/edit/', views.superadmin_riesgo_edit, name='superadmin_riesgo_edit'),
	path('superadmin/amenazas/<int:pk>/delete/', views.superadmin_riesgo_delete, name='superadmin_riesgo_delete'),

	path('superadmin/controles/', views.superadmin_controles, name='superadmin_controles'),
	path('superadmin/controles/create/', views.superadmin_control_create, name='superadmin_control_create'),
	path('superadmin/controles/<int:pk>/', views.superadmin_control_inspect, name='superadmin_control_inspect'),
	path('superadmin/controles/<int:pk>/edit/', views.superadmin_control_edit, name='superadmin_control_edit'),
	path('superadmin/controles/<int:pk>/delete/', views.superadmin_control_delete, name='superadmin_control_delete'),

	path('superadmin/asignacion/', views.superadmin_asignacion, name='superadmin_asignacion'),
	path('superadmin/asignacion/create/', views.superadmin_asignacion_create, name='superadmin_asignacion_create'),
	path('superadmin/asignacion/<int:pk>/', views.superadmin_asignacion_inspect, name='superadmin_asignacion_inspect'),
	path('superadmin/asignacion/<int:pk>/edit/', views.superadmin_asignacion_edit, name='superadmin_asignacion_edit'),
	path('superadmin/asignacion/<int:pk>/delete/', views.superadmin_asignacion_delete, name='superadmin_asignacion_delete'),

	path('superadmin/auditoria/', views.superadmin_auditoria, name='superadmin_auditoria'),
	path('superadmin/auditoria/<int:pk>/', views.superadmin_auditoria_inspect, name='superadmin_auditoria_inspect'),

	path('superadmin/revision/', views.superadmin_revision, name='superadmin_revision'),

	# Superadmin - Usuarios
	path('superadmin/usuarios/', views.superadmin_usuarios, name='superadmin_usuarios'),
	path('superadmin/usuarios/create/', views.superadmin_usuario_create, name='superadmin_usuario_create'),
	path('superadmin/usuarios/<int:pk>/', views.superadmin_usuario_inspect, name='superadmin_usuario_inspect'),
	path('superadmin/usuarios/<int:pk>/edit/', views.superadmin_usuario_edit, name='superadmin_usuario_edit'),
	path('superadmin/usuarios/<int:pk>/reset-password/', views.superadmin_usuario_reset_password, name='superadmin_usuario_reset_password'),
	path('superadmin/usuarios/<int:pk>/delete/', views.superadmin_usuario_delete, name='superadmin_usuario_delete'),

	path('superadmin/registro-chequeos/', views.superadmin_registro_chequeos, name='superadmin_registro_chequeos'),
	path('superadmin/registro-chequeos/<int:pk>/', views.superadmin_registro_inspect, name='superadmin_registro_inspect'),
]
