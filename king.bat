@echo off
setlocal enabledelayedexpansion

:: king 命令集 - 王同学自制版本控制系统
:: 版本: 2.1
:: 作者: 王同学 (11岁)
:: 用法: king [命令] [参数]

:: ========== 显示帮助 ==========
if "%1"=="" goto help
if "%1"=="help" goto help
if "%1"=="?" goto help
if "%1"=="new" goto new
if "%1"=="add" goto add
if "%1"=="load" goto load
if "%1"=="history" goto history
if "%1"=="status" goto status
if "%1"=="download" goto download
if "%1"=="down" goto download
if "%1"=="upload" goto upload
if "%1"=="up" goto upload
if "%1"=="copy" goto copy

:: 未知命令
echo 未知命令: %1
echo 输入 'king help' 查看帮助
goto :eof

:: ========== 帮助 ==========
:help
echo ========================================
echo            king 命令集 v2.1
echo            by 王同学 (11岁)
echo ========================================
echo king help / king ?         显示帮助
echo king new                   创建 .king 仓库 + Git 初始化
echo king add [文件名]           添加到缓冲区 (.king\buffer)
echo king load [文件名]          从缓冲区加载到仓库 (.king\repo)
echo king history               查看历史记录
echo king status                查看缓冲区/仓库区状态
echo king download [文件名]      从 GitHub 下载文件
echo king upload [文件名] [网址]  上传到 GitHub
echo king copy [目标路径]        克隆项目到目标路径
echo ========================================
echo 示例:
echo   king upload openclaw-mini.py github.com/用户名/仓库名
echo   king upload README.md github.com/用户名/仓库名
echo ========================================
goto :eof

:: ========== 新建仓库 ==========
:new
if not exist .king (
    mkdir .king
    mkdir .king\buffer
    mkdir .king\repo
    mkdir .king\history
    echo [%date% %time%] 仓库初始化 > .king\history\history.log
    echo [成功] 已创建 .king 仓库
) else (
    echo [警告] .king 仓库已存在
)

:: 顺便初始化 Git 仓库
if not exist ".git" (
    git init
    echo [成功] Git 仓库已初始化
) else (
    echo [警告] Git 仓库已存在
)
goto :eof

:: ========== 添加文件到缓冲区 ==========
:add
if "%2"=="" (
    echo [错误] 请指定要添加的文件
    goto :eof
)
if not exist .king (
    echo [错误] 请先运行 king new 创建仓库
    goto :eof
)
if not exist %2 (
    echo [错误] 文件 %2 不存在
    goto :eof
)
copy %2 .king\buffer\ > nul
echo [%date% %time%] 添加文件 %2 >> .king\history\history.log
echo [成功] 文件 %2 已添加到缓冲区
goto :eof

:: ========== 加载文件到仓库区 ==========
:load
if "%2"=="" (
    echo [错误] 请指定要从缓冲区加载的文件
    goto :eof
)
if not exist .king\buffer\%2 (
    echo [错误] 缓冲区中没有文件 %2
    goto :eof
)
copy .king\buffer\%2 .king\repo\ > nul
echo [%date% %time%] 加载文件 %2 到仓库 >> .king\history\history.log
echo [成功] 文件 %2 已加载到仓库
goto :eof

:: ========== 查看历史记录 ==========
:history
if not exist .king\history\history.log (
    echo 暂无历史记录
) else (
    echo ========== 历史记录 ==========
    type .king\history\history.log
)
goto :eof

:: ========== 查看状态 ==========
:status
echo ========== 缓冲区 (.king\buffer) ==========
if exist .king\buffer (
    dir .king\buffer
) else (
    echo 缓冲区为空
)
echo ========== 仓库区 (.king\repo) ==========
if exist .king\repo (
    dir .king\repo
) else (
    echo 仓库区为空
)
goto :eof

:: ========== 下载文件 ==========
:download
if "%2"=="" (
    echo [错误] 请指定要下载的文件
    goto :eof
)

:: 检查是否有远程仓库
git remote -v | find "origin" > nul
if errorlevel 1 (
    echo [错误] 未关联远程仓库，请先使用 king upload 上传一次
    goto :eof
)

echo [下载] 正在从 GitHub 拉取最新代码...
git pull origin main --no-edit

if exist %2 (
    echo [成功] 文件 %2 已下载
) else (
    echo [警告] 文件 %2 不存在于远程仓库，但代码已同步
)
goto :eof

:: ========== 上传文件（手动指定网址） ==========
:upload
if "%2"=="" (
    echo [错误] 请指定要上传的文件
    echo 示例: king upload openclaw-mini.py github.com/用户名/仓库名
    goto :eof
)
if "%3"=="" (
    echo [错误] 请指定目标仓库网址
    echo 示例: king upload openclaw-mini.py github.com/用户名/仓库名
    goto :eof
)

:: 处理目标网址：自动补全 https:// 和 .git
set "raw_url=%3"

:: 去掉可能已写的 https:// 前缀
set "raw_url=%raw_url:https://=%"
set "raw_url=%raw_url:http://=%"

:: 去掉末尾的 / 或 .git
if "!raw_url:~-1!"=="/" set "raw_url=!raw_url:~0,-1!"
if "!raw_url:~-4!"==".git" set "raw_url=!raw_url:~0,-4!"

:: 组装完整 URL
set "full_url=https://!raw_url!.git"

echo [链接] 目标仓库: %full_url%

:: 检查并设置远程仓库
git remote -v | find "origin" > nul
if errorlevel 1 (
    echo [链接] 正在关联远程仓库...
    git remote add origin %full_url%
) else (
    echo [链接] 远程仓库已存在，更新地址...
    git remote set-url origin %full_url%
)

:: 添加文件并提交
echo [上传] 正在上传 %2 ...
git add %2
git commit -m "上传文件 %2 [%date% %time%]"
git push -u origin main

if %errorlevel% equ 0 (
    echo [成功] 上传完成！
    echo [%date% %time%] 上传文件 %2 到 %raw_url% >> .king\history\history.log
) else (
    echo [错误] 上传失败，请检查网络或 Git 配置
    echo [提示] 确保 GitHub 仓库已创建（不要勾选 README）
)
goto :eof

:: ========== 克隆项目 ==========
:copy
if "%2"=="" (
    echo [错误] 请指定要克隆到的目标路径
    goto :eof
)
echo [克隆] 正在克隆项目到 %2 ...
git clone . %2
if %errorlevel% equ 0 (
    echo [%date% %time%] 克隆项目到 %2 >> .king\history\history.log
    echo [成功] 项目已克隆到 %2
) else (
    echo [错误] 克隆失败，请检查目标路径
)
goto :eof