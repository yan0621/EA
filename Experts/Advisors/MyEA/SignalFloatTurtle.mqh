#include "SignalSimpleMA.mqh"

class CSignalFloatTurtle : public CSignalSimpleMA {
private:
   CiCustom m_turtle;
   //parameters
   int m_turtle_size; // size of turtle rule
   
   // patterns
   int t_pattern_0; // turtle breakout following MA direction

public:
   CSignalFloatTurtle(void);
   ~CSignalFloatTurtle(void);

   void TurtleSize(int value) { m_turtle_size = value; }
   
   //--- method of verification of settings
   virtual bool ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int LongCondition(void);
   virtual int ShortCondition(void);

   //virtual bool OpenLongParams(double &price,double &sl,double &tp,datetime &expiration);
   //virtual bool OpenShortParams(double &price,double &sl,double &tp,datetime &expiration);
protected:
   bool InitMA(CIndicators *indicators);
   bool InitTurtle(CIndicators *indicators);
   
   // get data
   double MA(int idx) { return m_ma.Main(idx); }
   double MASlope(int idx) { return((MA(idx) - MA(idx+1)) / MA(idx+1)); }
   double Turtle(int idx) { return m_turtle.GetData(0, idx); }
};

CSignalFloatTurtle::CSignalFloatTurtle(void):
   m_turtle_size(4),
   t_pattern_0(100) // single pattern
   {
      m_used_series |= USE_SERIES_CLOSE;
   }

CSignalFloatTurtle::~CSignalFloatTurtle(void) {}

bool CSignalFloatTurtle::ValidationSettings(void) {
   if (!CSignalSimpleMA::ValidationSettings()) {
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
   if (!CSignalSimpleMA::InitIndicators(indicators)) {
      return(false);
   }

   if (!InitTurtle(indicators)) {
      return(false);
   }
//--- ok
   return(true);
}

bool CSignalFloatTurtle::InitTurtle(CIndicators *indicators) {
//--- add object to collection
   if (!indicators.Add(GetPointer(m_turtle))) {
      printf(__FUNCTION__+": error adding object");
      return(false);
   }
//--- Set parameters
   MqlParam params[2];
   params[0].type = TYPE_STRING;
   params[0].string_value = "Turtle";
   params[1].type = TYPE_INT;
   params[1].integer_value = m_turtle_size;
//--- initialize object
   int initResult = 0;
   initResult = m_turtle.CustomCreate(m_symbol.Name(), m_period, IND_CUSTOM, 2, params);
   if (initResult < 0) {
      printf(__FUNCTION__+": error initializing object: %d", initResult);
      return(false);
   }
   if (!m_turtle.NumBuffers(1)) {
   printf(__FUNCTION__+": error setting buffer number");
      return(false);
   }
   
   return(true);
}

int CSignalFloatTurtle::LongCondition() {
   int result = 0;
   int idx = StartIndex();
   printf("turtle = %d, close = %.4g, ma = %.4g", Turtle(idx), Close(idx), MA(idx));
   if (Turtle(idx) > 0 && CSignalSimpleMA::matchLongPattern0(idx)) {
      result = t_pattern_0;
   }
   return(result);
}

int CSignalFloatTurtle::ShortCondition() {
   int result = 0;
   int idx = StartIndex();
   printf("turtle = %d, close = %.4f, ma = %.4f", Turtle(idx), Close(idx), MA(idx));
   if (Turtle(idx) < 0 && CSignalSimpleMA::matchShortPattern0(idx)) {
      result = t_pattern_0;
   }
   return(result);
}