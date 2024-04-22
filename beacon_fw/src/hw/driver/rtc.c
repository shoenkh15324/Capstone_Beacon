/*
 * rtc.c
 *
 *  Created on: Apr 20, 2024
 *      Author: mok07
 */


#include "rtc.h"
#include "cli.h"


#ifdef _USE_HW_RTC


RTC_HandleTypeDef hrtc;

#ifdef _USE_HW_CLI
static void cliRtc(cli_args_t *args);
#endif


bool rtcInit(void)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  hrtc.Instance = RTC;
  hrtc.Init.AsynchPrediv = RTC_AUTO_1_SECOND;
  hrtc.Init.OutPut = RTC_OUTPUTSOURCE_ALARM;
  if (HAL_RTC_Init(&hrtc) != HAL_OK)
  {
    return false;
  }

  sTime.Hours = 0;
  sTime.Minutes = 0;
  sTime.Seconds = 0;

  if (HAL_RTC_SetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  DateToUpdate.WeekDay = RTC_WEEKDAY_MONDAY;
  DateToUpdate.Month = RTC_MONTH_JANUARY;
  DateToUpdate.Date = 1;
  DateToUpdate.Year = 0;

  if (HAL_RTC_SetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

#ifdef _USE_HW_CLI
  cliAdd("rtc", cliRtc);
#endif

  return true;
}

bool rtcGetInfo(rtc_info_t *rtc_info)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  if (HAL_RTC_GetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  if (HAL_RTC_GetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  rtc_info->time.hours = sTime.Hours;
  rtc_info->time.minutes = sTime.Minutes;
  rtc_info->time.seconds = sTime.Seconds;

  rtc_info->date.year = DateToUpdate.Year;
  rtc_info->date.month = DateToUpdate.Month;
  rtc_info->date.day = DateToUpdate.Date;

  return true;
}

bool rtcGetTime(rtc_time_t *rtc_time)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  if (HAL_RTC_GetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  if (HAL_RTC_GetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  rtc_time->hours = sTime.Hours;
  rtc_time->minutes = sTime.Minutes;
  rtc_time->seconds = sTime.Seconds;

  return true;
}

bool rtcGetDate(rtc_date_t *rtc_date)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  if (HAL_RTC_GetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  if (HAL_RTC_GetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  rtc_date->year = DateToUpdate.Year;
  rtc_date->month = DateToUpdate.Month;
  rtc_date->day = DateToUpdate.Date;

  return true;
}

bool rtcSetTime(rtc_time_t *rtc_time)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  if (HAL_RTC_GetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  if (HAL_RTC_GetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  sTime.Hours = rtc_time->hours;
  sTime.Minutes = rtc_time->minutes;
  sTime.Seconds = rtc_time->seconds;

  if (HAL_RTC_SetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  return true;
}

bool rtcSetDate(rtc_date_t *rtc_date)
{
  RTC_TimeTypeDef sTime = {0};
  RTC_DateTypeDef DateToUpdate = {0};

  if (HAL_RTC_GetTime(&hrtc, &sTime, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  if (HAL_RTC_GetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  DateToUpdate.Year = rtc_date->year;
  DateToUpdate.Month = rtc_date->month;
  DateToUpdate.Date = rtc_date->day;

  if (HAL_RTC_SetDate(&hrtc, &DateToUpdate, RTC_FORMAT_BIN) != HAL_OK)
  {
    return false;
  }

  return true;
}

#ifdef _USE_HW_CLI

void cliRtc(cli_args_t *args)
{
  bool ret = false;

  if(args->argc == 2 && args->isStr(0,"get") && args->isStr(1, "info"))
  {
    rtc_info_t rtc_info;

    while(cliKeepLoop())
    {
      rtcGetInfo(&rtc_info);

      cliPrintf("Y:%02d M:%02d D%02d, H:%02d M:%02d S:%02d\n",
                rtc_info.date.year,
                rtc_info.date.month,
                rtc_info.date.day,
                rtc_info.time.hours,
                rtc_info.time.minutes,
                rtc_info.time.seconds
                );

      delay(1000);
    }

    ret = true;
  }

  if(args->argc == 5 && args->isStr(0,"set") && args->isStr(1, "time"))
  {
    rtc_time_t rtc_time;

    rtc_time.hours = args->getData(2);
    rtc_time.minutes = args->getData(3);
    rtc_time.seconds = args->getData(4);

    rtcSetTime(&rtc_time);

    cliPrintf("H:%02d M:%02d S:%02d\n",
              rtc_time.hours,
              rtc_time.minutes,
              rtc_time.seconds
                );

    ret = true;
  }

  if(args->argc == 5 && args->isStr(0,"set") && args->isStr(1, "date"))
    {
      rtc_date_t rtc_date;

      rtc_date.year = args->getData(2);
      rtc_date.month = args->getData(3);
      rtc_date.day = args->getData(4);

      rtcSetDate(&rtc_date);

      cliPrintf("Y:%02d M:%02d D:%02d\n",
                rtc_date.year,
                rtc_date.month,
                rtc_date.day
                  );

      ret = true;
    }

  if(ret == false)
  {
    cliPrintf("rtc get info\n");
    cliPrintf("rtc set time [h] [m] [s]\n");
    cliPrintf("rtc set date [y] [m] [d]\n");
  }
}

#endif

void HAL_RTC_MspInit(RTC_HandleTypeDef* rtcHandle)
{

  if(rtcHandle->Instance==RTC)
  {
  /* USER CODE BEGIN RTC_MspInit 0 */

  /* USER CODE END RTC_MspInit 0 */
    HAL_PWR_EnableBkUpAccess();
    /* Enable BKP CLK enable for backup registers */
    __HAL_RCC_BKP_CLK_ENABLE();
    /* RTC clock enable */
    __HAL_RCC_RTC_ENABLE();

    /* RTC interrupt Init */
    HAL_NVIC_SetPriority(RTC_IRQn, 0, 0);
    HAL_NVIC_EnableIRQ(RTC_IRQn);
    HAL_NVIC_SetPriority(RTC_Alarm_IRQn, 0, 0);
    HAL_NVIC_EnableIRQ(RTC_Alarm_IRQn);
  /* USER CODE BEGIN RTC_MspInit 1 */

  /* USER CODE END RTC_MspInit 1 */
  }
}

void HAL_RTC_MspDeInit(RTC_HandleTypeDef* rtcHandle)
{

  if(rtcHandle->Instance==RTC)
  {
  /* USER CODE BEGIN RTC_MspDeInit 0 */

  /* USER CODE END RTC_MspDeInit 0 */
    /* Peripheral clock disable */
    __HAL_RCC_RTC_DISABLE();

    /* RTC interrupt Deinit */
    HAL_NVIC_DisableIRQ(RTC_IRQn);
  /* USER CODE BEGIN RTC_MspDeInit 1 */

  /* USER CODE END RTC_MspDeInit 1 */
  }
}

#endif
