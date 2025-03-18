#!/bin/sh

echo "Applying migrations..."
python manage.py makemigrations
python manage.py migrate


if [ "$ENVIRONMENT" = "production" ]; then
    echo "Collecting static files..."
    mkdir -p staticfiles
    python manage.py collectstatic --noinput

    echo "Starting production server..."
    exec gunicorn core.wsgi:application --bind 0.0.0.0:8000
else
    echo "Starting development server..."
    exec python manage.py runserver 0.0.0.0:8000
fi
