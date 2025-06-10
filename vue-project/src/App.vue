<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { getTodos, createTodo, updateTodo, deleteTodo, getTodoStats } from './api/todo'

const todos = ref([])
const newTodo = ref('')
const draggedItem = ref(null)
const quotes = [
  {
    text: "Stay hungry, stay foolish.",
    translation: "保持饥饿，保持愚蠢。",
    author: "Steve Jobs"
  },
  {
    text: "Innovation distinguishes between a leader and a follower.",
    translation: "创新是区分领导者和追随者的关键。",
    author: "Steve Jobs"
  },
  {
    text: "Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work.",
    translation: "你的工作将占据你生活的大部分，唯一能让你真正满足的是做你认为伟大的工作。",
    author: "Steve Jobs"
  },
  {
    text: "The people who are crazy enough to think they can change the world are the ones who do.",
    translation: "那些疯狂到认为自己能改变世界的人，才是真正改变世界的人。",
    author: "Steve Jobs"
  },
  {
    text: "Design is not just what it looks like and feels like. Design is how it works.",
    translation: "设计不仅仅是外观和感觉，设计关乎功能。",
    author: "Steve Jobs"
  },
  {
    text: "Quality is more important than quantity. One home run is much better than two doubles.",
    translation: "质量比数量更重要。一个全垒打比两个二垒打要好得多。",
    author: "Steve Jobs"
  },
  {
    text: "The best way to predict the future is to invent it.",
    translation: "预测未来的最好方法就是创造未来。",
    author: "Steve Jobs"
  },
  {
    text: "I'm convinced that about half of what separates the successful entrepreneurs from the non-successful ones is pure perseverance.",
    translation: "我深信，成功的企业家与不成功的企业家之间的区别，有一半在于纯粹的毅力。",
    author: "Steve Jobs"
  },
  {
    text: "Sometimes life hits you in the head with a brick. Don't lose faith.",
    translation: "有时生活会用砖头砸你的头，但不要失去信心。",
    author: "Steve Jobs"
  },
  {
    text: "Your time is limited, so don't waste it living someone else's life.",
    translation: "你的时间有限，所以不要浪费时间去过别人的生活。",
    author: "Steve Jobs"
  }
]

const currentQuote = ref(quotes[0])
const quoteInterval = ref(null)
const stats = ref({
  total: 0,
  completed: 0,
  pending: 0
})

const updateQuote = () => {
  const randomIndex = Math.floor(Math.random() * quotes.length)
  currentQuote.value = quotes[randomIndex]
}

// 获取所有待办事项
const fetchTodos = async () => {
  try {
    const res = await getTodos()
    todos.value = res
  } catch (error) {
    console.error('Failed to fetch todos:', error)
  }
}

// 获取统计数据
const fetchStats = async () => {
  try {
    const res = await getTodoStats()
    stats.value = res
  } catch (error) {
    console.error('Failed to fetch stats:', error)
  }
}

onMounted(() => {
  fetchTodos()
  fetchStats()
  updateQuote()
  quoteInterval.value = setInterval(updateQuote, 5000)
})

onUnmounted(() => {
  if (quoteInterval.value) {
    clearInterval(quoteInterval.value)
  }
})

// 计算属性：排序后的待办事项列表
const sortedTodos = computed(() => {
  return [...todos.value].sort((a, b) => {
    // 首先按完成状态排序（未完成的在前）
    if (a.completed !== b.completed) {
      return a.completed ? 1 : -1;
    }
    // 如果完成状态相同，则按创建时间倒序排序（新的在前）
    return new Date(b.createdAt) - new Date(a.createdAt);
  });
});

// 添加待办事项
const addTodo = async () => {
  if (newTodo.value.trim()) {
    try {
      const res = await createTodo({ text: newTodo.value })
      todos.value.unshift(res)
      newTodo.value = ''
      await fetchStats()
    } catch (error) {
      console.error('Failed to add todo:', error)
    }
  }
}

// 切换待办事项状态
const toggleTodo = async (todo) => {
  try {
    const res = await updateTodo(todo.id, {
      text: todo.text,
      completed: !todo.completed
    })
    const index = todos.value.findIndex(t => t.id === todo.id)
    if (index !== -1) {
      todos.value[index] = res
      // 重新排序
      todos.value = [...todos.value]
    }
    await fetchStats()
  } catch (error) {
    console.error('Failed to toggle todo:', error)
  }
}

