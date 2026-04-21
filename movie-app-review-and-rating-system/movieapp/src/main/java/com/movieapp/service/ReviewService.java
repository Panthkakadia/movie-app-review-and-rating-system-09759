package com.movieapp.service;

import com.movieapp.model.Movie;
import com.movieapp.model.Review;
import com.movieapp.model.User;
import com.movieapp.repository.MovieRepository;
import com.movieapp.repository.ReviewRepository;
import com.movieapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final MovieRepository movieRepository;
    private final UserRepository userRepository;

    /**
     * Submits a new review. Prevents duplicates and recalculates movie average.
     *
     * @throws IllegalStateException if user already reviewed this movie
     * @throws IllegalArgumentException if movie or user not found
     */
    @Transactional
    public Review submitReview(Long movieId, String username, int rating, String comment) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + username));

        Movie movie = movieRepository.findById(movieId)
                .orElseThrow(() -> new IllegalArgumentException("Movie not found: " + movieId));

        if (reviewRepository.existsByUserIdAndMovieId(user.getId(), movieId)) {
            throw new IllegalStateException("You have already reviewed this movie.");
        }

        Review review = Review.builder()
                .user(user)
                .movie(movie)
                .rating(rating)
                .comment(comment.trim())
                .build();

        Review saved = reviewRepository.save(review);

        // Recalculate average rating on the movie
        recalculateMovieRating(movie);

        return saved;
    }

    /**
     * Updates an existing review and recalculates the movie average.
     */
    @Transactional
    public Review updateReview(Long reviewId, String username, int rating, String comment) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("Review not found"));

        if (!review.getUser().getUsername().equals(username)) {
            throw new IllegalStateException("You can only edit your own reviews.");
        }

        review.setRating(rating);
        review.setComment(comment.trim());
        Review saved = reviewRepository.save(review);

        recalculateMovieRating(review.getMovie());

        return saved;
    }

    /**
     * Deletes a review (only by the review author or an admin) and recalculates average.
     */
    @Transactional
    public void deleteReview(Long reviewId, String username, boolean isAdmin) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("Review not found"));

        if (!isAdmin && !review.getUser().getUsername().equals(username)) {
            throw new IllegalStateException("You can only delete your own reviews.");
        }

        Movie movie = review.getMovie();
        reviewRepository.delete(review);
        recalculateMovieRating(movie);
    }

    /**
     * Checks if a user has already reviewed a specific movie.
     */
    public boolean hasUserReviewed(Long userId, Long movieId) {
        return reviewRepository.existsByUserIdAndMovieId(userId, movieId);
    }

    /**
     * Gets the current user's existing review for a movie, if any.
     */
    public Optional<Review> getUserReviewForMovie(String username, Long movieId) {
        return userRepository.findByUsername(username)
                .flatMap(user -> reviewRepository.findByUserIdAndMovieId(user.getId(), movieId));
    }

    /**
     * Returns reviews for a movie, optionally filtered by star rating.
     */
    public List<Review> getReviewsForMovie(Long movieId, Integer ratingFilter) {
        if (ratingFilter != null && ratingFilter >= 1 && ratingFilter <= 5) {
            return reviewRepository.findByMovieIdAndRatingOrderByCreatedAtDesc(movieId, ratingFilter);
        }
        return reviewRepository.findByMovieIdOrderByCreatedAtDesc(movieId);
    }

    /**
     * Builds the rating distribution map (5 → count, 4 → count, ..., 1 → count).
     */
    public Map<Integer, Long> getRatingDistribution(Long movieId) {
        Map<Integer, Long> distribution = new LinkedHashMap<>();
        for (int i = 5; i >= 1; i--) {
            distribution.put(i, 0L);
        }
        reviewRepository.countByMovieGroupedByRating(movieId).forEach(row -> {
            Integer starLevel = (Integer) row[0];
            Long count = (Long) row[1];
            distribution.put(starLevel, count);
        });
        return distribution;
    }

    /**
     * Recalculates average_rating and review_count on the movie entity.
     */
    private void recalculateMovieRating(Movie movie) {
        List<Review> allReviews = reviewRepository.findByMovieIdOrderByCreatedAtDesc(movie.getId());
        if (allReviews.isEmpty()) {
            movie.setAverageRating(0.0);
            movie.setReviewCount(0);
        } else {
            double avg = allReviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
            movie.setAverageRating(Math.round(avg * 10.0) / 10.0);
            movie.setReviewCount(allReviews.size());
        }
        movieRepository.save(movie);
    }
}
