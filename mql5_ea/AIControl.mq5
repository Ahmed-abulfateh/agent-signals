//+------------------------------------------------------------------+
//|                                                      AIControl.mq5|
//|                        Example MQL5 Expert Advisor               |
//+------------------------------------------------------------------+
#property copyright "Your Name"
#property link      "https://github.com/your-repo"
#property version   "1.00"
#property strict

input bool UseAITrading = false;
input string ControlFile = "C:\\Users\\Ahmed\\Downloads\\code\\ga\\labs\\mql5-ecper-with-Ai\\control.txt";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("AIControl EA initialized");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("AIControl EA deinitialized");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Check for control commands from Java dashboard
   string command = ReadControlCommand();
   if(command != "")
     {
      ProcessCommand(command);
     }
   // AI trading mode
   if(UseAITrading)
     {
      // Placeholder: Call AI agent or process AI signal
      Print("AI trading mode active");
     }
  }
//+------------------------------------------------------------------+
//| Read control command from file                                   |
//+------------------------------------------------------------------+
string ReadControlCommand()
  {
   string cmd = "";
   int handle = FileOpen(ControlFile, FILE_READ|FILE_TXT);
   if(handle != INVALID_HANDLE)
     {
      if(!FileIsEnding(handle))
         cmd = FileReadString(handle);
      FileClose(handle);
     }
   return cmd;
  }
//+------------------------------------------------------------------+
//| Process command from dashboard                                   |
//+------------------------------------------------------------------+
void ProcessCommand(string cmd)
  {
  if(cmd == "AI_ON")
    UseAITrading = true;
  else if(cmd == "AI_OFF")
    UseAITrading = false;
  else if(UseAITrading && (cmd == "BUY" || cmd == "SELL"))
    {
    ExecuteTrade(cmd);
    }
  // Add more commands as needed
  Print("Processed command: ", cmd);
  }
//+------------------------------------------------------------------+

//| Execute trade based on AI signal                                |
//+------------------------------------------------------------------+
void ExecuteTrade(string signal)
  {
  double lotSize = 0.1; // Example lot size
  int slippage = 3;
  double price = 0;
  int ticket = -1;
  if(signal == "BUY")
    {
    price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    ticket = OrderSend(_Symbol, OP_BUY, lotSize, price, slippage, 0, 0, "AI BUY", 0, 0, clrGreen);
    if(ticket > 0)
      Print("AI BUY order sent, ticket: ", ticket);
    else
      Print("AI BUY order failed: ", GetLastError());
    }
  else if(signal == "SELL")
    {
    price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    ticket = OrderSend(_Symbol, OP_SELL, lotSize, price, slippage, 0, 0, "AI SELL", 0, 0, clrRed);
    if(ticket > 0)
      Print("AI SELL order sent, ticket: ", ticket);
    else
      Print("AI SELL order failed: ", GetLastError());
    }
  }