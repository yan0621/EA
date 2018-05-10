#include <Expert\ExpertTrailing.mqh>

class CTrailingFloatTurtle : public CExpertTrailing {
public:
   CTrailingFloatTurtle(void);
   ~CTrailingFloatTurtle(void);
   
   virtual bool      CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp);
   virtual bool      CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingFloatTurtle::CTrailingFloatTurtle(void) {
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingFloatTurtle::~CTrailingFloatTurtle(void) {
}
//+------------------------------------------------------------------+

bool CTrailingFloatTurtle::CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp) {
   return(false);
}

bool CTrailingFloatTurtle::CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp) {
   return(false);
}