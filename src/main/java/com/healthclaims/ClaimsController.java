package com.healthclaims;

import org.springframework.web.bind.annotation.*;
import java.util.*;
//COntroller file that helps with API
// @RestController tells Spring: this class handles HTTP requests.
@RestController
public class ClaimsController {

    // Dummy data — 3 fake claims (in real systems this comes from a database)
    private List<Claim> claims = Arrays.asList(
        new Claim("CLM001", "Ravi Kumar", "APPROVED", "15000"),
        new Claim("CLM002", "Priya Sharma", "PENDING", "8500"),
        new Claim("CLM003", "Arun Singh", "REJECTED", "22000")
    );

    // GET /health — returns a simple status check
    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of(
            "status", "UP",
            "service", "claims-api"
        );
    }

    // GET /claims — returns all claims
    @GetMapping("/claims")
    public List<Claim> getAllClaims() {
        return claims;
    }

    // GET /claim/{id} — returns one specific claim by its ID
    @GetMapping("/claim/{id}")
    public Claim getClaim(@PathVariable String id) {
        return claims.stream()
                .filter(c -> c.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}