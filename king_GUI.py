import tkinter as tk
from tkinter import scrolledtext, messagebox, ttk
import subprocess
import os
import threading

class KingGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("👑 king 命令集 v3.0 - 全中文图形界面")
        self.root.geometry("700x600")
        self.root.configure(bg='#2b2b2b')
        
        # 设置样式
        style = ttk.Style()
        style.theme_use('clam')
        style.configure('TButton', font=('微软雅黑', 10), padding=5)
        style.configure('TLabel', font=('微软雅黑', 10), background='#2b2b2b', foreground='white')
        
        # 标题
        title_label = tk.Label(root, text="🦞 king 命令集", font=('微软雅黑', 20, 'bold'), 
                               bg='#2b2b2b', fg='#0f0')
        title_label.pack(pady=10)
        
        # 工作目录显示
        dir_frame = tk.Frame(root, bg='#2b2b2b')
        dir_frame.pack(pady=5)
        tk.Label(dir_frame, text="当前目录:", bg='#2b2b2b', fg='white').pack(side=tk.LEFT)
        self.dir_label = tk.Label(dir_frame, text="D:\\code", bg='#2b2b2b', fg='#0f0')
        self.dir_label.pack(side=tk.LEFT, padx=5)
        
        # 按钮区域（全是中文！）
        btn_frame = tk.Frame(root, bg='#2b2b2b')
        btn_frame.pack(pady=10)
        
        buttons = [
            ("📁 新建仓库", "king new"),
            ("➕ 添加文件", "king add"),
            ("📦 加载到仓库", "king load"),
            ("📜 查看历史", "king history"),
            ("📊 查看状态", "king status"),
            ("⬇️ 下载文件", "king download"),
            ("⬆️ 上传文件", "king upload"),
            ("📋 搬运项目", "king copy"),
            ("❓ 帮助", "king help"),
            ("🔄 拉取更新", "git pull"),
            ("📤 推送更新", "git push"),
        ]
        
        for i, (text, cmd) in enumerate(buttons):
            btn = tk.Button(btn_frame, text=text, command=lambda c=cmd: self.quick_command(c),
                          bg='#3c3c3c', fg='white', font=('微软雅黑', 9),
                          width=12, height=1, relief=tk.FLAT)
            btn.grid(row=i//3, column=i%3, padx=5, pady=5)
            btn.bind('<Enter>', lambda e, b=btn: b.configure(bg='#5c5c5c'))
            btn.bind('<Leave>', lambda e, b=btn: b.configure(bg='#3c3c3c'))
        
        # 自定义命令输入
        input_frame = tk.Frame(root, bg='#2b2b2b')
        input_frame.pack(pady=10)
        tk.Label(input_frame, text="输入命令:", bg='#2b2b2b', fg='white').pack(side=tk.LEFT)
        self.cmd_entry = tk.Entry(input_frame, width=40, font=('Consolas', 10))
        self.cmd_entry.pack(side=tk.LEFT, padx=5)
        self.cmd_entry.bind('<Return>', self.run_command)
        
        tk.Button(input_frame, text="执行", command=self.run_command,
                 bg='#0f0', fg='black', font=('微软雅黑', 10)).pack(side=tk.LEFT)
        
        # 输出区域
        output_frame = tk.Frame(root, bg='#2b2b2b')
        output_frame.pack(pady=10, fill=tk.BOTH, expand=True)
        tk.Label(output_frame, text="输出结果:", bg='#2b2b2b', fg='white').pack(anchor='w')
        
        self.output_area = scrolledtext.ScrolledText(output_frame, width=80, height=15,
                                                     font=('Consolas', 10), bg='#1e1e1e', fg='#0f0')
        self.output_area.pack(fill=tk.BOTH, expand=True)
        
        # 状态栏
        self.status_label = tk.Label(root, text="就绪", bg='#2b2b2b', fg='#888', anchor='w')
        self.status_label.pack(side=tk.BOTTOM, fill=tk.X, padx=10, pady=5)
        
    def quick_command(self, cmd):
        """快速命令按钮"""
        self.cmd_entry.delete(0, tk.END)
        self.cmd_entry.insert(0, cmd)
        self.run_command()
        
    def run_command(self, event=None):
        """执行命令"""
        cmd = self.cmd_entry.get().strip()
        if not cmd:
            return
            
        self.output_area.insert(tk.END, f"\n> {cmd}\n")
        self.output_area.see(tk.END)
        self.status_label.config(text=f"正在执行: {cmd}")
        
        def run():
            try:
                # 在 D:\code 目录下执行命令
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True, 
                                       cwd="D:\\code", encoding='gbk')
                
                self.root.after(0, self.show_result, result)
            except Exception as e:
                self.root.after(0, self.show_error, str(e))
        
        threading.Thread(target=run, daemon=True).start()
        
    def show_result(self, result):
        """显示执行结果"""
        if result.stdout:
            self.output_area.insert(tk.END, result.stdout)
        if result.stderr:
            self.output_area.insert(tk.END, f"\n[错误] {result.stderr}")
        self.output_area.see(tk.END)
        self.status_label.config(text="执行完成")
        
    def show_error(self, error):
        """显示错误"""
        self.output_area.insert(tk.END, f"\n[异常] {error}\n")
        self.output_area.see(tk.END)
        self.status_label.config(text="执行出错")

if __name__ == "__main__":
    root = tk.Tk()
    app = KingGUI(root)
    root.mainloop()