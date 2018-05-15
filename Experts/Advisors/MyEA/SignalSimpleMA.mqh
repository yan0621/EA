/*
 * Use single MA line as signal.
 */

#include <Expert\ExpertSignal.mqh>

class CSignalSimpleMA : public CExpertSignal {
private:
   CiMA m_ma;
   
   int m_ma_period;      // the "period of averaging" parameter of the indicator
   int m_ma_shift;       // the "time shift" parameter of the indicator
   ENUM_MA_METHOD m_ma_method;      // the "method of averaging" parameter of the indicator
   ENUM_APPLIED_PRICE m_ma_applied;    // the "object of averaging" parameter of the indicator
   //--- "weights" of market models (0-100)
   int m_pattern_0;      // model 0 "price is on the necessary side from the indicator"

public:
   CSignalSimpleMA(void);
   ~CSignalSimpleMA(void);
   
   void PeriodMA(int value)                 { m_ma_period=value;          }
   void Shift(int value)                    { m_ma_shift=value;           }
   void Method(ENUM_MA_METHOD value)        { m_ma_method=value;          }
   void Applied(ENUM_APPLIED_PRICE value)   { m_ma_applied=value;         }
   
   //--- method of verification of settings
   virtual bool      ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);
   
protected:
   //--- method of initialization of the indicator
   bool              InitMA(CIndicators *indicators);
   //--- methods of getting data
   double            MA(int ind)                         { return(m_ma.Main(ind));     }
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalMA::CSignalMA(void) : m_ma_period(12),
                             m_ma_shift(0),
                             m_ma_method(MODE_SMA),
                             m_ma_applied(PRICE_CLOSE),
                             m_pattern_0(100),
{}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalMA::~CSignalMA(void) {}

//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//+------------------------------------------------------------------+
bool CSignalMA::ValidationSettings(void) {
//--- validation settings of additional filters
   if(!CExpertSignal::ValidationSettings())
      return(false);
//--- initial data checks
   if(m_ma_period<=0)
     {
      printf(__FUNCTION__+": period MA must be greater than 0");
      return(false);
     }
//--- ok
   return(true);
}

//+------------------------------------------------------------------+
//| Create indicators.                                               |
//+------------------------------------------------------------------+
bool CSignalMA::InitIndicators(CIndicators *indicators)
  {
//--- check pointer
   if(indicators==NULL)
      return(false);
//--- initialization of indicators and timeseries of additional filters
   if(!CExpertSignal::InitIndicators(indicators))
      return(false);
//--- create and initialize MA indicator
   if(!InitMA(indicators))
      return(false);
//--- ok
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Initialize MA indicators.                                        |
//+------------------------------------------------------------------+
bool CSignalMA::InitMA(CIndicators *indicators) {
//--- check pointer
   if(indicators==NULL)
      return(false);
//--- add object to collection
   if(!indicators.Add(GetPointer(m_ma)))
     {
      printf(__FUNCTION__+": error adding object");
      return(false);
     }
//--- initialize object
   if(!m_ma.Create(m_symbol.Name(),m_period,m_ma_period,m_ma_shift,m_ma_method,m_ma_applied))
     {
      printf(__FUNCTION__+": error initializing object");
      return(false);
     }
//--- ok
   return(true);
}

int CSignalMA::LongCondition(void) {
   int result = 0;
   int idx = StartIndex();
   
   return(result);
}

int CSignalMA::ShortCondition(void) {
   int result = 0;
   return(result);
}