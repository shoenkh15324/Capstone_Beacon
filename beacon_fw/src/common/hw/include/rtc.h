/*
 * rtc.h
 *
 *  Created on: Apr 20, 2024
 *      Author: mok07
 */

#ifndef SRC_COMMON_HW_INCLUDE_RTC_H_
#define SRC_COMMON_HW_INCLUDE_RTC_H_

#include "hw_def.h"


#ifdef _USE_HW_RTC


typedef struct
{
  uint8_t hours;
  uint8_t minutes;
  uint8_t seconds;
} rtc_time_t;

typedef struct
{
  uint8_t year;
  uint8_t month;
  uint8_t day;
} rtc_date_t;

typedef struct
{
  rtc_time_t time;
  rtc_date_t date;
} rtc_info_t;


bool rtcInit(void);
bool rtcGetInfo(rtc_info_t *rtc_info);
bool rtcGetTime(rtc_time_t *rtc_time);
bool rtcGetDate(rtc_date_t *rtc_date);
bool rtcSetTime(rtc_time_t *rtc_time);
bool rtcSetData(rtc_date_t *rtc_date);

#endif


#endif /* SRC_COMMON_HW_INCLUDE_RTC_H_ */
