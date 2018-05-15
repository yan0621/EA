#include <Expert\ExpertSignal.mqh>

class CSignalFloatTurtle : public CExpertSignal {
private:
   CiMA m_MA;
   // parameters
   int m_ma_period; // peirod length of MA signal
   ENUM_MA_METHOD m_ma_method; // method for calculating ma
   int m_ma_applied; // applied pirce of MA signal
   
   CiCustom m_turtle;
   //parameters
   int m_turtle_size; // size of turtle rule
   
   // patterns
   int m_pattern_0; // turtle breakout following MA direction

public:
   CSignalFloatTurtle(void);
   ~CSignalFloatTurtle(void);
   
   // setter
   void MAPeriod(int value) { m_ma_period = value; }
   void MAMethod(ENUM_MA_METHOD value) { m_ma_method = value; }
   void MAApplied(ENUM_APPLIED_PRICE value) { m_ma_applied = value; }
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
   double MA(int idx) { return m_MA.Main(idx); }
   double Turtle(int idx) { return m_turtle.GetData(0, idx); }
   bool isMARising(int idx) { return MA(idx) > MA(idx+1) && MA(idx+1) > MA(idx+2); }
   bool isMAFalling(int idx) { return MA(idx) < MA(idx+1) && MA(idx+1) < MA(idx+2); }

   // config
   //ENUM_TIMEFRAMES getUpLevelTimeFrames(ENUM_TIMEFRAMES currentTimeFrame)
};

CSignalFloatTurtle::CSignalFloatTurtle(void):
   m_ma_period(20),
   m_ma_method(0), // simple average, expotional, smoothed, linear weight
   m_ma_applied(0), // price close
   m_turtle_size(4),
   m_pattern_0(100) // single pattern
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
   if (!InitTurtle(indicators)) {
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
   if (!m_MA.Create(m_symbol.Name(), m_period, m_ma_period, 0, m_ma_method, m_ma_applied)) {
      printf(__FUNCTION__+": error initializing object");
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
   if (Turtle(idx) > 0 && Close(idx) > MA(idx) && isMARising(idx)) {
      result = m_pattern_0;
   }
   return(result);
}

int CSignalFloatTurtle::ShortCondition() {
   int result = 0;
   int idx = StartIndex();
   if (Turtle(idx) < 0 && Close(idx) < MA(idx) && isMAFalling(idx)) {
      result = m_pattern_0;
   }
   return(result);
}