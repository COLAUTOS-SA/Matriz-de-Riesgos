from pathlib import Path

# Rutas base del proyecto (ejemplo: BASE_DIR / 'subdir')
BASE_DIR = Path(__file__).resolve().parent.parent

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'matriz_riesgo',
        'USER': 'python_conectar',
        'PASSWORD': 'riesgos',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
} 

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core',
]

# Configuración mínima para desarrollo
SECRET_KEY = 'django-insecure-dev-key'
DEBUG = True
ALLOWED_HOSTS = []

# Middleware mínimo necesario para sesiones, autenticación y mensajes
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# Configuración de templates mínima para que admin y plantillas funcionen
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# Módulo raíz de URLs del proyecto
ROOT_URLCONF = 'matriz_riesgo.urls'

# Archivos estáticos (CSS, JS, imágenes)
STATIC_URL = '/static/'
# Directorios adicionales de static para desarrollo
STATICFILES_DIRS = [
    BASE_DIR / 'core' / 'static',
]



