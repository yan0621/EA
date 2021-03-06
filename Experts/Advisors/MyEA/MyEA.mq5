//+------------------------------------------------------------------+
//|                                                         MyEA.mq5 |
//|                                                          Yan Pan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
#include <Expert\Money\MoneyNone.mqh>
#include "SignalFloatTurtle.mqh"
#include "TrailingSR.mqh"

//--- input parameters
//--- inputs for expert
input string Inp_Expert_Title            ="ExpertFloatTurtle";
int          Expert_MagicNumber          =10982;
bool         Expert_EveryTick            =false;
//--- inputs for signals
input int Inp_Signal_MA_Period = 20;
input int Inp_Signal_Turtle_Size = 4;
input bool Inp_Trailing_Use_Current_Period = true;
input bool Inp_Trailing_Set_Tp_According_To_Last_Deal = false;

// Global Var
CExpert ExtExpert;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(-1);
     }
   
//--- Creation of signal
   CSignalFloatTurtle *signal = new CSignalFloatTurtle;
   if(signal==NULL) {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(-2);
   }
//--- Set signal parameters
//--- Add signal to expert (will be deleted automatically))
   if(!ExtExpert.InitSignal(signal))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing signal");
      ExtExpert.Deinit();
      return(-3);
     }
 //-- Set Signal Parameters
   signal.PeriodMA(Inp_Signal_MA_Period);
   signal.TurtleSize(Inp_Signal_Turtle_Size);
 //--- Check signal parameters
   if(!signal.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error signal parameters");
      ExtExpert.Deinit();
      return(-4);
     }
//--- Creation of trailing object
   CTrailingSR *trailing = new CTrailingSR;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(-5);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(-6);
     }
//--- Set trailing parameters
   trailing.UseCurrentPeriod(Inp_Trailing_Use_Current_Period);
   trailing.SetTpAccorrdingToLastDeal(Inp_Trailing_Set_Tp_According_To_Last_Deal);
//--- Check trailing parameters
   if(!trailing.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error trailing parameters");
      ExtExpert.Deinit();
      return(-7);
     }
//--- Creation of money object
   CMoneyNone *money=new CMoneyNone;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(-8);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(-9);
     }
//--- Set money parameters
//--- Check money parameters
   if(!money.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error money parameters");
      ExtExpert.Deinit();
      return(-10);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(-11);
     }
//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ExtExpert.Deinit();
}
//+------------------------------------------------------------------+
//| Function-event handler "tick"                                    |
//+------------------------------------------------------------------+
void OnTick(void) {
   ExtExpert.OnTick();
}
//+------------------------------------------------------------------+
//| Function-event handler "trade"                                   |
//+------------------------------------------------------------------+
void OnTrade(void) {
   ExtExpert.OnTrade();
}
//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer(void) {
   ExtExpert.OnTimer();
}
//+------------------------------------------------------------------+
