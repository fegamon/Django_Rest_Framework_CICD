#!/bin/sh
if [ -n "$VAULT_TOKEN" ]; then
    export VAULT_ADDR='http://vault:8200'
    vault login -method=token token=$VAULT_TOKEN

    POSTGRES_DB=$(vault kv get -field=POSTGRES_DB secret/postgres)
    POSTGRES_USER=$(vault kv get -field=POSTGRES_USER secret/postgres)
    POSTGRES_PASSWORD=$(vault kv get -field=POSTGRES_PASSWORD secret/postgres)
    POSTGRES_HOST=$(vault kv get -field=POSTGRES_HOST secret/postgres)
    POSTGRES_PORT=$(vault kv get -field=POSTGRES_PORT secret/postgres)
    export POSTGRES_DB POSTGRES_USER POSTGRES_PASSWORD POSTGRES_HOST POSTGRES_PORT
else
    echo "VAULT_TOKEN is not set. Skipping Vault secrets retrieval."
fi

exec "$@"
