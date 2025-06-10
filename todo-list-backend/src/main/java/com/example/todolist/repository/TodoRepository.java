package com.example.todolist.repository;

import com.example.todolist.model.entity.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    long countByCompleted(boolean completed);
} 