
# 👑 king – 你的文件版本管家

`king` 是一个用纯批处理脚本编写的极简版本控制系统。

## 🎯 为什么会有 king？

展示版本控制最朴素的样子：**备份、记录、还原**。

## ✨ 核心功能

- 一个 `.bat` 文件，零外部依赖
- 缓冲区 + 仓库区两阶段管理
- 历史记录追溯
- 项目快照备份
- 支持 GitHub 同步

## 📦 快速开始

### 1. 安装

下载 `king.bat`，复制到 `C:\Windows\System32`

### 2. 初始化

```bash
cd /d D:\my-project
king new
```

### 3. 记录版本



```
king add story.txt
king load story.txt
```



### 4. 查看状态和历史



```
king status
king history
```



## 🛠️ 命令表

| 命令                          | 作用           |
| :---------------------------- | :------------- |
| `king new`                    | 创建仓库       |
| `king add <文件名>`           | 添加到缓冲区   |
| `king load <文件名>`          | 提交到仓库     |
| `king status`                 | 查看状态       |
| `king history`                | 查看历史       |
| `king copy <路径>`            | 克隆项目       |
| `king upload <文件名> <网址>` | 推送到 GitHub  |
| `king download <文件名>`      | 从 GitHub 拉取 |

## 🤝 开源

MIT 许可证。本软件由 **王同学 (11岁)** 独立开发，不得声称自研。

**全程 CMD · 无依赖 · 纯手工打造**