// 删除待办事项
const removeTodo = async (todo) => {
  try {
    await deleteTodo(todo.id)
    const index = todos.value.findIndex(t => t.id === todo.id)
    if (index !== -1) {
      todos.value.splice(index, 1)
    }
    await fetchStats()
  } catch (error) {
    console.error('Failed to remove todo:', error)
  }
}

const handleDragStart = (e, index) => {
  draggedItem.value = index;
  e.target.classList.add('dragging');
  e.dataTransfer.effectAllowed = 'move';
};

const handleDragOver = (e) => {
  e.preventDefault();
  e.dataTransfer.dropEffect = 'move';
};

const handleDragEnter = (e, index) => {
  e.preventDefault();
  if (index !== draggedItem.value) {
    const items = todos.value;
    const draggedTodo = items[draggedItem.value];
    items.splice(draggedItem.value, 1);
    items.splice(index, 0, draggedTodo);
    draggedItem.value = index;
  }
};

const handleDragEnd = (e) => {
  e.target.classList.remove('dragging');
  draggedItem.value = null;
};

// 计算属性：统计任务数量
const pendingCount = computed(() => todos.value.filter(todo => !todo.completed).length)
const completedCount = computed(() => todos.value.filter(todo => todo.completed).length)
</script>

<template>
  <div class="container">
    <div class="content-wrapper">
      <div class="header">
        <h1>Todo List</h1>
        <div class="subtitle">待办事务管理</div>
        <div class="quote-container">
          <p class="quote-text">{{ currentQuote.text }}</p>
          <p class="quote-translation">{{ currentQuote.translation }}</p>
          <p class="quote-author">— {{ currentQuote.author }}</p>
        </div>
      </div>
      
      <div class="main-content">
        <div class="add-todo">
          <div class="todo-input-container">
            <div class="input-wrapper">
              <input 
                type="text" 
                v-model="newTodo" 
                @keyup.enter="addTodo"
                placeholder="添加新的待办事项..."
                class="todo-input"
                maxlength="50"
              >
            </div>
            <span class="char-count" :class="{ 'warning': newTodo.length > 40 }">
              {{ newTodo.length }}/50
            </span>
          </div>
          <button @click="addTodo" class="add-btn" :disabled="!newTodo.trim()">添加</button>
        </div>
        
        <div class="todo-list-container">
          <TransitionGroup name="list" tag="ul" class="todo-list">
            <li 
              v-for="(todo, index) in sortedTodos" 
              :key="todo.id"
              :data-todo-id="todo.id"
              class="todo-item"
              draggable="true"
              @dragstart="handleDragStart($event, index)"
              @dragover="handleDragOver"
              @dragenter="handleDragEnter($event, index)"
              @dragend="handleDragEnd"
            >
              <div class="todo-content">
                <div class="checkbox-wrapper">
                  <input 
                    type="checkbox" 
                    :checked="todo.completed"
                    @change="toggleTodo(todo)"
                    class="todo-checkbox"
                  >
                </div>
                <span :class="{ completed: todo.completed }">{{ todo.text }}</span>
              </div>
              <button @click="removeTodo(todo)" class="delete-btn">
                <span class="delete-icon">×</span>
              </button>
            </li>
          </TransitionGroup>

          <div class="todo-stats">
            <div class="stat-item">
              <span class="stat-label">待完成</span>
              <span class="stat-value">{{ pendingCount }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">已完成</span>
              <span class="stat-value">{{ completedCount }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">总计</span>
              <span class="stat-value">{{ todos.length }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 4rem 2rem;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow-y: auto;
}

.container::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 10% 20%, rgba(0, 113, 227, 0.05) 0%, transparent 40%),
    radial-gradient(circle at 90% 80%, rgba(52, 199, 89, 0.05) 0%, transparent 40%),
    radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 0% 100%, rgba(0, 113, 227, 0.03) 0%, transparent 40%),
    radial-gradient(circle at 100% 0%, rgba(52, 199, 89, 0.03) 0%, transparent 40%);
  pointer-events: none;
  animation: backgroundShift 30s ease-in-out infinite alternate;
}

.container::after {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    linear-gradient(45deg, rgba(255, 255, 255, 0.1) 25%, transparent 25%),
    linear-gradient(-45deg, rgba(255, 255, 255, 0.1) 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, rgba(255, 255, 255, 0.1) 75%),
    linear-gradient(-45deg, transparent 75%, rgba(255, 255, 255, 0.1) 75%);
  background-size: 40px 40px;
  background-position: 0 0, 0 20px, 20px -20px, -20px 0px;
  opacity: 0.4;
  pointer-events: none;
  animation: patternShift 40s linear infinite;
}

