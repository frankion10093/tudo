package com.example.todolist.service;

import com.example.todolist.model.entity.Todo;
import java.util.List;

public interface TodoService {
    List<Todo> getAllTodos();
    Todo createTodo(Todo todo);
    Todo updateTodo(Long id, Todo todo);
    void deleteTodo(Long id);
    Todo getTodoById(Long id);
    long getTotalCount();
    long getCompletedCount();
    long getPendingCount();
} 