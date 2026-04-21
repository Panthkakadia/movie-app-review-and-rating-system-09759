package com.movieapp.service;

import com.movieapp.model.Movie;
import com.movieapp.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MovieService {

    private static final int PAGE_SIZE = 12;

    private final MovieRepository movieRepository;

    public List<Movie> findAll() {
        return movieRepository.findAll();
    }

    public Optional<Movie> findById(Long id) {
        return movieRepository.findById(id);
    }

    public Movie save(Movie movie) {
        return movieRepository.save(movie);
    }

    public void deleteById(Long id) {
        movieRepository.deleteById(id);
    }

    public List<String> findAllGenres() {
        return movieRepository.findAllGenres();
    }

    public List<Integer> findAllReleaseYears() {
        return movieRepository.findAllReleaseYears();
    }

    public long countAll() {
        return movieRepository.count();
    }

    /**
     * Returns top-rated movies (with at least 1 review) for the hero section.
     */
    public List<Movie> findTopRated(int limit) {
        return movieRepository.findAll().stream()
                .filter(m -> m.getReviewCount() > 0)
                .sorted(Comparator.comparingDouble(Movie::getAverageRating).reversed())
                .limit(limit)
                .toList();
    }

    /**
     * Returns recently added movies for the hero section.
     */
    public List<Movie> findRecentlyAdded(int limit) {
        return movieRepository.findAll().stream()
                .sorted(Comparator.comparing(Movie::getCreatedAt).reversed())
                .limit(limit)
                .toList();
    }

    /**
     * Filters, sorts, and paginates movies.
     * Returns a Page-like result with metadata.
     */
    public MoviePage filterAndSort(String keyword, String genre, Integer year,
                                   Double minRating, String sort, int page) {
        String cleanKeyword = (keyword != null && !keyword.isBlank()) ? keyword.trim() : null;
        String cleanGenre = (genre != null && !genre.isBlank()) ? genre : null;

        List<Movie> results = new ArrayList<>(
                movieRepository.filterMovies(cleanGenre, year, minRating, cleanKeyword));

        // Apply sorting
        if (sort != null) {
            switch (sort) {
                case "title-asc" -> results.sort(Comparator.comparing(Movie::getTitle, String.CASE_INSENSITIVE_ORDER));
                case "title-desc" -> results.sort(Comparator.comparing(Movie::getTitle, String.CASE_INSENSITIVE_ORDER).reversed());
                case "rating-desc" -> results.sort(Comparator.comparingDouble(Movie::getAverageRating).reversed());
                case "year-desc" -> results.sort(Comparator.comparingInt(Movie::getReleaseYear).reversed());
                case "year-asc" -> results.sort(Comparator.comparingInt(Movie::getReleaseYear));
                default -> results.sort(Comparator.comparing(Movie::getTitle, String.CASE_INSENSITIVE_ORDER));
            }
        }

        int totalItems = results.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        int safePage = Math.max(0, Math.min(page, totalPages - 1));

        int fromIndex = safePage * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<Movie> pageContent = (fromIndex < totalItems)
                ? results.subList(fromIndex, toIndex)
                : List.of();

        return new MoviePage(pageContent, safePage, totalPages, totalItems, PAGE_SIZE);
    }

    /**
     * Simple page wrapper for movie results.
     */
    public record MoviePage(
            List<Movie> content,
            int currentPage,
            int totalPages,
            int totalItems,
            int pageSize
    ) {
        public boolean hasPrevious() { return currentPage > 0; }
        public boolean hasNext() { return currentPage < totalPages - 1; }
    }
}
