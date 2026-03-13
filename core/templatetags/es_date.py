from django import template
from datetime import datetime, date

register = template.Library()


@register.filter
def spanish_date(value):
    """Formatea date/datetime a una cadena corta en español (p. ej. "4 de marzo de 2026").

    Comportamiento:
    - Si recibe str intenta parsear ISO (yyyy-mm-dd).
    - Si recibe datetime convierte a date.
    - Si no es date/datetime/str devuelve el valor tal cual.
    """
    if not value:
        return ''

    # Si es string, intentar parsear como ISO
    if isinstance(value, str):
        try:
            value = datetime.fromisoformat(value).date()
        except Exception:
            return value

    # Si es datetime, obtener solo la fecha
    if isinstance(value, datetime):
        value = value.date()

    if not isinstance(value, date):
        return value

    months = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ]

    try:
        day = value.day
        month_name = months[value.month - 1]
        year = value.year
        return f"{day} de {month_name} de {year}"
    except Exception:
        return value
