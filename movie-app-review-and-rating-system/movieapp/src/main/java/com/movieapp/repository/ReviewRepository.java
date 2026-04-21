package com.movieapp.repository;

import com.movieapp.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByMovieIdOrderByCreatedAtDesc(Long movieId);

    List<Review> findByMovieIdAndRatingOrderByCreatedAtDesc(Long movieId, int rating);

    Optional<Review> findByUserIdAndMovieId(Long userId, Long movieId);

    boolean existsByUserIdAndMovieId(Long userId, Long movieId);

    /**
     * Returns the count of reviews for each rating level (1–5) for a given movie.
     * Each row is an Object[] where [0] = rating (Integer), [1] = count (Long).
     */
    @Query("SELECT r.rating, COUNT(r) FROM Review r WHERE r.movie.id = :movieId GROUP BY r.rating")
    List<Object[]> countByMovieGroupedByRating(@Param("movieId") Long movieId);
}
