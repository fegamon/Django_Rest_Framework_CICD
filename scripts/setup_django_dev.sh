#!/bin/sh

mkdir -p /app/logs
mkdir -p /app/To_Do/staticfiles
mkdir -p /app/To_Do/static

python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

# Start the Gunicorn server
# gunicorn core.wsgi:application \
#     --reload \
#     --bind 0.0.0.0:8000 \
#     --log-file=/app/logs/gunicorn.log \
#     --log-level=info \
#     --workers 3 \
#     --timeout 120

python manage.py runserver 0.0.0.0:8000
