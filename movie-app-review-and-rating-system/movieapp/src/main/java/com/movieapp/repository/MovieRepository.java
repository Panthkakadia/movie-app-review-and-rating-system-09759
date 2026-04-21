package com.movieapp.repository;

import com.movieapp.model.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface MovieRepository extends JpaRepository<Movie, Long> {

    List<Movie> findByGenre(String genre);

    List<Movie> findByReleaseYear(int releaseYear);

    List<Movie> findByGenreAndReleaseYear(String genre, int releaseYear);

    @Query("SELECT m FROM Movie m WHERE LOWER(m.title) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Movie> searchByTitle(@Param("keyword") String keyword);

    @Query("SELECT DISTINCT m.genre FROM Movie m ORDER BY m.genre")
    List<String> findAllGenres();

    @Query("SELECT DISTINCT m.releaseYear FROM Movie m ORDER BY m.releaseYear DESC")
    List<Integer> findAllReleaseYears();

    @Query("SELECT m FROM Movie m WHERE " +
           "(:genre IS NULL OR m.genre = :genre) AND " +
           "(:year IS NULL OR m.releaseYear = :year) AND " +
           "(:minRating IS NULL OR m.averageRating >= :minRating) AND " +
           "(:keyword IS NULL OR LOWER(m.title) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Movie> filterMovies(@Param("genre") String genre,
                             @Param("year") Integer year,
                             @Param("minRating") Double minRating,
                             @Param("keyword") String keyword);
}
