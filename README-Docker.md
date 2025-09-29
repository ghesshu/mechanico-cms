# Docker Setup for Mechanico CMS

This guide explains how to run Mechanico CMS using Docker and Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. **Copy the environment file:**
   ```bash
   cp .env.docker .env
   ```

2. **Update environment variables:**
   Edit `.env` file and update the following values:
   - `APP_KEYS`: Generate secure keys
   - `API_TOKEN_SALT`: Generate a secure salt
   - `ADMIN_JWT_SECRET`: Generate a secure JWT secret
   - `TRANSFER_TOKEN_SALT`: Generate a secure salt
   - `JWT_SECRET`: Generate a secure JWT secret
   - `ENCRYPTION_KEY`: Generate a secure encryption key
   - Database credentials (optional, defaults are provided)

3. **Start the services:**
   ```bash
   docker-compose up -d
   ```

4. **Access the application:**
   - Strapi CMS: http://localhost:1337
   - Database Admin (Adminer): http://localhost:8080

## Services

### App Service (Strapi CMS)
- **Port:** 1337
- **Container:** mechanico-cms-app
- **Volumes:** Configuration, source code, and uploads are mounted for persistence

### Database Service (PostgreSQL)
- **Port:** 5432
- **Container:** mechanico-cms-db
- **Database:** mechanico_cms
- **Credentials:** strapi/strapi (configurable via .env)

### Adminer (Database Management)
- **Port:** 8080
- **Container:** mechanico-cms-adminer
- **Purpose:** Web-based database administration

## Development Mode

For development with hot reloading:

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
```

This will:
- Enable hot reloading for code changes
- Mount source directories for live editing
- Use development environment settings

## Useful Commands

### Start services in background
```bash
docker-compose up -d
```

### View logs
```bash
docker-compose logs -f app
docker-compose logs -f db
```

### Stop services
```bash
docker-compose down
```

### Rebuild and restart
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Access container shell
```bash
docker-compose exec app bash
docker-compose exec db psql -U strapi -d mechanico_cms
```

### Database backup
```bash
docker-compose exec db pg_dump -U strapi mechanico_cms > backup.sql
```

### Database restore
```bash
docker-compose exec -T db psql -U strapi mechanico_cms < backup.sql
```

## Data Persistence

- **Database data:** Stored in `postgres_data` Docker volume
- **Strapi data:** Stored in `strapi_data` Docker volume
- **Uploads:** Mounted to `./public/uploads` directory

## Environment Variables

Key environment variables for Docker setup:

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Application port | 1337 |
| `DATABASE_NAME` | PostgreSQL database name | mechanico_cms |
| `DATABASE_USERNAME` | PostgreSQL username | strapi |
| `DATABASE_PASSWORD` | PostgreSQL password | strapi |
| `NODE_ENV` | Node environment | production |

## Troubleshooting

### Port conflicts
If ports 1337, 5432, or 8080 are already in use, update the port mappings in `docker-compose.yml`.

### Permission issues
If you encounter permission issues with volumes:
```bash
sudo chown -R $USER:$USER ./public/uploads
```

### Database connection issues
Ensure the database service is fully started before the app service connects. The `depends_on` configuration handles this, but you can also add a delay:
```bash
docker-compose up db
# Wait a few seconds
docker-compose up app
```

### Reset everything
To completely reset and start fresh:
```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```