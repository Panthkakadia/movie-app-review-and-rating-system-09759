# MovieApp — Complete Project Walkthrough
## Movie Review & Rating System

---

## 1. PURPOSE & GOAL

### What Problem Does This Solve?

When people want to watch a movie, they face a fragmented experience — reviews are scattered across IMDb, Rotten Tomatoes, Letterboxd, and Google. There's no single community-driven platform where you can browse movies, read honest reviews from people like you, and share your own opinion in one place.

### Who Is It For?

- **Regular users** — people who want to browse movies, read reviews, and submit their own ratings
- **Admins** — content managers who maintain the movie database and can import new movies from external APIs

### What Is The End Result?

A fully functional web application where:
- Anyone can browse 61 real movies with HD posters, descriptions, and genres
- Registered users can submit 1–5 star ratings with written reviews
- Average ratings are automatically calculated and displayed
- Movies can be searched and filtered by title, genre, year, or minimum rating
- Admins can add, edit, delete movies, and import new movies from TMDB (The Movie Database API)
- Everything is secured with role-based authentication

---

## 2. ARCHITECTURE & COMPONENTS

### Layered Architecture (MVC Pattern)

The project follows the standard Spring Boot layered architecture. Each layer has a specific responsibility and only talks to the layer directly below it.

```
┌─────────────────────────────────────────┐
│  BROWSER (User's web browser)           │
│  Thymeleaf HTML + Bootstrap 5 CSS       │
└──────────────────┬──────────────────────┘
                   │ HTTP Request
┌──────────────────▼──────────────────────┐
│  CONTROLLER LAYER                       │
│  MovieController    → public pages      │
│  AdminController    → admin CRUD        │
│  AuthController     → login/register    │
│  ReviewController   → review submit     │
└──────────────────┬──────────────────────┘
                   │ Method calls
┌──────────────────▼──────────────────────┐
│  SERVICE LAYER (Business Logic)         │
│  MovieService       → filtering, sort   │
│  ReviewService      → submit, validate  │
│  UserService        → registration      │
│  TmdbService        → API integration   │
│  CustomUserDetails  → authentication    │
└──────────────────┬──────────────────────┘
                   │ JPA queries
┌──────────────────▼──────────────────────┐
│  REPOSITORY LAYER (Data Access)         │
│  MovieRepository    → movie queries     │
│  ReviewRepository   → review queries    │
│  UserRepository     → user lookups      │
└──────────────────┬──────────────────────┘
                   │ SQL
┌──────────────────▼──────────────────────┐
│  MySQL DATABASE                         │
│  Tables: users, movies, reviews         │
└─────────────────────────────────────────┘
```

### Why This Architecture Matters

- **Controllers** ONLY handle HTTP requests and responses — they don't contain business logic
- **Services** contain ALL business logic — validation, calculations, API calls
- **Repositories** are JPA interfaces that Spring auto-implements — we write zero SQL manually (except custom @Query annotations)
- **Models** are Java classes annotated with JPA — they map directly to MySQL tables

### Key Principle: Separation of Concerns

If a professor asks: "Where does the average rating get calculated?"
Answer: "In `ReviewService.recalculateMovieRating()` — never in the controller, never in the repository. The controller only calls `reviewService.submitReview()` and the service handles everything internally, inside a `@Transactional` boundary."

---

## 3. WORKFLOW & PROCESS

### Application Startup Flow

When you run the app for the first time:

```
1. Spring Boot starts → reads application.properties
2. JPA/Hibernate connects to MySQL (localhost:3306/movieapp)
3. ddl-auto=update → creates tables if they don't exist
4. DataSeeder.run() executes (implements CommandLineRunner):
   a. Checks if users table is empty → if yes, creates 3 users:
      - panth (ADMIN, password: panth1234)
      - jayraj (USER, password: jayraj1234)
      - humayun (USER, password: humayun1234)
   b. Calls TmdbService.seedIfEmpty():
      - Checks if movies table is empty
      - If yes → fetches 3 pages (60 movies) from TMDB popular endpoint
      - Maps each TMDB JSON response to a Movie entity
      - Resolves genre IDs to genre names (Action, Drama, etc.)
      - Saves all movies with poster URLs to MySQL
5. App is ready on http://localhost:8088
```

