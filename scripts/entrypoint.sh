#!/bin/sh
echo "Applying migrations..."
python manage.py makemigrations
python manage.py migrate

if [ "$ENVIRONMENT" = "production" ]; then
    echo "Configuring production environment..."

    if [ -n "$VAULT_TOKEN" ]; then
        export VAULT_ADDR='http://vault:8200'
        vault login -method=token token=$VAULT_TOKEN

        DJANGO_SECRET_KEY=$(vault kv get -field=DJANGO_SECRET_KEY secret/django)
        export DJANGO_SECRET_KEY

        POSTGRES_DB=$(vault kv get -field=POSTGRES_DB secret/postgres)
        POSTGRES_USER=$(vault kv get -field=POSTGRES_USER secret/postgres)
        POSTGRES_PASSWORD=$(vault kv get -field=POSTGRES_PASSWORD secret/postgres)
        POSTGRES_HOST=$(vault kv get -field=POSTGRES_HOST secret/postgres)
        POSTGRES_PORT=$(vault kv get -field=POSTGRES_PORT secret/postgres)
        export POSTGRES_DB POSTGRES_USER POSTGRES_PASSWORD POSTGRES_HOST POSTGRES_PORT
    else
        echo "VAULT_TOKEN is not set. Skipping Vault secrets retrieval."
    fi

    echo "Starting production server..."
    exec gunicorn your_project_name.wsgi:application --bind 0.0.0.0:8000
else
    echo "Starting development server..."
    exec python manage.py runserver 0.0.0.0:8000
fi
