# Todo List Application

<div align="center">
  <img src="https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white" alt="Vue.js 3.x">
  <img src="https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white" alt="Spring Boot 3.x">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL 8.0">
</div>

## 📝 项目简介

这是一个基于 Vue.js 3 和 Spring Boot 3 开发的现代化待办事项管理应用。该应用提供了直观的用户界面和完整的后端支持，帮助用户高效管理日常任务。

### ✨ 主要特性

- 🎯 简洁直观的用户界面
- 📱 响应式设计，支持多端适配
- 🔄 实时数据同步
- 📊 任务完成统计
- 🎨 优雅的动画效果
- 🔍 任务搜索功能
- 📦 数据持久化存储

## 🚀 技术栈

### 前端
- Vue.js 3
- Vite
- TailwindCSS
- Axios
- Vue Router

### 后端
- Spring Boot 3
- Spring Data JPA
- MySQL 8.0
- Lombok
- Maven

## 🛠️ 快速开始

### 环境要求
- Node.js 16+
- JDK 17+
- MySQL 8.0+

### 前端启动
```bash
# 进入前端目录
cd vue-project

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 后端启动
```bash
# 进入后端目录
cd todo-list-backend

# 编译项目
mvn clean package

# 运行应用
java -jar target/todo-list-backend-0.0.1-SNAPSHOT.jar
```

## 📚 项目结构

```
todo-list/
├── vue-project/          # 前端项目
│   ├── src/
│   │   ├── api/         # API 接口
│   │   ├── components/  # 组件
│   │   ├── utils/       # 工具函数
│   │   └── App.vue      # 主组件
│   └── package.json
│
└── todo-list-backend/    # 后端项目
    ├── src/
    │   ├── main/
    │   │   ├── java/
    │   │   │   ├── controller/  # 控制器
    │   │   │   ├── service/     # 服务层
    │   │   │   ├── repository/  # 数据访问层
    │   │   │   └── model/       # 数据模型
    │   │   └── resources/       # 配置文件
    │   └── test/                # 测试代码
    └── pom.xml
```

## 🔍 功能演示

### 添加任务
![添加任务](https://via.placeholder.com/400x200?text=Add+Todo)

### 完成任务
![完成任务](https://via.placeholder.com/400x200?text=Complete+Todo)

### 任务统计
![任务统计](https://via.placeholder.com/400x200?text=Todo+Stats)

## 📖 API 文档

详细的 API 文档请查看 [API Documentation](api-documentation.md)


## 👥 作者

- **Your Name** - *Initial work* - [Egoist](https://github.com/frankion10093)

## 🙏 致谢

- [Vue.js](https://vuejs.org/)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [TailwindCSS](https://tailwindcss.com/)
- [Vite](https://vitejs.dev/)

## 📞 联系方式

- 项目链接：[https://github.com/frankion10093/todo-list](https://github.com/frankion10093/todo-list)
- 邮箱：yeqi914@gmail.com

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/frankion10093">Egoist</a></sub>
</div> 