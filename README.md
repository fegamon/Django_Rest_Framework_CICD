
Django REST Framework CI/CD
===========================

Project Description
-------------------

**Django REST Framework CI/CD** is a backend project designed to integrate **Continuous Integration (CI) and Continuous Deployment (CD)** using **Docker, Docker Compose, and HashiCorp Vault** for secure secret management.

*   In **development**, environment variables are managed via a `.env` file.
*   In **production**, secrets are stored and retrieved securely from **Vault**, eliminating the need for `.env` files.

The project is structured to support **automated deployments** with a CI/CD pipeline (to be implemented) that will:

1.  Run tests and static analysis before deployment.
2.  Build and push Docker images to a container registry.
3.  Deploy the application automatically to a production server.

This repository provides a foundation for developing a **secure, scalable, and automated deployment workflow** for Django applications. 🚀

Table of Contents
-----------------

- [Django REST Framework CI/CD](#django-rest-framework-cicd)
  - [Project Description](#project-description)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
  - [Development Setup](#development-setup)
  - [Production Setup](#production-setup)
    - [1. Start Vault](#1-start-vault)
    - [2. Initialize Vault](#2-initialize-vault)
    - [3. Store Secrets in Vault](#3-store-secrets-in-vault)
    - [4. Configure Environment Variables](#4-configure-environment-variables)
    - [5. Start the Production Environment](#5-start-the-production-environment)
  - [Environment Variables](#environment-variables)
    - [Development (via `.env`)](#development-via-env)
    - [Production (via Vault)](#production-via-vault)
  - [Scripts Overview](#scripts-overview)

Getting Started
---------------

This project requires:

*   **Docker** and **Docker Compose** installed on your machine.
*   Basic knowledge of Django, PostgreSQL, and HashiCorp Vault.

Clone the repository to your local machine:

    ```bash
    git clone <repository-url>
    cd DJANGO_REST_FRAMEWORK_CICD
    ```


Development Setup
-----------------

The development environment uses a `.env` file for configuration and mounts the local directory for real-time code changes.

1.  **Prepare the environment file:**
    Create a `.env` file in the root directory with the following variables:

        ```bash
        POSTGRES_DB=your_db_name
        POSTGRES_USER=your_db_user
        POSTGRES_PASSWORD=your_db_password
        POSTGRES_HOST=db
        POSTGRES_PORT=5432
        DJANGO_SECRET_KEY=your_secret_key
        ```


2.  **Start the development environment:**
    Run the following command to build and start the services:

        ```bash
        docker-compose -f docker-compose.dev.yml up --build
        ```


3.  **Access the application:**
    *   Django server: `http://localhost:8000`
    *   PostgreSQL: `localhost:5432`
4.  **Stop the services:**
    Use `Ctrl+C` to stop the containers, or run:

        ```bash
        docker-compose -f docker-compose.dev.yml down
        ```



> **Note:** The volume `.:/app` allows real-time code changes without rebuilding the container.

Production Setup
----------------

The production environment replaces the `.env` file with **HashiCorp Vault** for secret management. Follow these steps to configure and run the production setup.

### 1\. Start Vault

1.  Start the production services (including Vault) in detached mode:

        ```bash
        docker-compose -f docker-compose.prod.yml up -d vault
        ```


2.  Verify Vault is running: `docker ps`


    Look for the `Vault` container with the status `Up`.

### 2\. Initialize Vault

1.  Access the Vault container: `docker exec -it Vault sh`


2.  Run the initialization script manually (if not automated): `/vault/config/init-vault.sh`


3.  Capture the output:
    *   The script generates an **Unseal Key** and an **Initial Root Token**. These are saved in `/vault/init-keys.txt` inside the container.
    *   Copy these values to a secure location outside the container:

            ```bash
            cat /vault/init-keys.txt
            ```


        Example output:

            ```bash
            Unseal Key 1: <unseal_key>
            Initial Root Token: <root_token>
            ```


4.  Exit the container:

        ```bash
        exit
        ```



> **Tip:** You can automate this step by modifying `docker-compose.prod.yml` to run `init-vault.sh` as part of the Vault service startup.

### 3\. Store Secrets in Vault

1.  Log in to Vault using the root token:

        ```bash
        docker exec -it Vault vault login <root_token>
        ```


2.  Store Django secrets:

        ```bash
        vault kv put secret/django DJANGO_SECRET_KEY=<your_secret_key>
        ```


3.  Store PostgreSQL secrets:

        ```bash
        vault kv put secret/postgres \
            POSTGRES_DB=<your_db_name> \
            POSTGRES_USER=<your_db_user> \
            POSTGRES_PASSWORD=<your_db_password> \
            POSTGRES_HOST=db \
            POSTGRES_PORT=5432
        ```


4.  Verify secrets:

        ```bash
        vault kv get secret/django
        vault kv get secret/postgres
        ```



### 4\. Configure Environment Variables

1.  Set the `VAULT_TOKEN` environment variable for the `web` and `db` services. Pass it via the command line when starting services (see step 5).



> **Security Note:** Avoid hardcoding the `VAULT_TOKEN` in the codebase. Use a secure method (e.g., CI/CD variables) in a real production setup.

### 5\. Start the Production Environment

1.  Start all services with the `VAULT_TOKEN`:

        ```bash
        VAULT_TOKEN=<root_token> docker-compose -f docker-compose.prod.yml up --build -d
        ```


2.  Check container logs to ensure everything starts correctly:

        ```bash
        docker logs Django
        docker logs Postgres_prod
        docker logs Vaul
        ```


3.  Access the application:
    *   Django server: `http://localhost:8000`
    *   PostgreSQL: `localhost:5432`
4.  Stop the services:

        ```bash
        docker-compose -f docker-compose.prod.yml down
        ```



> **Note:** Use `docker-compose -f docker-compose.prod.yml down -v` to also remove volumes (e.g., `postgres_data`, `vault_data`) if needed.

Environment Variables
---------------------

### Development (via `.env`)

All the environments You need are in `.env.example`.

### Production (via Vault)

Secrets are stored in Vault under `secret/django` and `secret/postgres`. The `entrypoint.sh` and `entrypoint-db.sh` scripts fetch these dynamically using the `VAULT_TOKEN`.

Scripts Overview
----------------

*   **`entrypoint.sh`**: Starts the Django app. In production, it retrieves secrets from Vault and runs Gunicorn; in development, it runs the Django development server.
*   **`entrypoint-db.sh`**: Configures PostgreSQL with Vault secrets (assumed to exist based on your description).
*   **`init-vault.sh`**: Initializes Vault, enables the KV secrets engine, and prepares it for secret storage.

> **CI/CD Note:** Continuous Integration and Deployment configurations are not yet implemented. Future updates will include GitHub Actions or similar workflows for automated testing, building, and deployment.
