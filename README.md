# Time Manager

Time Manager is a three-service application:

- Vue 3 frontend served by Nginx
- Phoenix/Elixir API backend
- PostgreSQL 14 database

Docker Compose manages the complete stack from the repository root.

## Project structure

```text
time_manager/
├── docker-compose.yml
├── .env.example
├── backend/
│   └── project/
│       ├── Dockerfile
│       └── entrypoint.sh
└── frontend/
    └── project/
        ├── Dockerfile
        └── nginx.conf
```


## Environment configuration

Create the local environment file from the template:

```bash
cp .env.example .env
```

Change `PGPASSWORD` and generate a strong Phoenix secret:

```bash
openssl rand -base64 48
```

Place the generated value in `.env` as `SECRET_KEY_BASE`. Never commit `.env`; it contains secrets and is ignored by Git.

Required variables:

```text
PGUSER
PGPASSWORD
PGDATABASE
PGPORT
PGHOST
SECRET_KEY_BASE
PHX_HOST
```

## Run with Docker

From the repository root, create `.env` from `.env.example`, set the required values listed above, then build and start the application:

```bash
cp .env.example .env
docker compose up --build -d
```

To start just the backend or frontend (Compose also starts required services):

```bash
docker compose up --build -d phoenix
docker compose up --build -d frontend
```

Open the app at <http://localhost>. Check status or follow logs with:

```bash
docker compose ps
docker compose logs -f
```

Stop the application with:

```bash
docker compose down
```

The PostgreSQL data is kept in the `db_data` volume when containers are stopped.
