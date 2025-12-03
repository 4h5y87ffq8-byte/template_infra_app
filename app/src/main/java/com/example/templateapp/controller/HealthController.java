package com.example.templateapp.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HealthController {

  @GetMapping("/health")
  public ResponseEntity<Map<String, Object>> health() {
    Map<String, Object> response = new HashMap<>();
    response.put("status", "UP");
    response.put("timestamp", LocalDateTime.now());
    response.put("service", "template-app");
    return ResponseEntity.ok(response);
  }

  @GetMapping("/info")
  public ResponseEntity<Map<String, String>> info() {
    Map<String, String> response = new HashMap<>();
    response.put("application", "Template Application");
    response.put("version", "1.0.0");
    response.put("description", "Spring Boot template with Docker support");
    return ResponseEntity.ok(response);
  }
}
