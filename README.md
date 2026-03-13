# 👑 king 命令集

> Git 简单版 · 命令行工具 · 纯 CMD 实现

## 📌 简介

`king` 是我用纯批处理（`.bat`）写的**简易版本控制系统**，灵感来自 Git，但更简单、更轻量，完全在 CMD 环境下运行。

**特点：**
- ✅ 纯 CMD 实现，无需安装任何依赖
- ✅ 绿色免安装，一个 `.bat` 文件搞定
- ✅ 包含缓冲区、仓库区、历史记录等基本概念
- ✅ 全程命令行操作（真男人用 CMD！）

---

## 🚀 安装方法

### 方法一：直接下载
1. 点击本页面右上角的 **Code** → **Download ZIP**
2. 解压，把 `king.bat` 放到 `C:\Windows\System32` 或任意 PATH 目录
3. 打开 CMD，输入 `king help` 测试

### 方法二：Git 克隆
```bash
git clone https://github.com/wangtongxue2014/king.git
cd king
# 然后把 king.bat 加入 PATH
```

---

## 📖 使用说明

### 初始化仓库
```cmd
king new
```
创建 `.king` 目录结构（buffer/repo/history）

### 添加文件到缓冲区
```cmd
king add 文件名.txt
```
相当于 Git 的 `git add`

### 加载到仓库区
```cmd
king load 文件名.txt
```
从缓冲区提交到仓库（相当于 `git commit`）

### 查看历史
```cmd
king history
```
显示所有操作记录

### 查看状态
```cmd
king status
```
显示缓冲区/仓库区文件列表

### 搬运整个项目
```cmd
king copy 项目名
```
备份整个 `.king` 仓库

---

## 🛠️ 命令速查表

| 命令 | 缩写 | 作用 |
|------|------|------|
| `king help` / `king ?` | - | 显示帮助 |
| `king new` | - | 创建新仓库 |
| `king add 文件名` | `add` | 添加到缓冲区 |
| `king load 文件名` | `load` | 加载到仓库 |
| `king history` | - | 查看历史 |
| `king status` | - | 查看状态 |
| `king copy 项目名` | - | 搬运项目 |

---

## 🔮 未来计划

我正在开发 **`king` 的 GUI 版本**，将包含：
- ✅ 图形化界面（不再只有黑框）
- ✅ 可视化版本树
- ✅ 一键提交/回滚
- ✅ 跨平台支持

**项目将完全开源**，欢迎关注和贡献！

---

## 📜 许可证

MIT License © 2026 王同学

---

## 🦞 真男人认证

```
全程 CMD 开发 · 无 GUI 依赖 · 纯手工打造
```
