@echo off
setlocal enabledelayedexpansion

:: king 命令集 - 王同学自制版本控制系统
:: 版本: 2.0
:: 用法: king [命令] [参数]

:: 如果没有参数，显示帮助
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
pause
:help
echo ========================================
echo            king 命令集 v2.0
echo            by 王同学
echo ========================================
echo king help / king ?         显示帮助
echo king new                   创建新的 .king 仓库
echo king add [文件名]           添加到缓冲区 (.king\buffer)
echo king load [文件名]          从缓冲区上传到仓库 (.king\repo)
echo king history                查看历史记录
echo king status                 查看改动状态
echo king download [文件名]      从 GitHub 下载到仓库
echo king upload [文件名] [目标]  上传到 GitHub
echo king copy [项目名]          搬运项目
echo ========================================
goto :eof
pause
:new
:: 创建 .king 仓库结构
if not exist .king (
    mkdir .king
    mkdir .king\buffer
    mkdir .king\repo
    mkdir .king\history
    echo [%date% %time%] 仓库初始化 > .king\history\history.log
    echo 已创建 .king 仓库
) else (
    echo .king 仓库已存在
)
goto :eof
pause
:add
:: 添加文件到缓冲区
if "%2"=="" (
    echo 请指定要添加的文件
    goto :eof
)
if not exist .king (
    echo 请先运行 king new 创建仓库
    goto :eof
)
if not exist %2 (
    echo 文件 %2 不存在
    goto :eof
)
copy %2 .king\buffer\ > nul
echo [%date% %time%] 添加文件 %2 >> .king\history\history.log
echo 文件 %2 已添加到缓冲区
goto :eof
pause
:load
:: 从缓冲区加载到仓库区
if "%2"=="" (
    echo 请指定要从缓冲区加载的文件
    goto :eof
)
if not exist .king\buffer\%2 (
    echo 缓冲区中没有文件 %2
    goto :eof
)
copy .king\buffer\%2 .king\repo\ > nul
echo [%date% %time%] 加载文件 %2 到仓库 >> .king\history\history.log
echo 文件 %2 已加载到仓库
goto :eof
pause
:history
:: 查看历史记录
if not exist .king\history\history.log (
    echo 暂无历史记录
) else (
    type .king\history\history.log
)
goto :eof
pause
:status
:: 查看缓冲区/仓库区状态
echo ===== 缓冲区状态 =====
if exist .king\buffer (
    dir .king\buffer
) else (
    echo 缓冲区为空
)
echo ===== 仓库区状态 =====
if exist .king\repo (
    dir .king\repo
) else (
    echo 仓库区为空
)
goto :eof
pause
:download
if "%2"=="" (
    echo 请指定要下载的文件
    goto :eof
)
echo 正在从 GitHub 下载 %2 ...
git pull origin main
if exist %2 (
    echo 文件 %2 已下载
) else (
    echo 文件 %2 不存在于远程仓库
)
goto :eof
pause
:upload
if "%2"=="" (
    echo 请指定要上传的文件
    goto :eof
)
if "%3"=="" (
    echo 请指定提交说明
    goto :eof
)
git add %2
git commit -m "%3"
git push origin main
echo 上传完成
goto :eof
pause
:copy
if "%2"=="" (
    echo 请指定要克隆到的目标路径
    goto :eof
)
echo 正在克隆项目到 %2 ...
git clone . %2
if %errorlevel% equ 0 (
    echo [%date% %time%] 克隆项目到 %2 >> .king\history\history.log
    echo 项目已克隆到 %2
) else (
    echo 克隆失败，请检查目标路径或 Git 状态
)
goto :eof
pause