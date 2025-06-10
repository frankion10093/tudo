# Todo List API 文档

## 基本信息

- 基础URL: `http://localhost:8080/api`
- 所有请求和响应均使用 JSON 格式
- 所有时间戳使用 ISO 8601 格式

## 数据模型

### Todo 对象

```json
{
  "id": "number",          // 唯一标识符
  "text": "string",        // 待办事项内容
  "completed": "boolean",  // 完成状态
  "createdAt": "string",   // 创建时间
  "updatedAt": "string"    // 更新时间
}
```

## API 端点

### 1. 获取所有待办事项

- **URL**: `/todos`
- **方法**: `GET`
- **描述**: 获取所有待办事项列表
- **响应**:
  ```json
  [
    {
      "id": 1,
      "text": "完成项目文档",
      "completed": false,
      "createdAt": "2024-03-20T10:00:00",
      "updatedAt": "2024-03-20T10:00:00"
    }
  ]
  ```

### 2. 创建待办事项

- **URL**: `/todos`
- **方法**: `POST`
- **描述**: 创建新的待办事项
- **请求体**:
  ```json
  {
    "text": "string"  // 必填，待办事项内容
  }
  ```
- **响应**: 返回创建的 Todo 对象

### 3. 更新待办事项

- **URL**: `/todos/{id}`
- **方法**: `PUT`
- **描述**: 更新指定 ID 的待办事项
- **路径参数**:
  - `id`: 待办事项 ID
- **请求体**:
  ```json
  {
    "text": "string",     // 可选，待办事项内容
    "completed": boolean  // 可选，完成状态
  }
  ```
- **响应**: 返回更新后的 Todo 对象

### 4. 删除待办事项

- **URL**: `/todos/{id}`
- **方法**: `DELETE`
- **描述**: 删除指定 ID 的待办事项
- **路径参数**:
  - `id`: 待办事项 ID
- **响应**: 204 No Content

### 5. 获取统计数据

- **URL**: `/todos/stats`
- **方法**: `GET`
- **描述**: 获取待办事项的统计信息
- **响应**:
  ```json
  {
    "total": "number",     // 总数量
    "completed": "number", // 已完成数量
    "pending": "number"    // 待完成数量
  }
  ```

## 错误处理

所有错误响应都遵循以下格式：

```json
{
  "error": {
    "code": "string",    // 错误代码
    "message": "string"  // 错误描述
  }
}
```

### 常见错误代码

- `400`: 请求参数错误
- `404`: 资源不存在
- `500`: 服务器内部错误

## 跨域支持

API 支持以下来源的跨域请求：
- `http://localhost:5173`
- `http://127.0.0.1:5173`

## 注意事项

1. 所有时间戳均为 UTC 时间
2. 创建和更新时间由服务器自动管理
3. ID 字段由数据库自动生成
4. 文本内容不能为空 