@keyframes backgroundShift {
  0% {
    transform: scale(1) rotate(0deg);
  }
  50% {
    transform: scale(1.05) rotate(0.5deg);
  }
  100% {
    transform: scale(1) rotate(0deg);
  }
}

@keyframes patternShift {
  0% {
    background-position: 0 0, 0 20px, 20px -20px, -20px 0px;
  }
  100% {
    background-position: 40px 40px, 40px 60px, 60px 20px, 20px 40px;
  }
}

.content-wrapper {
  width: 100%;
  max-width: 1200px;
  display: flex;
  flex-direction: column;
  gap: 3rem;
  position: relative;
  z-index: 1;
  backdrop-filter: blur(10px);
}

.header {
  text-align: center;
  margin-bottom: 1rem;
  background: rgba(255, 255, 255, 0.95);
  padding: 2rem;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

h1 {
  font-size: 4rem;
  margin-bottom: 2rem;
  text-align: center;
  background: linear-gradient(
    to right,
    #ff0000,
    #ff7f00,
    #ffff00,
    #00ff00,
    #0000ff,
    #4b0082,
    #9400d3
  );
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: rainbow 8s linear infinite;
  background-size: 200% auto;
}

@keyframes rainbow {
  0% {
    background-position: 0% center;
  }
  100% {
    background-position: 200% center;
  }
}

.subtitle {
  font-size: 1.5rem;
  color: #86868b;
  font-weight: 400;
}

.main-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  max-width: 800px;
  margin: 0 auto;
  width: 100%;
  background: rgba(255, 255, 255, 0.95);
  padding: 2.5rem;
  border-radius: 24px;
  box-shadow: 
    0 4px 20px rgba(0, 0, 0, 0.08),
    0 0 0 1px rgba(255, 255, 255, 0.2),
    0 0 40px rgba(0, 113, 227, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  overflow: hidden;
}

.main-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, 
    #0071e3 0%, 
    #34c759 50%, 
    #0071e3 100%
  );
  opacity: 0.8;
}

.add-todo {
  display: flex;
  gap: 1rem;
  position: relative;
}

.todo-input-container {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  align-items: center;
  width: 100%;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.input-wrapper {
  position: relative;
  flex: 1;
  min-width: 0;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.char-count {
  font-size: 0.8rem;
  color: #86868b;
  transition: color 0.2s ease;
  text-align: right;
  padding-right: 0.5rem;
}

.char-count.warning {
  color: #ff2d55;
}

.todo-input {
  width: 100%;
  padding: 1rem;
  border: 1px solid #d2d2d7;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.2s ease;
  background: #fff;
  box-sizing: border-box;
  color: #1d1d1f;
  height: 3.5rem;
}

.todo-input:focus {
  outline: none;
  border-color: #0071e3;
  box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
}

.todo-input::placeholder {
  color: #86868b;
}

.add-btn {
  padding: 0 2rem;
  height: 3.5rem;
  background: #0071e3;
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
  flex-shrink: 0;
  min-width: 100px;
}

.add-btn:hover:not(:disabled) {
  background: #0077ed;
  transform: translateY(-1px);
}

.add-btn:disabled {
  background: #d2d2d7;
  cursor: not-allowed;
  transform: none;
}

.todo-list-container {
  position: relative;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.todo-list {
  list-style: none;
  padding: 0;
  position: relative;
  display: grid;
  gap: 1rem;
  max-height: calc(5 * (1.5rem + 2 * 1.5rem + 2 * 1rem) + 4 * 1rem);
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: rgba(0, 0, 0, 0.2) transparent;
  padding-right: 0.5rem;
  margin: 0;
}

.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
  transition: all 0.2s ease;
  cursor: grab;
  user-select: none;
}

.todo-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}

.todo-item:active {
  cursor: grabbing;
}

.todo-item.dragging {
  opacity: 0.5;
  background: #f5f5f7;
}

.todo-content {
  display: flex;
  align-items: center;
  gap: 1.2rem;
  flex: 1;
}

.checkbox-wrapper {
  position: relative;
  width: 28px;
  height: 28px;
}

.todo-checkbox {
  width: 100%;
  height: 100%;
  cursor: pointer;
  appearance: none;
  border: 2px solid #86868b;
  border-radius: 6px;
  transition: all 0.2s ease;
  position: relative;
}

.todo-checkbox:checked {
  background-color: #34c759;
  border-color: #34c759;
}

.todo-checkbox:checked::after {
  content: '✓';
  position: absolute;
  color: white;
  font-size: 16px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.todo-content span {
  font-size: 1.2rem;
  color: #1d1d1f;
  font-weight: 500;
  transition: all 0.3s ease;
}

.completed {
  text-decoration: line-through;
  color: #86868b !important;
  font-weight: normal !important;
}

.delete-btn {
  width: 36px;
  height: 36px;
  background: none;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  color: #86868b;
  margin-left: 1rem;
  position: relative;
  overflow: hidden;
}

.delete-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 59, 48, 0.1);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.3s ease, height 0.3s ease;
}

