package com.example.paymentservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/payments")
public class PaymentServiceController {

    @GetMapping
    public String home() {
        return "Payment Service: Payment successful";
    }

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}