### User Review Submission Flow (The Most Important Workflow)

```
1. User clicks "Submit Review" on a movie detail page
2. Browser sends POST /movies/{id}/reviews with rating + comment
3. Spring Security checks: is the user authenticated? (yes → proceed, no → redirect to login)
4. ReviewController.submitReview() is called:
   a. Validates: rating between 1-5? comment not empty?
   b. If invalid → redirect back with error flash message
   c. If valid → calls reviewService.submitReview(movieId, username, rating, comment)
5. ReviewService.submitReview() runs @Transactional:
   a. Looks up the User by username
   b. Looks up the Movie by movieId
   c. Checks: has this user already reviewed this movie? (existsByUserIdAndMovieId)
   d. If duplicate → throws IllegalStateException("You have already reviewed this movie")
   e. If new → creates Review entity, saves it
   f. Calls recalculateMovieRating(movie):
      - Fetches ALL reviews for this movie
      - Calculates average: stream().mapToInt().average()
      - Rounds to 1 decimal: Math.round(avg * 10.0) / 10.0
      - Updates movie.averageRating and movie.reviewCount
      - Saves movie
   g. Both the review save AND the movie update happen in one transaction
      → if either fails, both roll back
6. Controller receives success → adds flash message → redirects to movie detail page
7. Movie detail page re-renders with updated rating and the new review visible
```

### Search & Filter Workflow

```
1. User is on /movies page
2. Types "Avatar" in search, selects genre "Sci-Fi", clicks "Apply Filters"
3. Browser sends GET /movies?keyword=Avatar&genre=Sci-Fi&sort=title-asc&page=0
4. MovieController.listMovies() calls movieService.filterAndSort(...)
5. MovieService:
   a. Normalizes empty strings to null (so @Query treats them as "no filter")
   b. Calls movieRepository.filterMovies(genre, year, minRating, keyword)
      → This is a single @Query with nullable parameters:
        WHERE (:genre IS NULL OR m.genre = :genre)
        AND (:keyword IS NULL OR LOWER(m.title) LIKE LOWER(CONCAT('%', :keyword, '%')))
   c. Sorts results in memory (Comparator-based)
   d. Paginates: extracts page 0, 12 items per page
   e. Returns MoviePage record with content + metadata
6. Controller passes data to Thymeleaf template
7. Template renders: movie grid + active filter chips + pagination controls
```

---

## 4. TECHNOLOGIES & TOOLS

| Technology | Version | Why We Chose It |
|---|---|---|
| **Java** | 17 | LTS version, required by the course, modern features (records, switch expressions) |
| **Spring Boot** | 3.2.5 | Auto-configuration, embedded server, production-ready defaults |
| **Spring MVC** | (included) | Standard web framework for handling HTTP requests/responses |
| **Spring Data JPA** | (included) | Eliminates boilerplate SQL — we just define interfaces and Spring generates queries |
| **Hibernate** | (included) | JPA implementation that maps Java objects to MySQL tables |
| **MySQL** | Via XAMPP | Required by the course (50% deduction for any other DB) |
| **Thymeleaf** | (included) | Server-side HTML templating — integrates naturally with Spring Security (shows/hides elements by role) |
| **Bootstrap 5** | 5.3.3 (CDN) | Responsive grid, form components, base styling — we customized heavily on top |
| **Spring Security** | (included) | Industry-standard auth framework — form login, BCrypt, role-based URL restrictions |
| **Lombok** | (included) | Reduces boilerplate (@Data, @Builder, @RequiredArgsConstructor) |
| **TMDB API** | v3 | Free, high-quality movie data with posters, genres, descriptions — 60+ movies imported |
| **DM Sans** | Google Font | Modern, clean typeface that elevates the dark cinematic UI |
| **Bootstrap Icons** | 1.11.3 (CDN) | Consistent iconography throughout the UI |

