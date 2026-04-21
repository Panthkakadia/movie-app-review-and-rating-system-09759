package com.movieapp.config;

import com.movieapp.model.User;
import com.movieapp.repository.UserRepository;
import com.movieapp.service.TmdbService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final TmdbService tmdbService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        seedUsers();
        tmdbService.seedIfEmpty();
    }

    private void seedUsers() {
        if (userRepository.count() > 0) {
            log.info("Users already exist — skipping user seed");
            return;
        }

        log.info("Seeding default users...");

        userRepository.save(User.builder()
                .username("panth")
                .email("panth@gmail.com")
                .password(passwordEncoder.encode("panth1234"))
                .role("ADMIN")
                .build());

        userRepository.save(User.builder()
                .username("jayraj")
                .email("jayraj@gmail.com")
                .password(passwordEncoder.encode("jayraj1234"))
                .role("USER")
                .build());

        userRepository.save(User.builder()
                .username("humayun")
                .email("humayun@gmail.com")
                .password(passwordEncoder.encode("humayun1234"))
                .role("USER")
                .build());

        log.info("Seeded 3 users (panth/panth1234, jayraj/jayraj1234, humayun/humayun1234)");
    }
}
