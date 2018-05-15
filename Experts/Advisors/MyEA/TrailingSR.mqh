/*
 * Trailing with Support and Resistance Level
 */
class CTrailingSR : public CExpertTrailing {
public:
   CTrailingSR(void);
   ~CTrailingSR(void);
   
   virtual bool      CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp);
   virtual bool      CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingSR::CTrailingSR(void) {
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingSR::~CTrailingSR(void) {
}
//+------------------------------------------------------------------+

bool CTrailingSR::CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp) {
   return(false);
}

bool CTrailingSR::CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp) {
   return(false);
}