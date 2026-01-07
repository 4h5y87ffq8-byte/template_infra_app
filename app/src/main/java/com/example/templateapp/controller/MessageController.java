package com.example.templateapp.controller;

import com.example.templateapp.dto.MessageRequest;
import com.example.templateapp.dto.MessageResponse;
import com.example.templateapp.service.MessageService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/messages")
@RequiredArgsConstructor
@Tag(name = "Messages", description = "Message management API")
public class MessageController {

  @SuppressFBWarnings(
      value = "EI_EXPOSE_REP2",
      justification = "MessageService is a Spring-managed bean with controlled lifecycle")
  private final MessageService messageService;

  @GetMapping
  @Operation(summary = "Get all messages")
  public ResponseEntity<List<MessageResponse>> getAllMessages() {
    List<MessageResponse> messages = messageService.getAllMessages();
    return ResponseEntity.ok(messages);
  }

  @GetMapping("/{id}")
  @Operation(summary = "Get message by ID")
  public ResponseEntity<MessageResponse> getMessageById(@PathVariable Long id) {
    MessageResponse message = messageService.getMessageById(id);
    return ResponseEntity.ok(message);
  }

  @PostMapping
  @Operation(summary = "Create new message")
  public ResponseEntity<MessageResponse> createMessage(@Valid @RequestBody MessageRequest request) {
    MessageResponse message = messageService.createMessage(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(message);
  }

  @PutMapping("/{id}")
  @Operation(summary = "Update message")
  public ResponseEntity<MessageResponse> updateMessage(
      @PathVariable Long id, @Valid @RequestBody MessageRequest request) {
    MessageResponse message = messageService.updateMessage(id, request);
    return ResponseEntity.ok(message);
  }

  @DeleteMapping("/{id}")
  @Operation(summary = "Delete message")
  public ResponseEntity<Void> deleteMessage(@PathVariable Long id) {
    messageService.deleteMessage(id);
    return ResponseEntity.noContent().build();
  }
}
