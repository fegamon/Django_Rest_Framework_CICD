#!/bin/sh

echo "Applying migrations..."
python manage.py makemigrations
python manage.py migrate

echo "Collecting static files..."
python manage.py collectstatic --noinput

if [ "$ENVIRONMENT" = "production" ]; then
    echo "Starting production server..."
    exec gunicorn your_project_name.wsgi:application --bind 0.0.0.0:8000
else
    echo "Starting development server..."
    exec python manage.py runserver 0.0.0.0:8000
fi
