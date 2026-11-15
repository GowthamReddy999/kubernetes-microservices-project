package com.example.productservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/products")
public class ProductServiceController {

    @GetMapping
    public String home() {
        return "Product Service: Products: Laptop, Phone, Headphones";
    }

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}
