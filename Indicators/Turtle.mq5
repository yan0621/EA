//+------------------------------------------------------------------+
//|                                                       Turtle.mq5 |
//|                                                          Yan Pan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Yan Pan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_buffers 1
#property indicator_plots   1
//--- plot direction
#property indicator_label1  "direction"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- input parameters
input int      size=4;
//--- indicator buffers
double         directionBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,directionBuffer,INDICATOR_DATA);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   for (int i = 0; i < rates_total; ++i) {
      double max = 0;
      double min = 99999.0;
      for (int j = i - 1; j >= 0 && j >= i - size; --j) {
         if (high[j] > max) {
            max = high[j];
         }
         if (low[i] < min) {
            min = low[j];
         }
      }
      if (close[i] > max) {
         directionBuffer[i] = 1;
      } else if (close[i] < min) {
         directionBuffer[i] = -1;
      } else {
         directionBuffer[i] = 0;
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