### Why NOT React/Angular/Vue?

The course requires Thymeleaf for server-side rendering. We stayed within the required stack but built a premium dark-themed UI with 870 lines of custom CSS, staggered animations, and interactive components using vanilla JavaScript.

---

## 5. CODE OVERVIEW

### Entity Layer (model/)

**User.java** — Maps to `users` table
- Fields: id, username, email, password (BCrypt hash), role ("USER" or "ADMIN"), createdAt
- Has `@OneToMany` relationship with Reviews (one user can write many reviews)

**Movie.java** — Maps to `movies` table
- Fields: id, title, description, genre, releaseYear, posterUrl, averageRating, reviewCount, createdAt
- Has `@OneToMany` relationship with Reviews
- Contains `recalculateRating()` helper and `getRatingSummary()` (returns "Outstanding", "Excellent", etc. based on average)
- `averageRating` is denormalized (stored directly on the movie) — this is an intentional design decision to avoid expensive JOIN + AVG() on every page load

**Review.java** — Maps to `reviews` table
- Fields: id, user (FK), movie (FK), rating (1-5), comment, createdAt
- Has `@ManyToOne` to both User and Movie
- `@UniqueConstraint(user_id, movie_id)` — prevents duplicate reviews at the database level
- `@Min(1) @Max(5)` on rating — Bean Validation

### Repository Layer (repository/)

**MovieRepository.java** — The most complex repository
- `findAllGenres()` → `SELECT DISTINCT m.genre FROM Movie m` — populates the genre dropdown
- `findAllReleaseYears()` → populates the year dropdown
- `filterMovies(genre, year, minRating, keyword)` → single @Query that handles ALL filter combinations with nullable params

**ReviewRepository.java**
- `findByMovieIdOrderByCreatedAtDesc()` → all reviews for a movie, newest first
- `existsByUserIdAndMovieId()` → duplicate check (returns boolean)
- `countByMovieGroupedByRating()` → returns rating distribution (how many 5-star, 4-star, etc.)

**UserRepository.java**
- `findByUsername()` → used by Spring Security to load user during login
- `existsByUsername()` / `existsByEmail()` → used during registration to prevent duplicates

### Service Layer (service/)

**ReviewService.java** — The most important service (most business logic lives here)
- `submitReview()` — the core workflow: validate → check duplicate → save review → recalculate average. All inside `@Transactional`
- `updateReview()` — only the author can edit; recalculates average after
- `deleteReview()` — author OR admin can delete; recalculates average after
- `recalculateMovieRating()` — private method that fetches all reviews, computes the average, and updates the movie entity
- `getRatingDistribution()` — builds a Map<Integer, Long> (5→count, 4→count, ..., 1→count) for the rating bars UI

**MovieService.java**
- `filterAndSort()` — normalizes inputs, calls repository, sorts in memory, paginates, returns MoviePage record
- `findTopRated()` / `findRecentlyAdded()` — for the home page hero section
- `MoviePage` — a Java record (immutable data class) that holds the paginated results + metadata (currentPage, totalPages, hasPrevious, hasNext)

**TmdbService.java** — External API integration
- `seedIfEmpty()` — called on startup, imports 60 movies if DB is empty
- `searchMovies(query)` — admin searches TMDB, returns DTOs (does NOT save)
- `importMovieByTmdbId(id)` — admin confirms import, converts DTO to entity, saves
- `getGenreMap()` — maps TMDB genre IDs (28, 12, etc.) to names ("Action", "Adventure") — cached after first call

**CustomUserDetailsService.java** — Spring Security integration
- Implements `UserDetailsService` interface
- `loadUserByUsername()` — fetches User from MySQL, converts to Spring Security's UserDetails with `ROLE_USER` or `ROLE_ADMIN` authority

