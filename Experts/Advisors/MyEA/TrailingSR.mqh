#include <Expert\ExpertTrailing.mqh>

/*
 * Trailing with Support and Resistance Level
 */
class CTrailingSR : public CExpertTrailing {
public:
  static const int MAX_RATE_NUM;
  static const int MIN_CONTINOUS_CANDLE_NUM;
  static const int PEAK_RADIUS;

public:
  CTrailingSR(void);
  ~CTrailingSR(void);
   
  virtual bool      CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp);
  virtual bool      CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp);

protected:
  double calculateStopLevel(MqlRates &historyData[], int dataLen, bool isLongOrder);
};

const int CTrailingSR::MAX_RATE_NUM = 12;
const int CTrailingSR::MIN_CONTINOUS_CANDLE_NUM = 3;
const int CTrailingSR::PEAK_RADIUS = 1;

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

double CTrailingSR::calculateStopLevel(MqlRates &historyData[], int dataLen, bool isLongOrder) {
  int continousNum = 0;
  int lastBarDirection = 0; // 1: close > open; -1: close < open
  double minPrice = 9999999;
  double maxPrice = 0;
  
  for (int i = dataLen - 1; i >= 0; --i) {
    MqlRates data = historyData[i];
    if (i < dataLen - 1 && i > 0) {
      if (isLongOrder) {
        // search for minimal value for long order
        if (data.low <= historyData[i+1].low && data.low <= historyData[i-1].low) {
          return data.low;
        }
      }
      else {
        if (data.high >= historyData[i+1].high && data.high >= historyData[i-1].high) {
          return data.high;
        }
      }
    }
    if (data.open > data.close) {
      if (lastBarDirection <= 0) {
        ++continousNum;
        if (data.high > maxPrice) {
          maxPrice = data.high;
        }
        if (data.low < minPrice) {
          minPrice = data.low;
        }
      } else {
        continousNum = 1;
        lastBarDirection = -1;
        maxPrice = data.high;
        minPrice = data.low;
      }
    } else if (data.open < data.close) {
      if (lastBarDirection >= 0) {
        ++continousNum;
        if (data.high > maxPrice) {
          maxPrice = data.high;
        }
        if (data.low < minPrice) {
          minPrice = data.low;
        }
      } else {
        continousNum = 1;
        lastBarDirection = 1;
        maxPrice = data.high;
        minPrice = data.low;
      }
    } else {
      ++continousNum;
      if (data.high > maxPrice) {
        maxPrice = data.high;
      }
      if (data.low < minPrice) {
        minPrice = data.low;
      }
    }
    if (continousNum >= CTrailingSR::MIN_CONTINOUS_CANDLE_NUM) {
      if (isLongOrder && lastBarDirection > 0) {
        return minPrice;
      }
      if (!isLongOrder && lastBarDirection < 0) {
        return maxPrice;
      }
    }
  }
  return 0;
}

bool CTrailingSR::CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp) {
  if (NULL == position) {
    return(false);
  }

  MqlRates historyData[];
  CopyRates(m_symbol.Name(), m_period, StartIndex(), MAX_RATE_NUM, historyData);

  double level = NormalizeDouble(m_symbol.Bid() - m_symbol.StopsLevel() * m_symbol.Point(), m_symbol.Digits());
  double new_sl = NormalizeDouble(calculateStopLevel(historyData, MAX_RATE_NUM, true), m_symbol.Digits());
  double pos_sl = position.StopLoss();
  double base = (pos_sl == 0.0) ? 0.0 : pos_sl;

  sl = EMPTY_VALUE;
  tp = EMPTY_VALUE;
  if (new_sl > base && new_sl < level) {
    sl = new_sl;
  }

  return(sl != EMPTY_VALUE);
}

bool CTrailingSR::CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp) {
  if (NULL == position) {
    return(false);
  }

  MqlRates historyData[];
  CopyRates(m_symbol.Name(), m_period, StartIndex(), MAX_RATE_NUM, historyData);

  double level = NormalizeDouble(m_symbol.Bid() - m_symbol.StopsLevel() * m_symbol.Point(), m_symbol.Digits());
  double new_sl = NormalizeDouble(calculateStopLevel(historyData, MAX_RATE_NUM, false), m_symbol.Digits());
  double pos_sl = position.StopLoss();
  double base = (pos_sl == 0.0) ? 999999.9 : pos_sl;

  sl = EMPTY_VALUE;
  tp = EMPTY_VALUE;
  if (new_sl < base && new_sl > level) {
    sl = new_sl;
  }
  
  return(sl!=EMPTY_VALUE);
}