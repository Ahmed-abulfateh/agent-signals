# AIControl MQL5 EA + Python Dashboard + GitHub AI Integration

## Overview
This solution allows you to control MetaTrader 5 (MT5) trading via an MQL5 Expert Advisor (EA) that communicates with a Python dashboard. The dashboard can fetch AI trading signals from a GitHub repository and relay them to the EA, which executes trades and returns results.

---

## How It Works

### 1. MQL5 EA (AIControl.mq5)
- Reads commands from `ai_command.txt` (in the MT5 sandboxed Files directory).
- Executes trading actions: BUY, SELL, CLOSE, GET_BALANCE, GET_EQUITY, GET_TRADES.
- Writes results to `ai_result.txt` for the dashboard to read.

### 2. Python Dashboard (python_dashboard.py)
- GUI for sending manual or AI-driven commands to the EA.
- Fetches AI signals from a GitHub repo (simulated, but can be extended for real use).
- Writes commands to `ai_command.txt` and reads results from `ai_result.txt`.

---

## File Locations
- Place `AIControl.mq5` in your MT5 `Experts` folder and compile it.
- The EA expects `ai_command.txt` and `ai_result.txt` in the MT5 `Files` directory (e.g., `C:\Users\<user>\AppData\Roaming\MetaQuotes\Terminal\<instance>\MQL5\Files\`).
- Update the Python dashboard paths to match your MT5 Files directory.

---

## Usage
1. **Start MetaTrader 5 and attach the compiled EA to a chart.**
2. **Run the Python dashboard:**
   - Send manual commands (BUY, SELL, etc.) or click "Run GitHub AI" to fetch and send an AI signal.
   - Click "Show Last Result" to view the EA's response.
3. **(Optional) Extend the dashboard to fetch real AI signals from your GitHub repo.**

---

## Extending GitHub AI Integration
- Replace the `fetch_github_ai_signal()` function in `python_dashboard.py` with real GitHub API logic to fetch AI signals or trading strategies.
- You can use the `requests` library to access private/public repos, parse files, or trigger cloud-based AI agents.

---

## Security & Notes
- File-based communication is simple and robust for local automation, but not suitable for high-frequency or remote trading.
- Always test with a demo account before using on live funds.
- Ensure the Python dashboard and MT5 terminal are using the same Files directory.

---

## Example Command Flow
1. Dashboard writes `BUY` to `ai_command.txt`.
2. EA reads the command, executes a buy trade, writes `TRADE_OK` or `TRADE_FAIL` to `ai_result.txt`.
3. Dashboard reads and displays the result.

---

## Support
If you need further customization or have questions, just ask!