### Controller Layer (controller/)

**MovieController.java**
- `GET /` → home page (top rated + recently added + genre pills)
- `GET /movies` → paginated browse with filters
- `GET /movies/{id}` → movie detail with reviews, rating bars, and review form

**ReviewController.java**
- `POST /movies/{id}/reviews` → submit new review
- `POST /reviews/{id}/edit` → update existing review
- `GET /reviews/{id}/delete` → delete review

**AdminController.java**
- `GET /admin/movies` → admin movie list
- `GET /admin/movies/add` → add movie form
- `GET /admin/movies/edit/{id}` → edit movie form
- `POST /admin/movies/save` → save (handles both add and edit)
- `GET /admin/movies/delete/{id}` → delete movie
- `GET /admin/tmdb/search` → TMDB search page
- `GET /admin/tmdb/import/{tmdbId}` → import one movie

**AuthController.java**
- `GET /login` → login page
- `GET /register` → registration form
- `POST /register` → process registration (validate → check duplicates → save → redirect to login)

### Configuration (config/)

**SecurityConfig.java** — The security rules:
- `/`, `/movies`, `/movies/**` (GET only) → public
- `/movies/*/reviews` (POST) → must be logged in
- `/reviews/**` → must be logged in
- `/admin/**` → must have ADMIN role
- Custom login page at `/login`
- BCrypt password encoding
- CSRF protection enabled

**DataSeeder.java** — Runs on startup:
- Creates 3 default users if none exist
- Calls TmdbService to populate movies from TMDB if movies table is empty

---

## 6. DATA HANDLING

### How Data Flows Through the System

```
TMDB API (external)                    User's Browser (input)
       │                                        │
       ▼                                        ▼
  TmdbService                            Controller
  (fetches JSON,                    (receives form data)
   maps to DTOs)                          │
       │                                  ▼
       ▼                              Service
  Movie Entity                    (validates, processes)
       │                                  │
       ▼                                  ▼
  MovieRepository                   Repository
  (JPA save)                        (JPA save)
       │                                  │
       ▼                                  ▼
  ┌──────────────────────────────────────────┐
  │           MySQL Database                  │
  │  ┌────────┐  ┌────────┐  ┌────────────┐ │
  │  │ users  │  │ movies │  │  reviews   │ │
  │  │  3 rows│  │ 61 rows│  │  15+ rows  │ │
  │  └────────┘  └────────┘  └────────────┘ │
  └──────────────────────────────────────────┘
```

### Database Relationships

```
users (1) ──────< reviews >────── (1) movies
  │                  │                  │
  │  One user can    │  Each review     │  One movie can
  │  write many      │  belongs to      │  have many
  │  reviews         │  exactly one     │  reviews
  │                  │  user AND one    │
  │                  │  movie           │
```

### Denormalization Decision

`average_rating` and `review_count` are stored directly on the `movies` table. This is intentional:

- **Without denormalization**: Every time someone views a movie page, we'd need `SELECT AVG(rating) FROM reviews WHERE movie_id = ?` — expensive with many reviews
- **With denormalization**: We just read `movie.averageRating` — instant. We recalculate it only when a review is added, edited, or deleted (rare operations compared to reads)
- **Tradeoff**: Slightly more complex write logic, but much faster reads

### Password Storage

Passwords are NEVER stored in plain text. The flow:
1. User registers with password "jayraj1234"
2. `passwordEncoder.encode("jayraj1234")` produces something like `$2a$10$TBJLT.qmtsiUUz2EtCFvRe...`
3. This BCrypt hash is stored in the database
4. On login, Spring Security calls `BCrypt.matches("jayraj1234", storedHash)` — it re-hashes and compares
5. Even if someone steals the database, they cannot reverse the passwords

---

## 7. USER INTERACTION

### Public User Flow (Not Logged In)

