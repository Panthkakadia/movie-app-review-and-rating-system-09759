package com.movieapp.controller;

import com.movieapp.dto.RegistrationDto;
import com.movieapp.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@Valid @ModelAttribute("registrationDto") RegistrationDto dto,
                               BindingResult bindingResult,
                               RedirectAttributes redirectAttributes) {

        // Check password match
        if (!dto.isPasswordMatching()) {
            bindingResult.rejectValue("confirmPassword", "error.confirmPassword",
                    "Passwords do not match");
        }

        // Check duplicate username
        if (userService.usernameExists(dto.getUsername().trim())) {
            bindingResult.rejectValue("username", "error.username",
                    "Username is already taken");
        }

        // Check duplicate email
        if (userService.emailExists(dto.getEmail().trim().toLowerCase())) {
            bindingResult.rejectValue("email", "error.email",
                    "Email is already registered");
        }

        if (bindingResult.hasErrors()) {
            return "register";
        }

        userService.register(dto);
        redirectAttributes.addFlashAttribute("successMessage",
                "Account created successfully! Please log in.");
        return "redirect:/login";
    }
}
