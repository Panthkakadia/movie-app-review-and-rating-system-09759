package com.movieapp.service;

import com.movieapp.dto.TmdbMovieDto;
import com.movieapp.dto.TmdbMovieDto.TmdbGenreList;
import com.movieapp.dto.TmdbMovieDto.TmdbResponse;
import com.movieapp.model.Movie;
import com.movieapp.repository.MovieRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class TmdbService {

    private final RestTemplate restTemplate;
    private final MovieRepository movieRepository;

    private static final String BASE_URL = "https://api.themoviedb.org/3";

    @Value("${tmdb.api.key}")
    private String apiKey;

    // Cache the genre map so we don't call /genre/movie/list repeatedly
    private Map<Integer, String> genreMap;

    public TmdbService(MovieRepository movieRepository) {
        this.restTemplate = new RestTemplate();
        this.movieRepository = movieRepository;
    }

    /**
     * Fetches the TMDB genre ID → name mapping.
     * Called once and cached for the lifetime of the service.
     */
    private Map<Integer, String> getGenreMap() {
        if (genreMap != null) return genreMap;

        String url = BASE_URL + "/genre/movie/list?api_key=" + apiKey + "&language=en-US";
        try {
            TmdbGenreList response = restTemplate.getForObject(url, TmdbGenreList.class);
            if (response != null && response.getGenres() != null) {
                genreMap = response.getGenres().stream()
                        .collect(Collectors.toMap(
                                TmdbMovieDto.Genre::getId,
                                TmdbMovieDto.Genre::getName
                        ));
            } else {
                genreMap = Collections.emptyMap();
            }
        } catch (Exception e) {
            log.error("Failed to fetch TMDB genre list: {}", e.getMessage());
            genreMap = Collections.emptyMap();
        }
        return genreMap;
    }

    /**
     * Resolves the first genre name from a list of TMDB genre IDs.
     * Falls back to "Uncategorized" if none match.
     */
    private String resolveGenre(List<Integer> genreIds) {
        if (genreIds == null || genreIds.isEmpty()) return "Uncategorized";
        Map<Integer, String> genres = getGenreMap();
        return genreIds.stream()
                .map(genres::get)
                .filter(Objects::nonNull)
                .findFirst()
                .orElse("Uncategorized");
    }

    /**
     * Converts a TMDB DTO into a Movie entity ready for saving.
     */
    private Movie toMovieEntity(TmdbMovieDto dto) {
        return Movie.builder()
                .title(dto.getTitle())
                .description(dto.getDescription())
                .genre(resolveGenre(dto.getGenreIds()))
                .releaseYear(dto.getReleaseYear())
                .posterUrl(dto.getFullPosterUrl())
                .averageRating(0.0)
                .reviewCount(0)
                .build();
    }

    // -----------------------------------------------
    // Public API methods
    // -----------------------------------------------

    /**
     * Fetches popular movies from TMDB and saves them to the database.
     * Skips movies that already exist (matched by title + releaseYear).
     *
     * @param pages number of TMDB pages to fetch (20 movies per page)
     * @return number of new movies imported
     */
    public int importPopularMovies(int pages) {
        int imported = 0;

        for (int page = 1; page <= pages; page++) {
            String url = BASE_URL + "/movie/popular?api_key=" + apiKey
                    + "&language=en-US&page=" + page;
            try {
                TmdbResponse response = restTemplate.getForObject(url, TmdbResponse.class);
                if (response == null || response.getResults() == null) continue;

                for (TmdbMovieDto dto : response.getResults()) {
                    if (dto.getTitle() == null || dto.getReleaseYear() == 0) continue;

                    // Skip if this movie already exists in our database
                    boolean exists = movieRepository.searchByTitle(dto.getTitle()).stream()
                            .anyMatch(m -> m.getReleaseYear() == dto.getReleaseYear());
                    if (exists) continue;

                    movieRepository.save(toMovieEntity(dto));
                    imported++;
                }
            } catch (Exception e) {
                log.error("Failed to fetch TMDB popular page {}: {}", page, e.getMessage());
            }
        }

        log.info("Imported {} new movies from TMDB popular endpoint", imported);
        return imported;
    }

    /**
     * Searches TMDB by movie title and returns DTOs (does NOT save them).
     * Used by the admin to preview before importing.
     */
    public List<TmdbMovieDto> searchMovies(String query) {
        String url = BASE_URL + "/search/movie?api_key=" + apiKey
                + "&language=en-US&query=" + query + "&page=1";
        try {
            TmdbResponse response = restTemplate.getForObject(url, TmdbResponse.class);
            if (response != null && response.getResults() != null) {
                return response.getResults().stream()
                        .filter(dto -> dto.getTitle() != null && dto.getReleaseYear() > 0)
                        .limit(10)
                        .toList();
            }
        } catch (Exception e) {
            log.error("TMDB search failed for query '{}': {}", query, e.getMessage());
        }
        return Collections.emptyList();
    }

    /**
     * Imports a single movie by its TMDB ID.
     * Returns the saved Movie entity, or null if it already exists or the fetch fails.
     */
    public Movie importMovieByTmdbId(Long tmdbId) {
        String url = BASE_URL + "/movie/" + tmdbId + "?api_key=" + apiKey + "&language=en-US";
        try {
            TmdbMovieDto dto = restTemplate.getForObject(url, TmdbMovieDto.class);
            if (dto == null || dto.getTitle() == null) return null;

            // The detail endpoint returns genre objects instead of IDs,
            // so we handle both cases
            boolean exists = movieRepository.searchByTitle(dto.getTitle()).stream()
                    .anyMatch(m -> m.getReleaseYear() == dto.getReleaseYear());
            if (exists) return null;

            Movie movie = toMovieEntity(dto);
            return movieRepository.save(movie);
        } catch (Exception e) {
            log.error("Failed to import TMDB movie {}: {}", tmdbId, e.getMessage());
            return null;
        }
    }

    /**
     * Seeds the database with popular movies if the movies table is empty.
     * Called on application startup.
     */
    public void seedIfEmpty() {
        if (movieRepository.count() > 0) {
            log.info("Movies table already has data — skipping TMDB seed");
            return;
        }
        log.info("Movies table is empty — seeding from TMDB popular movies...");
        int count = importPopularMovies(3); // 3 pages = ~60 movies
        log.info("Seeding complete: {} movies imported", count);
    }
}
