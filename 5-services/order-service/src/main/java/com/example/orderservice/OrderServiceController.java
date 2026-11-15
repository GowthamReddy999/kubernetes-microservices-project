package com.example.orderservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

@RestController
@RequestMapping("/api/orders")
public class OrderServiceController {

    private final RestClient paymentServiceClient;

    public OrderServiceController(RestClient paymentServiceClient) {
        this.paymentServiceClient = paymentServiceClient;
    }

    @GetMapping
    public String home() {
        String paymentResponse = paymentServiceClient.get()
            .uri("/api/payments")
                .retrieve()
                .body(String.class);
        return "Order Service: Order created successfully. " + paymentResponse;
    }

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}