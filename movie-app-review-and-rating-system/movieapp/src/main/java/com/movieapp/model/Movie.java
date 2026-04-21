package com.movieapp.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "movies")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 50)
    private String genre;

    @Column(name = "release_year", nullable = false)
    private int releaseYear;

    @Column(name = "poster_url", length = 500)
    private String posterUrl;

    @Column(name = "average_rating", nullable = false)
    @Builder.Default
    private double averageRating = 0.0;

    @Column(name = "review_count", nullable = false)
    @Builder.Default
    private int reviewCount = 0;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Review> reviews = new ArrayList<>();

    /**
     * Recalculates average rating and review count from the reviews list.
     * Call this after adding or removing a review.
     */
    public void recalculateRating() {
        if (reviews.isEmpty()) {
            this.averageRating = 0.0;
            this.reviewCount = 0;
            return;
        }
        this.reviewCount = reviews.size();
        this.averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
        // Round to one decimal place
        this.averageRating = Math.round(this.averageRating * 10.0) / 10.0;
    }

    /**
     * Returns a human-readable summary based on the average rating.
     */
    public String getRatingSummary() {
        if (reviewCount == 0) return "No Reviews Yet";
        if (averageRating >= 4.5) return "Outstanding";
        if (averageRating >= 4.0) return "Excellent";
        if (averageRating >= 3.5) return "Very Good";
        if (averageRating >= 3.0) return "Good";
        if (averageRating >= 2.0) return "Fair";
        return "Poor";
    }
}
