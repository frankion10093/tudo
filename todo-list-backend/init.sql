-- 创建数据库
CREATE DATABASE IF NOT EXISTS todolist DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE todolist;

-- 创建待办事项表
CREATE TABLE IF NOT EXISTS todos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    text VARCHAR(255) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入一些测试数据
INSERT INTO todos (text, completed) VALUES
('完成项目文档', false),
('开发新功能', false),
('代码审查', false),
('准备演示', false),
('修复bug', true);

-- 创建索引
CREATE INDEX idx_completed ON todos(completed);
CREATE INDEX idx_created_at ON todos(created_at);

-- 创建用户并授权（如果需要）
-- CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY 'root';
-- GRANT ALL PRIVILEGES ON todolist.* TO 'root'@'localhost';
-- FLUSH PRIVILEGES; 