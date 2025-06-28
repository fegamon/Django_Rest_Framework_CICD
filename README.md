Django Rest Framework CI/CD
===========================

A project that integrates Django Rest Framework with Docker and Docker Compose, prepared for continuous integration and deployment (CI/CD).

🚀 Features
-----------

*   Configuration for both development and production environments using Docker Compose.
*   PostgreSQL as the database.
*   Prepared for future CI/CD integrations.

🛠 Setup and Usage
------------------

### 1️⃣ Environment Variables

Create a `.env.dev` file based on `.env.example` for the development environment, i.e:

```bash
DJANGO_DEBUG=True
DJANGO_SECRET=django-insecure-key
DJANGO_ALLOWED_HOSTS=localhost

POSTGRES_DB=my_database
POSTGRES_USER=my_user
POSTGRES_PASSWORD=my_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
```

For production, create a `.env` file with the appropriate settings.

### 2️⃣ Build and Run

#### 🔹 Development

`docker-compose -f docker-compose.dev.yml up --build`

#### 🔹 Production

`docker-compose -f docker-compose.prod.yml up --build -d`

📌 Notes
--------

*   **The `.env` file should never be uploaded to a public repository.**
*   **Ensure that `entrypoint.sh` is properly configured to run migrations and other necessary commands at startup.**

📜 License
----------

This project is open-source under the MIT license.
