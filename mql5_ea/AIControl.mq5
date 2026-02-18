//+------------------------------------------------------------------+
//|              AIControl.mq5 - AI-Ready MQL5 EA                  |
//+------------------------------------------------------------------+
#property copyright "Your Name"
#property link      "https://github.com/your-repo"
#property version   "2.00"
#property strict

input string AICommandFile = "ai_command.txt";
input string AIResultFile  = "ai_result.txt";

//+------------------------------------------------------------------+
//| Expert initialization                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("AIControl EA v2 initialized");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   Print("AIControl EA v2 deinitialized");
  }

void OnTick()
  {
   string ai_cmd = ReadAICommand();
   if(ai_cmd != "")
     ProcessAICommand(ai_cmd);
  }

//+------------------------------------------------------------------+
//| Read AI command from file                                       |
//+------------------------------------------------------------------+
string ReadAICommand()
  {
   string cmd = "";
   int handle = FileOpen(AICommandFile, FILE_READ|FILE_TXT);
   if(handle != INVALID_HANDLE)
     {
      cmd = FileReadString(handle);
      FileClose(handle);
     }
   return cmd;
  }

//+------------------------------------------------------------------+
//| Write result to AI result file                                  |
//+------------------------------------------------------------------+
void WriteAIResult(string result)
  {
   int handle = FileOpen(AIResultFile, FILE_WRITE|FILE_TXT);
   if(handle != INVALID_HANDLE)
     {
      FileWrite(handle, result);
      FileClose(handle);
     }
  }

//+------------------------------------------------------------------+
//| Process AI command                                              |
//+------------------------------------------------------------------+
void ProcessAICommand(string cmd)
  {
   if(cmd=="BUY" || cmd=="SELL")
     {
      bool ok = ExecuteTrade(cmd);
      WriteAIResult(ok ? "TRADE_OK" : "TRADE_FAIL");
     }
   else if(StringFind(cmd, "CLOSE:") == 0)
     {
      ulong ticket = (ulong)StringToInteger(StringSubstr(cmd,6));
      bool ok = CloseTrade(ticket);
      WriteAIResult(ok ? "CLOSE_OK" : "CLOSE_FAIL");
     }
   else if(cmd=="GET_BALANCE")
     WriteAIResult(DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2));
   else if(cmd=="GET_EQUITY")
     WriteAIResult(DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2));
   else if(cmd=="GET_TRADES")
     WriteOpenTrades();
   else
     WriteAIResult("UNKNOWN_CMD");
  }

//+------------------------------------------------------------------+
//| Execute trade (BUY/SELL)                                        |
//+------------------------------------------------------------------+
bool ExecuteTrade(string signal)
  {
   double lot = 0.1;
   double price = (signal=="BUY") ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int type = (signal=="BUY") ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
   MqlTradeRequest req;
   MqlTradeResult res;
   ZeroMemory(req);
   ZeroMemory(res);
   req.action = TRADE_ACTION_DEAL;
   req.symbol = _Symbol;
   req.volume = lot;
   req.type = type;
   req.price = price;
   req.deviation = 3;
   req.magic = 2026;
   req.type_filling = ORDER_FILLING_IOC;
   req.type_time = ORDER_TIME_GTC;
   req.comment = "AI TRADE";
   bool ok = OrderSend(req, res);
   return ok && (res.retcode==10009 || res.retcode==10008);
  }

//+------------------------------------------------------------------+
//| Close trade by ticket                                           |
//+------------------------------------------------------------------+
bool CloseTrade(ulong ticket)
  {
   if(!PositionSelectByTicket(ticket)) return false;
   string symbol = PositionGetString(POSITION_SYMBOL);
   double lots = PositionGetDouble(POSITION_VOLUME);
   int type = PositionGetInteger(POSITION_TYPE);
   double price = (type==POSITION_TYPE_BUY) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);
   MqlTradeRequest req;
   MqlTradeResult res;
   ZeroMemory(req);
   ZeroMemory(res);
   req.action = TRADE_ACTION_DEAL;
   req.symbol = symbol;
   req.volume = lots;
   req.position = ticket;
   req.deviation = 3;
   req.magic = 2026;
   req.type = (type==POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
   req.price = price;
   req.type_filling = ORDER_FILLING_IOC;
   req.type_time = ORDER_TIME_GTC;
   req.comment = "AI CLOSE";
   bool ok = OrderSend(req, res);
   return ok && (res.retcode==10009 || res.retcode==10008);
  }

//+------------------------------------------------------------------+
//| Write open trades info to AI result file                        |
//+------------------------------------------------------------------+
void WriteOpenTrades()
  {
   int handle = FileOpen(AIResultFile, FILE_WRITE|FILE_TXT);
   if(handle != INVALID_HANDLE)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         ulong ticket = PositionGetTicket(i);
         string symbol = PositionGetString(POSITION_SYMBOL);
         double lots = PositionGetDouble(POSITION_VOLUME);
         double price = PositionGetDouble(POSITION_PRICE_OPEN);
         string type = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) ? "BUY" : "SELL";
         FileWrite(handle, ticket, symbol, type, DoubleToString(lots,2), DoubleToString(price,2));
        }
      FileClose(handle);
     }
  }