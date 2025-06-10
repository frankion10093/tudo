import request from '../utils/request'

// 获取所有待办事项
export function getTodos() {
  return request({
    url: '/todos',
    method: 'get'
  }).then(response => response.data)
}

// 创建待办事项
export function createTodo(data) {
  return request({
    url: '/todos',
    method: 'post',
    data
  }).then(response => response.data)
}

// 更新待办事项
export function updateTodo(id, data) {
  return request({
    url: `/todos/${id}`,
    method: 'put',
    data
  }).then(response => response.data)
}

// 删除待办事项
export function deleteTodo(id) {
  return request({
    url: `/todos/${id}`,
    method: 'delete'
  }).then(response => response.data)
}

// 获取待办事项统计
export function getTodoStats() {
  return request({
    url: '/todos/stats',
    method: 'get'
  }).then(response => response.data)
} 