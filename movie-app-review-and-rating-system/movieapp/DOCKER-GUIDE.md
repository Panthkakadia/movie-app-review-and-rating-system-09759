# MovieApp — Docker Setup

## Files to Add

Copy these 3 files into your project ROOT (same level as `pom.xml`):

```
movieapp/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── pom.xml
├── src/
└── ...
```

---

## How to Run (3 commands)

### 1. Install Docker Desktop
- Download: https://www.docker.com/products/docker-desktop/
- Install and start it
- Verify: `docker --version`

### 2. Stop XAMPP MySQL
Docker will run its own MySQL. If XAMPP MySQL is running on port 3306, either stop it or leave it — Docker uses port 3307 to avoid conflict.

### 3. Run Everything

```bash
cd path/to/movieapp
docker compose up --build
```

First run takes 3-5 minutes (downloads images, builds JAR, seeds TMDB data).
After that you'll see:

```
movieapp-db  | ready for connections
movieapp     | Started MovieAppApplication in 8.2 seconds
```

Open: **http://localhost:8088**

Done. Your entire app + database is running in Docker.

---

## Useful Commands

```bash
# Start in background
docker compose up --build -d

# View logs
docker compose logs -f app

# Stop everything
docker compose down

# Stop AND delete database data (fresh start)
docker compose down -v

# Rebuild after code changes
docker compose up --build
```

---

## What the Dockerfile Does

```dockerfile
# Stage 1: Uses Maven to build the JAR inside a container
#   (you don't even need Maven installed locally)
FROM maven:3.9-eclipse-temurin-17 AS build

# Stage 2: Copies only the JAR into a slim runtime image
#   (alpine = tiny Linux, ~80MB vs ~500MB)
FROM eclipse-temurin:17-jre-alpine
```

This is a **multi-stage build** — a production best practice. The final image contains only the JRE and your JAR, not Maven or source code. The image is ~180MB instead of ~800MB.

It also runs as a **non-root user** (`appuser`) — another security best practice that interviewers notice.

---

## What docker-compose.yml Does

Defines two services that start together:

1. **mysql** — MySQL 8.0 container with a health check. The app waits for MySQL to be healthy before starting.
2. **app** — Your Spring Boot JAR. Connects to MySQL using the Docker network hostname `mysql` (not `localhost`).

Data persists in a Docker volume (`mysql_data`). Even if you stop and restart containers, your movies and reviews are still there. Only `docker compose down -v` deletes the data.

---

## What to Say in Your Demo/Interview

> "The app is containerized with Docker using a multi-stage build — the first stage compiles with Maven, the second stage runs on an Alpine JRE image for minimal footprint. Docker Compose orchestrates both the Spring Boot app and MySQL database, with a health check dependency so the app only starts after MySQL is ready. The database uses a named volume for persistence."

That single paragraph hits: multi-stage builds, Alpine images, Compose orchestration, health checks, named volumes — all real production concepts.

---

## Resume Line

```
• Containerized with Docker (multi-stage build) and Docker Compose for MySQL + Spring Boot orchestration
```