1. **Home page** (`/`) — sees hero section, top rated movies, genre pills, recently added
2. **Browse** (`/movies`) — grid of movie cards with posters. Can search, filter by genre/year/rating, sort A-Z/rating/year. Pagination at bottom (12 per page)
3. **Movie detail** (`/movies/{id}`) — sees poster, description, review summary card (animated rating counter), rating distribution bars, all reviews
4. **Cannot submit reviews** — sees "Sign in to write a review" prompt with login button
5. **Cannot access admin** — `/admin/*` redirects to login with "Access denied" message

### Registered User Flow (ROLE_USER)

Everything above, plus:
1. **Register** (`/register`) — form with username, email, password, confirm password. Inline validation errors
2. **Login** (`/login`) — username + password. Flash messages for success/error/logout
3. **Submit review** — on movie detail page, sees interactive star selector (click to rate) + textarea. Click "Submit Review"
4. **Edit own review** — after submitting, the review form is replaced with "Your Review" card showing the review with Edit/Delete buttons
5. **Delete own review** — confirmation prompt, then removes the review and recalculates average

### Admin Flow (ROLE_ADMIN)

Everything above, plus:
1. **Manage Movies** (`/admin/movies`) — table of all 61 movies with poster thumbnails, genre, year, rating, edit/delete actions
2. **Add Movie** (`/admin/movies/add`) — form with title, description, genre, year, poster URL
3. **Edit Movie** (`/admin/movies/edit/{id}`) — same form, pre-populated
4. **Delete Movie** — confirmation prompt. Cascade deletes all reviews for that movie
5. **Import from TMDB** (`/admin/tmdb/search`) — search box, results shown as cards with poster + description + "Import" button. One-click import saves movie to database
6. **Delete any review** — on movie detail pages, admin sees a small trash icon on every review (not just their own)

### UI States the Template Handles

The movie detail page (`detail.html`) has 3 different states:
- **Not logged in** → shows login prompt card
- **Logged in, hasn't reviewed this movie** → shows the star selector + review form
- **Logged in, already reviewed** → shows their existing review with Edit/Delete buttons + inline edit form (toggled via JavaScript)

---

## 8. DEMO GUIDE

### Pre-Demo Setup
- XAMPP running (Apache + MySQL)
- App running on `localhost:8088`
- Database has data (61 movies, 3 users, 15+ reviews)
- Have two browser tabs ready (one for user, one for admin)

### Step-by-Step Demo Script

**STEP 1: Home Page (30 seconds)**
Open `localhost:8088`
SAY: "This is the landing page. You can see the top rated movies based on community reviews, a genre navigation section, and recently added movies. All 61 movies were imported from the TMDB API on first startup."
SHOW: Scroll down through the sections. Point out the movie posters and ratings.

**STEP 2: Browse & Search (1 minute)**
Click "Browse All Movies"
SAY: "This is the browse page with all 61 movies, paginated 12 per page. Let me show the search and filter system."
DO: Type "Avatar" in search → click Apply Filters
SAY: "The search uses a LIKE query in JPA. Now let me combine filters."
DO: Clear search → select Genre: "Science Fiction" → select Sort: "Highest Rated" → Apply
SAY: "These filters use a single @Query method with nullable parameters — no matter how many filters you combine, it's one database query. Notice the active filter chips — you can remove individual filters by clicking the X."
DO: Click the X on the genre chip to remove it

**STEP 3: Movie Detail Page (1 minute)**
Click on a movie that has reviews (e.g., "Project Hail Mary" or "Oppenheimer")
SAY: "This is the movie detail page. At the top you see the poster, title, genre, and description. Below that is the Review Summary Card — the rating number animates up when the page loads. It shows the average rating, star visualization, review count, and a summary badge like 'Outstanding' or 'Excellent'."
SHOW: Point to the rating distribution bars
SAY: "These bars show how many reviews are at each star level. They're clickable — let me click on 5-star."
DO: Click the 5-star bar
SAY: "Now it's filtering to show only 5-star reviews. The URL updates with ?rating=5 so it's bookmarkable."
DO: Click "Show All" to reset

