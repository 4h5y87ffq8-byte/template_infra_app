package com.example.templateapp.repository;

import com.example.templateapp.model.Message;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
  List<Message> findByAuthor(String author);

  List<Message> findByTitleContainingIgnoreCase(String title);
}
