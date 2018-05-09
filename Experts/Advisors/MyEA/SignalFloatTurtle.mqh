#include <Expert\ExpertSignal.mqh>

class CSignalFloatTurtle : public CExpertSignal {
private:
   CiMA m_MA;
   // parameters
   ENUM_TIMEFRAMES m_period; // peirod type of MA signal
   int m_period_signal; // peirod length of MA signal
   ENUM_MA_METHOD m_ma_method; // method for calculating ma
   int m_applied; // applied pirce of MA signal

public:
   CSignalFloatTurtle(void);
   ~CSignalFloatTurtle(void);
   
   // setter
   void Period(ENUM_TIMEFRAMES value) { m_period = value; }
   void PeriodSignal(int value) { m_period_signal = value; }
   void Method(ENUM_MA_METHOD value) { m_ma_method = value; }
   void Applied(ENUM_APPLIED_PRICE value) { m_applied = value; } 
   
   //--- method of verification of settings
   virtual bool ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int LongCondition(void);
   virtual int ShortCondition(void);
protected:
   bool InitMA(CIndicators *indicators);
};

CSignalFloatTurtle::CSignalFloatTurtle(void):
   m_period(PERIOD_D1),
   m_period_signal(28),
   m_ma_method(0), // simple average
   m_applied(0) // price close
   {}

CSignalFloatTurtle::~CSignalFloatTurtle(void) {}

bool CSignalFloatTurtle::ValidationSettings(void) {
   if (!CExpertSignal::ValidationSettings()) {
      return(false);
   }
   if (m_period <= 0) {
      return(false);
   }
   return(true);
}

bool CSignalFloatTurtle::InitIndicators(CIndicators *indicators) {
//--- check of pointer is performed in the method of the parent class
//---
//--- initialization of indicators and timeseries of additional filters
   if (!CExpertSignal::InitIndicators(indicators)) {
      return(false);
   }
   if (!InitMA(indicators)) {
      return(false);
   }
//--- ok
   return(true);
}

bool CSignalFloatTurtle::InitMA(CIndicators *indicators) {
//--- add object to collection
   if (!indicators.Add(GetPointer(m_MA))) {
      printf(__FUNCTION__+": error adding object");
      return(false);
   }
//--- initialize object
   if (!m_MA.Create(m_symbol.Name(), m_period, m_period_signal, 0, m_ma_method, m_applied)) {
      printf(__FUNCTION__+": error initializing object");
      return(false);
   }
//--- ok
   return(true);
}

int CSignalFloatTurtle::LongCondition() {
   
   return(false);
}

int CSignalFloatTurtle::ShortCondition() {
   return(false);
}