**STEP 4: Login & Authentication (30 seconds)**
SAY: "Notice there's a prompt saying 'Sign in to write a review.' Let me log in."
DO: Click Login → enter `jayraj` / `jayraj1234` → submit
SAY: "Spring Security authenticates against BCrypt-hashed passwords in MySQL. The navbar now shows the username and a logout button."

**STEP 5: Submit a Review (1 minute)**
Navigate to a movie jayraj hasn't reviewed yet
SAY: "Now I see the review form. The stars are interactive — let me click 4 stars."
DO: Click 4th star (watch them light up gold) → type a review comment → submit
SAY: "After submission, the average rating recalculated instantly. The review service runs inside a @Transactional — the review save and the rating recalculation happen atomically."
SHOW: Point out the updated average rating and review count

**STEP 6: Edit Review (30 seconds)**
SAY: "The form is now replaced with my existing review, showing Edit and Delete buttons."
DO: Click Edit → change the rating to 5 stars → change the text → click Save
SAY: "I can only edit my own review. The service checks that the logged-in username matches the review author."

**STEP 7: Duplicate Prevention (15 seconds)**
SAY: "If I try to navigate to this same movie and submit another review, the system prevents it — there's a UNIQUE constraint on (user_id, movie_id) at the database level AND a service-layer check before insert. Defense in depth."

**STEP 8: Admin Panel (1 minute)**
DO: Logout → login as `panth` / `panth1234`
SAY: "Panth is the admin. Notice the navbar now shows 'Manage' and 'Import' links — these are only visible to ADMIN role users, controlled by Thymeleaf's Spring Security integration."
DO: Click "Manage"
SAY: "This is the admin movie management page — all 61 movies in a table. I can edit or delete any movie."
DO: Click Edit on a movie → change the description → Save
SAY: "The form handles both add and edit — if the movie has an ID, it's an update; if null, it's a new insert."

