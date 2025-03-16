#!/bin/sh
vault operator init -key-shares=1 -key-threshold=1 > /vault/init-keys.txt

vault operator unseal $(
    grep 'Unseal Key 1:' /vault/init-keys.txt | awk '{print $NF}'
)

vault login $(
    grep 'Initial Root Token:' /vault/init-keys.txt | awk '{print $NF}'
)

# Enable KV secrets engine
vault secrets enable -path=secret kv-v2

# Store secrets
vault kv put secret/django \
    DJANGO_SECRET_KEY=your_django_secret_key

vault kv put secret/postgres \
    POSTGRES_DB=your_database_name \
    POSTGRES_USER=your_database_user \
    POSTGRES_PASSWORD=your_database_password \
    POSTGRES_HOST=db \
    POSTGRES_PORT=5432
