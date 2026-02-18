import tkinter as tk
from tkinter import messagebox, scrolledtext
import os
import requests

# Path to the MQL5 Files directory for AI integration
AI_COMMAND_FILE = r"C:\Users\Ahmed\AppData\Roaming\MetaQuotes\Terminal\010E047102812FC0C18890992854220E\MQL5\Files\ai_command.txt"
AI_RESULT_FILE  = r"C:\Users\Ahmed\AppData\Roaming\MetaQuotes\Terminal\010E047102812FC0C18890992854220E\MQL5\Files\ai_result.txt"

GITHUB_AI_URL = "https://api.github.com/repos/your-username/your-ai-repo/contents/ai_signal.txt"

def fetch_github_ai_signal():
    # Simulate fetching an AI signal from GitHub (replace with your logic)
    # Here, we just return a demo signal
    # To use real GitHub API, you would use requests.get and decode the content
    # Example: requests.get(GITHUB_AI_URL, headers={...})
    return "BUY"  # Replace with actual AI logic

def send_ai_command(cmd):
    try:
        with open(AI_COMMAND_FILE, 'w') as f:
            f.write(cmd)
        messagebox.showinfo("Success", f"Sent AI command: {cmd}")
    except Exception as e:
        messagebox.showerror("Error", f"Error writing AI command: {e}")

def read_ai_result():
    try:
        if os.path.exists(AI_RESULT_FILE):
            with open(AI_RESULT_FILE, 'r') as f:
                return f.read()
        else:
            return "No result yet."
    except Exception as e:
        return f"Error reading result: {e}"

def run_github_ai():
    ai_signal = fetch_github_ai_signal()
    send_ai_command(ai_signal)

def show_result_window():
    result = read_ai_result()
    win = tk.Toplevel()
    win.title("AI Result")
    txt = scrolledtext.ScrolledText(win, width=50, height=10)
    txt.pack(padx=10, pady=10)
    txt.insert(tk.END, result)
    txt.config(state='disabled')

def main():
    root = tk.Tk()
    root.title("MQL5 AI Python Dashboard")
    root.geometry("400x300")

    tk.Label(root, text="Send AI command to MetaTrader 5 EA:").pack(pady=10)

    btn_buy = tk.Button(root, text="Manual BUY", width=18, command=lambda: send_ai_command("BUY"))
    btn_buy.pack(pady=2)
    btn_sell = tk.Button(root, text="Manual SELL", width=18, command=lambda: send_ai_command("SELL"))
    btn_sell.pack(pady=2)
    btn_close = tk.Button(root, text="Close All", width=18, command=lambda: send_ai_command("CLOSE:ALL"))
    btn_close.pack(pady=2)
    btn_balance = tk.Button(root, text="Get Balance", width=18, command=lambda: send_ai_command("GET_BALANCE"))
    btn_balance.pack(pady=2)
    btn_equity = tk.Button(root, text="Get Equity", width=18, command=lambda: send_ai_command("GET_EQUITY"))
    btn_equity.pack(pady=2)
    btn_trades = tk.Button(root, text="Get Trades", width=18, command=lambda: send_ai_command("GET_TRADES"))
    btn_trades.pack(pady=2)

    tk.Label(root, text="--- AI Integration ---").pack(pady=8)
    btn_ai = tk.Button(root, text="Run GitHub AI", width=18, command=run_github_ai)
    btn_ai.pack(pady=2)

    btn_result = tk.Button(root, text="Show Last Result", width=18, command=show_result_window)
    btn_result.pack(pady=8)

    root.mainloop()

if __name__ == "__main__":
    main()
