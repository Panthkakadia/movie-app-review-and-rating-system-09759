package com.movieapp.controller;

import com.movieapp.model.Movie;
import com.movieapp.model.Review;
import com.movieapp.service.MovieService;
import com.movieapp.service.MovieService.MoviePage;
import com.movieapp.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class MovieController {

    private final MovieService movieService;
    private final ReviewService reviewService;

    /**
     * Home page — hero section with top-rated and recently added movies.
     */
    @GetMapping("/")
    public String homePage(Model model) {
        model.addAttribute("topRated", movieService.findTopRated(6));
        model.addAttribute("recentlyAdded", movieService.findRecentlyAdded(6));
        model.addAttribute("totalMovies", movieService.countAll());
        model.addAttribute("genres", movieService.findAllGenres());
        return "home";
    }

    /**
     * Browse page — paginated movie grid with search, filter, and sort.
     */
    @GetMapping("/movies")
    public String listMovies(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Double minRating,
            @RequestParam(required = false, defaultValue = "title-asc") String sort,
            @RequestParam(required = false, defaultValue = "0") int page,
            Model model) {

        MoviePage moviePage = movieService.filterAndSort(keyword, genre, year, minRating, sort, page);

        model.addAttribute("movies", moviePage.content());
        model.addAttribute("currentPage", moviePage.currentPage());
        model.addAttribute("totalPages", moviePage.totalPages());
        model.addAttribute("totalItems", moviePage.totalItems());
        model.addAttribute("hasPrevious", moviePage.hasPrevious());
        model.addAttribute("hasNext", moviePage.hasNext());

        model.addAttribute("genres", movieService.findAllGenres());
        model.addAttribute("years", movieService.findAllReleaseYears());
        model.addAttribute("currentKeyword", keyword);
        model.addAttribute("currentGenre", genre);
        model.addAttribute("currentYear", year);
        model.addAttribute("currentMinRating", minRating);
        model.addAttribute("currentSort", sort);

        return "movies/list";
    }

    /**
     * Movie detail page.
     */
    @GetMapping("/movies/{id}")
    public String movieDetail(@PathVariable Long id,
                              @RequestParam(required = false) Integer rating,
                              Authentication authentication,
                              Model model) {

        Movie movie = movieService.findById(id)
                .orElseThrow(() -> new RuntimeException("Movie not found"));

        Map<Integer, Long> ratingDistribution = reviewService.getRatingDistribution(id);
        List<Review> reviews = reviewService.getReviewsForMovie(id, rating);

        model.addAttribute("movie", movie);
        model.addAttribute("reviews", reviews);
        model.addAttribute("ratingDistribution", ratingDistribution);
        model.addAttribute("selectedRating", rating);

        if (authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            Optional<Review> existingReview = reviewService.getUserReviewForMovie(username, id);
            model.addAttribute("hasReviewed", existingReview.isPresent());
            existingReview.ifPresent(r -> model.addAttribute("userReview", r));
            model.addAttribute("loggedIn", true);

            boolean isAdmin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            model.addAttribute("isAdmin", isAdmin);
        } else {
            model.addAttribute("hasReviewed", false);
            model.addAttribute("loggedIn", false);
            model.addAttribute("isAdmin", false);
        }

        return "movies/detail";
    }
}
