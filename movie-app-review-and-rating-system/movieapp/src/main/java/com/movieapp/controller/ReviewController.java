package com.movieapp.controller;

import com.movieapp.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    /**
     * Submit a new review for a movie.
     */
    @PostMapping("/movies/{movieId}/reviews")
    public String submitReview(@PathVariable Long movieId,
                               @RequestParam int rating,
                               @RequestParam String comment,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {

        if (comment == null || comment.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Review comment cannot be empty.");
            return "redirect:/movies/" + movieId;
        }
        if (rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("errorMessage", "Rating must be between 1 and 5.");
            return "redirect:/movies/" + movieId;
        }

        try {
            reviewService.submitReview(movieId, authentication.getName(), rating, comment);
            redirectAttributes.addFlashAttribute("successMessage", "Your review has been submitted!");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Movie not found.");
        }

        return "redirect:/movies/" + movieId;
    }

    /**
     * Update an existing review.
     */
    @PostMapping("/reviews/{reviewId}/edit")
    public String updateReview(@PathVariable Long reviewId,
                               @RequestParam Long movieId,
                               @RequestParam int rating,
                               @RequestParam String comment,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {

        if (comment == null || comment.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Review comment cannot be empty.");
            return "redirect:/movies/" + movieId;
        }

        try {
            reviewService.updateReview(reviewId, authentication.getName(), rating, comment);
            redirectAttributes.addFlashAttribute("successMessage", "Your review has been updated!");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/movies/" + movieId;
    }

    /**
     * Delete a review (own review or admin).
     */
    @GetMapping("/reviews/{reviewId}/delete")
    public String deleteReview(@PathVariable Long reviewId,
                               @RequestParam Long movieId,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        try {
            reviewService.deleteReview(reviewId, authentication.getName(), isAdmin);
            redirectAttributes.addFlashAttribute("successMessage", "Review deleted.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/movies/" + movieId;
    }
}
