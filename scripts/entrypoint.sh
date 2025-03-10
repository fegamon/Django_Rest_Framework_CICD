#!/bin/sh
echo "Applying migrations..."
python manage.py makemigrations
python manage.py migrate
if [ "$ENVIRONMENT" = "production" ]; then
    echo "Fetching credentials from Vault..."
    SECRETS=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/secret/data/django")
    export POSTGRES_DB=$(echo $SECRETS | jq -r '.data.data.POSTGRES_DB')
    export POSTGRES_USER=$(echo $SECRETS | jq -r '.data.data.POSTGRES_USER')
    export POSTGRES_PASSWORD=$(echo $SECRETS | jq -r '.data.data.POSTGRES_PASSWORD')
    export POSTGRES_HOST=$(echo $SECRETS | jq -r '.data.data.POSTGRES_HOST')
    export POSTGRES_PORT=$(echo $SECRETS | jq -r '.data.data.POSTGRES_PORT')
    echo "Credentials fetched from Vault successfully."
    echo "Collecting static files..."
    python manage.py collectstatic --noinput
    echo "Starting Gunicorn..."
    exec gunicorn app.wsgi:application --bind 0.0.0.0:8000
else
    echo "Starting development server..."
    exec python manage.py runserver 0.0.0.0:8000
fi
