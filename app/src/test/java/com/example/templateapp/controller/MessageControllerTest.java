package com.example.templateapp.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.example.templateapp.dto.MessageRequest;
import com.example.templateapp.dto.MessageResponse;
import com.example.templateapp.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.data.jpa.mapping.JpaMetamodelMappingContext;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(
    controllers = MessageController.class,
    excludeFilters = @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE))
@MockBean(JpaMetamodelMappingContext.class)
class MessageControllerTest {

  @Autowired private MockMvc mockMvc;

  @Autowired private ObjectMapper objectMapper;

  @MockBean private MessageService messageService;

  @Test
  void shouldGetAllMessages() throws Exception {
    // Arrange
    List<MessageResponse> messages =
        Arrays.asList(
            createMessageResponse(1L, "Title 1", "Content 1", "Author 1"),
            createMessageResponse(2L, "Title 2", "Content 2", "Author 2"));
    when(messageService.getAllMessages()).thenReturn(messages);

    // Act & Assert
    mockMvc
        .perform(get("/api/messages"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.length()").value(2))
        .andExpect(jsonPath("$[0].id").value(1))
        .andExpect(jsonPath("$[0].title").value("Title 1"))
        .andExpect(jsonPath("$[1].id").value(2))
        .andExpect(jsonPath("$[1].title").value("Title 2"));
  }

  @Test
  void shouldGetMessageById() throws Exception {
    // Arrange
    MessageResponse message = createMessageResponse(1L, "Title", "Content", "Author");
    when(messageService.getMessageById(1L)).thenReturn(message);

    // Act & Assert
    mockMvc
        .perform(get("/api/messages/1"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.id").value(1))
        .andExpect(jsonPath("$.title").value("Title"))
        .andExpect(jsonPath("$.content").value("Content"))
        .andExpect(jsonPath("$.author").value("Author"));
  }

  @Test
  void shouldCreateMessage() throws Exception {
    // Arrange
    MessageRequest request = new MessageRequest("New Title", "New Content", "New Author");
    MessageResponse response = createMessageResponse(1L, "New Title", "New Content", "New Author");
    when(messageService.createMessage(any(MessageRequest.class))).thenReturn(response);

    // Act & Assert
    mockMvc
        .perform(
            post("/api/messages")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.id").value(1))
        .andExpect(jsonPath("$.title").value("New Title"));
  }

  @Test
  void shouldUpdateMessage() throws Exception {
    // Arrange
    MessageRequest request =
        new MessageRequest("Updated Title", "Updated Content", "Updated Author");
    MessageResponse response =
        createMessageResponse(1L, "Updated Title", "Updated Content", "Updated Author");
    when(messageService.updateMessage(eq(1L), any(MessageRequest.class))).thenReturn(response);

    // Act & Assert
    mockMvc
        .perform(
            put("/api/messages/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.title").value("Updated Title"));
  }

  @Test
  void shouldDeleteMessage() throws Exception {
    // Act & Assert
    mockMvc.perform(delete("/api/messages/1")).andExpect(status().isNoContent());
  }

  @Test
  void shouldReturnBadRequestForInvalidMessage() throws Exception {
    // Arrange - Missing required fields
    MessageRequest request = new MessageRequest("", "", "");

    // Act & Assert
    mockMvc
        .perform(
            post("/api/messages")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
        .andExpect(status().isBadRequest());
  }

  private MessageResponse createMessageResponse(
      Long id, String title, String content, String author) {
    return MessageResponse.builder()
        .id(id)
        .title(title)
        .content(content)
        .author(author)
        .createdAt(LocalDateTime.now())
        .updatedAt(LocalDateTime.now())
        .build();
  }
}
