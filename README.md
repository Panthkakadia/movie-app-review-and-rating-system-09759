# MovieApp — Movie Review & Rating System

A full-stack web application where users browse movies, submit ratings and reviews, and admins manage the movie catalog with real-time TMDB API integration.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![AWS](https://img.shields.io/badge/AWS-EC2-orange)

---

## Live Demo

**URL:** http://3.18.109.162:8088

**Test Accounts:**

| Username | Password | Role |
|----------|----------|------|
| panth | panth1234 | ADMIN |
| jayraj | jayraj1234 | USER |
| humayun | humayun1234 | USER |

---

## Features

- **60+ real movies** imported from TMDB API with posters, descriptions, and genres
- **User authentication** with BCrypt-hashed passwords and role-based access (USER/ADMIN)
- **Rating & review system** with 1-5 star selector, duplicate prevention, and auto-calculated averages
- **Advanced search & filter** by title, genre, release year, and minimum rating — all combinable with removable filter chips
- **Admin panel** for full CRUD on movies plus one-click TMDB import
- **Rating distribution** visualization with clickable bars to filter reviews by stars
- **Responsive dark cinematic UI** with 870+ lines of custom CSS, DM Sans typography, and staggered animations

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java 17, Spring Boot 3.2.5, Spring MVC |
| Database | MySQL 8.0 |
| ORM | Spring Data JPA, Hibernate 6 |
| Security | Spring Security 6, BCrypt |
| Frontend | Thymeleaf, Bootstrap 5, vanilla JavaScript |
| External API | TMDB (The Movie Database) |
| Build | Maven |
| Deployment | AWS EC2, Docker, Docker Compose |

---

## Architecture

```
Browser (Thymeleaf + Bootstrap 5)
    ↓
Controller Layer (MovieController, AdminController, AuthController, ReviewController)
    ↓
Service Layer (MovieService, ReviewService, UserService, TmdbService)
    ↓
Repository Layer (JPA interfaces with custom @Query methods)
    ↓
MySQL Database (users, movies, reviews)
```

Every request flows through distinct layers — no business logic in controllers, no SQL in services.

---

## Database Schema

Three normalized tables with foreign keys and unique constraints:

**users** — id, username, email, password (BCrypt), role, created_at
Constraints: UNIQUE(username), UNIQUE(email)

**movies** — id, title, description, genre, release_year, poster_url, average_rating, review_count, created_at
Constraints: INDEX(genre), INDEX(release_year)

**reviews** — id, user_id (FK), movie_id (FK), rating, comment, created_at
Constraints: UNIQUE(user_id, movie_id), CHECK(rating 1-5)

---

## Project Structure

```
movieapp/
├── src/main/java/com/movieapp/
│   ├── MovieAppApplication.java
│   ├── config/
│   │   ├── SecurityConfig.java
│   │   └── DataSeeder.java
│   ├── controller/
│   │   ├── MovieController.java
│   │   ├── AdminController.java
│   │   ├── AuthController.java
│   │   └── ReviewController.java
│   ├── service/
│   │   ├── MovieService.java
│   │   ├── ReviewService.java
│   │   ├── UserService.java
│   │   ├── TmdbService.java
│   │   └── CustomUserDetailsService.java
│   ├── repository/
│   │   ├── MovieRepository.java
│   │   ├── ReviewRepository.java
│   │   └── UserRepository.java
│   ├── model/
│   │   ├── Movie.java
│   │   ├── Review.java
│   │   └── User.java
│   └── dto/
│       ├── RegistrationDto.java
│       └── TmdbMovieDto.java
├── src/main/resources/
│   ├── application.properties
│   ├── application-prod.properties
│   ├── static/css/style.css
│   └── templates/
│       ├── home.html
│       ├── login.html
│       ├── register.html
│       ├── movies/
│       │   ├── list.html
│       │   └── detail.html
│       ├── admin/
│       │   ├── movies.html
│       │   ├── movie-form.html
│       │   └── tmdb-search.html
│       └── fragments/
│           ├── navbar.html
│           ├── footer.html
│           └── head.html
├── Dockerfile
├── docker-compose.yml
├── movieapp.sql
├── pom.xml
└── README.md
```

---

## Getting Started

### Prerequisites

- Java 17+
- Maven 3.8+
- MySQL 8.0 (or Docker)

### Option 1: Run with Docker (Recommended)

The simplest way — starts MySQL and the app together with one command.

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/movieapp.git
cd movieapp

# Start everything
docker compose up --build
```

Open http://localhost:8088

The database is auto-seeded from `movieapp.sql` on first run (61 movies, 15 reviews, 3 users).

### Option 2: Run Locally with XAMPP/MySQL

**1. Set up MySQL**

Start MySQL via XAMPP or your preferred method. Create the database:

```sql
CREATE DATABASE movieapp;
```

Optionally import the seed data:

```bash
mysql -u root -p movieapp < movieapp.sql
```

**2. Configure the application**

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/movieapp?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_mysql_password
tmdb.api.key=your_tmdb_api_key
```

**3. Build and run**

```bash
mvn clean package -DskipTests
java -jar target/movie-review-system-1.0.0.jar
```

Open http://localhost:8088

On first startup, the app seeds 3 default users and imports 60 movies from TMDB automatically.

---

## Configuration

### TMDB API Key

The app uses the TMDB API to fetch real movie data. Get a free key at https://www.themoviedb.org/settings/api and set it via environment variable:

```bash
export TMDB_API_KEY=your_key_here
```

Or edit `application.properties` directly.

### Environment Variables (Production)

| Variable | Description | Default |
|----------|-------------|---------|
| `SPRING_DATASOURCE_URL` | MySQL JDBC URL | `jdbc:mysql://localhost:3306/movieapp` |
| `SPRING_DATASOURCE_USERNAME` | DB username | `root` |
| `SPRING_DATASOURCE_PASSWORD` | DB password | `root` |
| `TMDB_API_KEY` | TMDB API key | (required) |
| `SERVER_PORT` | App port | `8088` |

---

## Security

- **Passwords** hashed with BCrypt (strength 10) — never stored in plain text
- **CSRF protection** enabled by default via Spring Security + Thymeleaf auto-token injection
- **Role-based access control** enforced at URL pattern level:
  - Public: `/`, `/movies`, `/movies/{id}` (GET only)
  - Authenticated: `/movies/*/reviews` (POST), `/reviews/**`
  - Admin only: `/admin/**`
- **Duplicate review prevention** via UNIQUE constraint at DB level + service-layer check (defense in depth)

---

## Key Engineering Decisions

**Denormalized `average_rating`** — stored directly on the `movies` table instead of calculated via JOIN + AVG on every request. Recalculated transactionally on every review change. Optimizes read-heavy workloads.

**Single @Query for all filters** — one `filterMovies()` method handles any combination of genre, year, rating, and keyword using nullable parameters. Avoids query explosion.

**Transactional review operations** — `submitReview()` and `deleteReview()` are `@Transactional`. Review save and rating recalculation either both succeed or both roll back.

**DTO layer for TMDB integration** — external API responses map to DTOs before converting to JPA entities. Decouples internal schema from TMDB's API structure.

---

## Deployment

Currently deployed on **AWS EC2** (Amazon Linux 2023, t2.micro) with Docker Compose orchestrating the Spring Boot app and MySQL 8 as separate containers.

Deployment architecture:
- EC2 instance with 1 GB swap configured
- Docker Compose with health checks and volume persistence
- MySQL tuned for low-memory environment (128 MB buffer pool)
- JVM heap capped at 384 MB

**Resume line:**

```
Deployed on AWS EC2 using Docker Compose with Spring Boot + MySQL containers,
configured health checks and volume persistence, tuned for resource-constrained
1GB environment with memory-optimized MySQL and JVM settings.
```

---

## Stats

- **1,400+** lines of Java across 20 source files
- **1,150+** lines of HTML across 12 Thymeleaf templates
- **870** lines of custom CSS
- **61** movies in the database (60 imported from TMDB)
- **3** database tables with foreign keys and constraints
- **7** Spring dependencies (web, JPA, security, thymeleaf, validation, mysql, lombok)

---

## Team

- **Panth Kakadia** — Backend, Database Design, Deployment
- **Jayraj** — Frontend, UI Design
- **Humayun** — Testing, Documentation

---

## License

Academic project — built as part of a full-stack development course at Conestoga College, April 2026.

---

## Acknowledgments

- [TMDB](https://www.themoviedb.org/) for free movie data API
- [Spring Boot](https://spring.io/projects/spring-boot) for the application framework
- [Bootstrap](https://getbootstrap.com/) for the responsive grid foundation
- [DM Sans](https://fonts.google.com/specimen/DM+Sans) for typography
