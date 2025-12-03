package com.example.templateapp.service;

import com.example.templateapp.dto.MessageRequest;
import com.example.templateapp.dto.MessageResponse;
import com.example.templateapp.exception.ResourceNotFoundException;
import com.example.templateapp.model.Message;
import com.example.templateapp.repository.MessageRepository;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MessageService {

  private final MessageRepository messageRepository;

  @Cacheable(value = "messages")
  public List<MessageResponse> getAllMessages() {
    log.info("Fetching all messages");
    return messageRepository.findAll().stream()
        .map(this::convertToResponse)
        .collect(Collectors.toList());
  }

  @Cacheable(value = "message", key = "#id")
  public MessageResponse getMessageById(Long id) {
    log.info("Fetching message with id: {}", id);
    Message message =
        messageRepository
            .findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Message not found with id: " + id));
    return convertToResponse(message);
  }

  @Transactional
  @CacheEvict(value = "messages", allEntries = true)
  public MessageResponse createMessage(MessageRequest request) {
    log.info("Creating new message: {}", request.getTitle());
    Message message = new Message();
    message.setTitle(request.getTitle());
    message.setContent(request.getContent());
    message.setAuthor(request.getAuthor());
    Message savedMessage = messageRepository.save(message);
    return convertToResponse(savedMessage);
  }

  @Transactional
  @CacheEvict(
      value = {"message", "messages"},
      allEntries = true)
  public MessageResponse updateMessage(Long id, MessageRequest request) {
    log.info("Updating message with id: {}", id);
    Message message =
        messageRepository
            .findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Message not found with id: " + id));
    message.setTitle(request.getTitle());
    message.setContent(request.getContent());
    message.setAuthor(request.getAuthor());
    Message updatedMessage = messageRepository.save(message);
    return convertToResponse(updatedMessage);
  }

  @Transactional
  @CacheEvict(
      value = {"message", "messages"},
      allEntries = true)
  public void deleteMessage(Long id) {
    log.info("Deleting message with id: {}", id);
    if (!messageRepository.existsById(id)) {
      throw new ResourceNotFoundException("Message not found with id: " + id);
    }
    messageRepository.deleteById(id);
  }

  private MessageResponse convertToResponse(Message message) {
    return MessageResponse.builder()
        .id(message.getId())
        .title(message.getTitle())
        .content(message.getContent())
        .author(message.getAuthor())
        .createdAt(message.getCreatedAt())
        .updatedAt(message.getUpdatedAt())
        .build();
  }
}
