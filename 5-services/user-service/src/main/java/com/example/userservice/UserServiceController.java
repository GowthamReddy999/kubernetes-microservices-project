package com.example.userservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserServiceController {

    @GetMapping
    public String home() {
        return "User Service: User information is available";
    }

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}
