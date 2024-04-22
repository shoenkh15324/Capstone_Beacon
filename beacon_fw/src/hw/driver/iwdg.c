/*
 * iwdg.c
 *
 *  Created on: Apr 21, 2024
 *      Author: mok07
 */


#include "iwdg.h"


#ifdef _USE_HW_IWDG


static IWDG_HandleTypeDef hiwdg;


bool iwdgInit(void)
{
  return true;
}

bool iwdgBegin(uint32_t time_ms)
{
  if(time_ms >= 4095)
    return false;

  hiwdg.Instance = IWDG;
  hiwdg.Init.Prescaler = IWDG_PRESCALER_64; // 1.6ms 단위.
  hiwdg.Init.Reload = time_ms;
  //hiwdg.Init.Window = time_ms;

  if (HAL_IWDG_Init(&hiwdg) != HAL_OK)
  {
    return false;
  }

  return true;
}

bool iwdgRefresh(void)
{
  HAL_IWDG_Refresh(&hiwdg);

  return true;
}


#endif
