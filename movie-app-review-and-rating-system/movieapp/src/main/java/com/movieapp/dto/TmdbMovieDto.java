package com.movieapp.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

/**
 * Maps the JSON response from TMDB's /movie/popular and /search/movie endpoints.
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TmdbMovieDto {

    private Long id;
    private String title;

    @JsonProperty("overview")
    private String description;

    @JsonProperty("release_date")
    private String releaseDate;

    @JsonProperty("poster_path")
    private String posterPath;

    @JsonProperty("vote_average")
    private double voteAverage;

    @JsonProperty("genre_ids")
    private List<Integer> genreIds;

    /**
     * Extracts just the year from the release date string (e.g., "2024-05-15" → 2024).
     */
    public int getReleaseYear() {
        if (releaseDate == null || releaseDate.length() < 4) return 0;
        try {
            return Integer.parseInt(releaseDate.substring(0, 4));
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /**
     * Builds the full poster URL from TMDB's image CDN.
     */
    public String getFullPosterUrl() {
        if (posterPath == null || posterPath.isBlank()) return null;
        return "https://image.tmdb.org/t/p/w500" + posterPath;
    }

    // -----------------------------------------------
    // Wrapper for paginated results from TMDB
    // -----------------------------------------------
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class TmdbResponse {
        private List<TmdbMovieDto> results;

        @JsonProperty("total_pages")
        private int totalPages;

        @JsonProperty("total_results")
        private int totalResults;
    }

    // -----------------------------------------------
    // Genre list response from /genre/movie/list
    // -----------------------------------------------
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class TmdbGenreList {
        private List<Genre> genres;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Genre {
        private int id;
        private String name;
    }
}
