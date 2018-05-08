#include <Expert\ExpertSignal.mqh>

class CSignalFloatTurtle : public CExpertSignal {
private:
   CiMA m_MA;
   // parameters
   int m_period; // period length of MA signal
   int m_period_signal; // peirod type of MA signal
   ENUM_APPLIED_PRICE m_applied; // applied pirce of MA signal

public:
   CSignalFloatTurtle(void);
   ~CSignalFloatTurtle(void);
   
   // setter
   void MPeriod(int value) { m_period = value; }
   
   //--- method of verification of settings
   virtual bool      ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);
   
};

CSignalFloatTurtle::CSignalFloatTurtle(void): m_period(28) {}

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
   if(!CExpertSignal::InitIndicators(indicators))
      return(false);
//--- ok
   return(true);
}

int CSignalFloatTurtle::LongCondition() { return(false); }

int CSignalFloatTurtle::ShortCondition() { return(false); }