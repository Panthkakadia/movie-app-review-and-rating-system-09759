package com.movieapp.controller;

import com.movieapp.dto.TmdbMovieDto;
import com.movieapp.model.Movie;
import com.movieapp.service.MovieService;
import com.movieapp.service.TmdbService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final MovieService movieService;
    private final TmdbService tmdbService;

    /**
     * Admin dashboard — list all movies with edit/delete actions.
     */
    @GetMapping("/movies")
    public String listMovies(Model model) {
        model.addAttribute("movies", movieService.findAll());
        return "admin/movies";
    }

    /**
     * Show the "Add Movie" form.
     */
    @GetMapping("/movies/add")
    public String showAddForm(Model model) {
        model.addAttribute("movie", new Movie());
        model.addAttribute("genres", movieService.findAllGenres());
        return "admin/movie-form";
    }

    /**
     * Show the "Edit Movie" form, pre-populated with existing data.
     */
    @GetMapping("/movies/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Movie movie = movieService.findById(id)
                .orElseThrow(() -> new RuntimeException("Movie not found"));
        model.addAttribute("movie", movie);
        model.addAttribute("genres", movieService.findAllGenres());
        return "admin/movie-form";
    }

    /**
     * Handles both add and edit submissions.
     */
    @PostMapping("/movies/save")
    public String saveMovie(@Valid @ModelAttribute Movie movie,
                            BindingResult bindingResult,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("genres", movieService.findAllGenres());
            return "admin/movie-form";
        }

        boolean isNew = (movie.getId() == null);
        movieService.save(movie);

        redirectAttributes.addFlashAttribute("successMessage",
                isNew ? "Movie added successfully!" : "Movie updated successfully!");
        return "redirect:/admin/movies";
    }

    /**
     * Delete a movie by ID.
     */
    @GetMapping("/movies/delete/{id}")
    public String deleteMovie(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        movieService.deleteById(id);
        redirectAttributes.addFlashAttribute("successMessage", "Movie deleted successfully!");
        return "redirect:/admin/movies";
    }

    // -----------------------------------------------
    // TMDB Import
    // -----------------------------------------------

    /**
     * TMDB search page — admin searches for movies to import.
     */
    @GetMapping("/tmdb/search")
    public String tmdbSearchPage(@RequestParam(required = false) String query, Model model) {
        if (query != null && !query.isBlank()) {
            List<TmdbMovieDto> results = tmdbService.searchMovies(query.trim());
            model.addAttribute("results", results);
            model.addAttribute("query", query);
        }
        return "admin/tmdb-search";
    }

    /**
     * Import a single movie from TMDB by its TMDB ID.
     */
    @GetMapping("/tmdb/import/{tmdbId}")
    public String importFromTmdb(@PathVariable Long tmdbId, RedirectAttributes redirectAttributes) {
        Movie imported = tmdbService.importMovieByTmdbId(tmdbId);
        if (imported != null) {
            redirectAttributes.addFlashAttribute("successMessage",
                    "Imported: " + imported.getTitle());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Movie already exists or import failed.");
        }
        return "redirect:/admin/tmdb/search";
    }
}
