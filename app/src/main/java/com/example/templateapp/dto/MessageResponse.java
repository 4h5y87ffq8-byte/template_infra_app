package com.example.templateapp.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageResponse {
  private Long id;
  private String title;
  private String content;
  private String author;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
}