**STEP 9: TMDB Import (45 seconds)**
DO: Click "Import from TMDB"
SAY: "This is the TMDB integration. The app connects to The Movie Database API to search for real movies."
DO: Type "Interstellar" → click Search
SAY: "These results come from the TMDB API in real-time. Each shows the poster, title, year, and description. I can import any movie with one click."
DO: Click "Import" on a result (pick one that doesn't already exist)
SAY: "The movie is now saved to our MySQL database with all its metadata and the poster URL. If I go back to the browse page, it'll appear in the list."

**STEP 10: Security Demo (30 seconds)**
DO: Logout → try to access `localhost:8088/admin/movies` directly
SAY: "Without being logged in, or logged in as a regular user, the admin pages redirect to the login page with an 'Access denied' message. Spring Security enforces this at the URL pattern level — /admin/** requires ROLE_ADMIN."

---

## 9. COMMON ISSUES / LIMITATIONS

### Known Limitations
- **No image upload** — movie posters are URLs (from TMDB). There's no file upload for custom posters. Admin must paste a URL manually when adding a movie.
- **No review pagination** — all reviews for a movie load at once. With hundreds of reviews, this could be slow. Movie pagination exists but review pagination does not.
- **Client-side star validation only** — the star selector is validated via JavaScript before submit. If someone disables JS, they could submit rating=0 (though the server returns an error).
- **Single genre per movie** — movies have one genre string, not multiple. TMDB provides multiple genres; we take the first one.
- **No password reset** — there's no "forgot password" flow. Users would need admin help to reset passwords.

### Potential Demo Issues
- **TMDB API rate limit** — if you call the search too quickly, TMDB may throttle responses. Wait a few seconds between searches.
- **Port conflict** — the app runs on 8088. If something else uses that port, change it in `application.properties`.
- **First startup is slow** — fetching 60 movies from TMDB takes 5-10 seconds. Subsequent starts are instant because the data persists in MySQL.
- **XAMPP must be running** — if MySQL isn't running, the app crashes on startup with a connection refused error.

### If a Professor Asks Hard Questions

**Q: "Why store average_rating on the movie instead of calculating it on the fly?"**
A: "It's an intentional denormalization for read performance. Movie detail pages are viewed far more often than reviews are submitted. Calculating AVG() with a JOIN on every page view doesn't scale. We recalculate transactionally on each review change, so the data is always consistent."

**Q: "What happens if two users submit a review at the same time?"**
A: "The UNIQUE constraint on (user_id, movie_id) prevents true duplicates at the database level. The service-layer check is optimistic — it could theoretically allow a race condition, but the DB constraint catches it. In production, you'd add optimistic locking with @Version."

**Q: "Why not use Spring Data Pageable instead of manual pagination?"**
A: "We could have used Pageable and Page<Movie> from Spring Data. We chose manual pagination in the service layer because we needed to sort after filtering with nullable params, which doesn't map cleanly to JPA's Sort + Pageable when combined with a custom @Query. It's simpler and more explicit this way."

---

## 10. BIG PICTURE SUMMARY

### For a Non-Technical Audience

MovieApp is a website where people can discover movies and share their opinions. Think of it like a mini version of IMDb or Rotten Tomatoes.

When you first open the app, you see a home page with popular movies — complete with movie posters, ratings, and descriptions. All of this real movie data is pulled from an actual movie database (TMDB) used by professional apps.

You can browse all 61 movies, search for specific titles, and filter by things like genre (Action, Comedy, Horror) or release year. If you find a movie you've watched, you can create an account, log in, and leave a star rating plus a written review.

The system automatically calculates the average rating for each movie based on all the reviews it has received. You can see how ratings are distributed — how many people gave 5 stars, 4 stars, etc. — with visual bar charts.

There are two types of users: regular users who browse and review, and administrators who can add new movies, edit existing ones, or import fresh movies from the internet with one click.

Behind the scenes, the app is built with professional tools used by real companies — Java Spring Boot for the backend, MySQL for the database, and a custom dark-themed interface that looks more like Netflix than a school project. Everything is secured with encrypted passwords and role-based access control.

### How Everything Connects

```
User opens browser
    → sees home page (rendered by Thymeleaf using data from MovieService)
    → clicks a movie (MovieController fetches from MovieRepository + ReviewService)
    → logs in (Spring Security checks BCrypt hash via CustomUserDetailsService)
    → submits review (ReviewController → ReviewService validates → ReviewRepository saves → recalculates average)
    → average updates instantly (denormalized on Movie entity)
    → other users see the updated rating (no delay, no cache issues)

Admin logs in
    → manages movies (AdminController → MovieService → MovieRepository)
    → imports from TMDB (AdminController → TmdbService → REST call → TmdbMovieDto → Movie entity → save)
```

Every piece works together: the security config decides who can do what, the services enforce business rules, the repositories handle data persistence, and the Thymeleaf templates render everything into a polished dark-themed UI with 870 lines of custom CSS.

---

## PROJECT STATS

| Metric | Count |
|---|---|
| Java source files | 20 |
| HTML templates | 12 |
| Lines of Java | 1,400+ |
| Lines of HTML | 1,150+ |
| Lines of CSS | 870 |
| Movies in database | 61 |
| Reviews in database | 15+ |
| Users | 3 (1 admin, 2 regular) |
| Database tables | 3 (users, movies, reviews) |
| API integrations | 1 (TMDB) |
| Spring dependencies | 7 (web, JPA, security, thymeleaf, validation, mysql, lombok) |

---

## LOGIN CREDENTIALS

| Username | Password | Role |
|---|---|---|
| panth | panth1234 | ADMIN |
| jayraj | jayraj1234 | USER |
| humayun | humayun1234 | USER |