.delete-btn:hover {
  color: #ff3b30;
  transform: scale(1.1) rotate(90deg);
}

.delete-btn:hover::before {
  background: rgba(255, 59, 48, 0.15);
}

.delete-icon {
  font-size: 1.8rem;
  line-height: 1;
  transition: transform 0.3s ease;
}

.delete-btn:hover .delete-icon {
  transform: rotate(90deg);
}

.quote-container {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.85));
  border-radius: 20px;
  padding: 2.5rem;
  margin: 2rem 0;
  box-shadow: 
    0 4px 20px rgba(0, 0, 0, 0.05),
    0 0 0 1px rgba(255, 255, 255, 0.2);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  will-change: transform;
  transform: translateZ(0);
  -webkit-transform: translateZ(0);
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  perspective: 1000;
  -webkit-perspective: 1000;
}

.quote-container:hover {
  transform: translateY(-2px);
  box-shadow: 
    0 8px 30px rgba(0, 0, 0, 0.08),
    0 0 0 1px rgba(255, 255, 255, 0.3);
}

.quote-container::before {
  content: '"';
  position: absolute;
  top: -20px;
  left: 20px;
  font-size: 120px;
  color: rgba(0, 113, 227, 0.1);
  font-family: Georgia, serif;
  line-height: 1;
}

.quote-container::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 0% 0%, rgba(0, 113, 227, 0.05) 0%, transparent 50%),
    radial-gradient(circle at 100% 100%, rgba(52, 199, 89, 0.05) 0%, transparent 50%);
  pointer-events: none;
}

.quote-text {
  font-size: 1.5rem;
  color: #1d1d1f;
  line-height: 1.6;
  margin-bottom: 1rem;
  position: relative;
  z-index: 1;
  font-weight: 500;
}

.quote-translation {
  font-size: 1.2rem;
  color: #515154;
  line-height: 1.6;
  margin-bottom: 1.5rem;
  position: relative;
  z-index: 1;
  font-style: italic;
}

.quote-author {
  font-size: 1rem;
  color: #86868b;
  text-align: right;
  position: relative;
  z-index: 1;
  font-weight: 500;
}

/* 添加引用切换动画 */
.quote-container {
  animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 添加排序动画 */
.list-move,
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* 确保在排序时其他元素平滑过渡 */
.list-leave-active {
  position: absolute;
}

/* 添加删除确认动画 */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.todo-item.deleting {
  animation: shake 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 添加任务数量提示动画 */
@keyframes countPulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.todo-item {
  cursor: grab;
}

.todo-item:active {
  cursor: grabbing;
}

@media (max-width: 1200px) {
  .content-wrapper {
    max-width: 900px;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 2rem 1rem;
  }
  
  h1 {
    font-size: 2.5rem;
  }
  
  .subtitle {
    font-size: 1.2rem;
  }
  
  .todo-item {
    padding: 1.2rem;
  }
  
  .todo-content span {
    font-size: 1.1rem;
  }
}

.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}

.todo-stats {
  display: flex;
  justify-content: space-between;
  margin-top: 1.5rem;
  padding: 1.25rem;
  background: #f5f5f7;
  border-radius: 12px;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.03);
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 0 1rem;
  position: relative;
}

.stat-item:not(:last-child)::after {
  content: '';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  height: 70%;
  width: 1px;
  background: rgba(0, 0, 0, 0.1);
}

.stat-label {
  font-size: 0.9rem;
  color: #86868b;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1d1d1f;
  background: linear-gradient(135deg, #0071e3, #34c759);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  transition: transform 0.2s ease;
}

.stat-item:hover .stat-value {
  transform: scale(1.1);
}

/* 为不同状态添加不同的渐变色 */
.stat-item:nth-child(1) .stat-value {
  background: linear-gradient(135deg, #ff9500, #ff2d55);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.stat-item:nth-child(2) .stat-value {
  background: linear-gradient(135deg, #34c759, #30b956);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.stat-item:nth-child(3) .stat-value {
  background: linear-gradient(135deg, #0071e3, #5856d6);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
</style>
