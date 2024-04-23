/*
 * ap.c
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */


#include "ap.h"


void StopMode(void);


void apInit(void)
{
  cliOpen(_DEF_UART2, 57600);

  ledOn(0);
  uartPrintf(_DEF_UART2, "Firmware Begin...\n");
}

void apMain(void)
{
  uint32_t pre_time;

  pre_time = millis();
  while(1)
  {
    if(millis() - pre_time >= 100)
    {
      pre_time = millis();

      changeBeaconStarted(true);

      handleBeaconStart();

      StopMode();
    }

    //cliMain();
  }
}

void StopMode(void)
{
  ledOff(0);

  // SysTick을 중단합니다.
  HAL_SuspendTick();

  // 저전력 모드로 진입합니다.
  HAL_PWR_EnterSTOPMode(PWR_LOWPOWERREGULATOR_ON, PWR_STOPENTRY_WFE);

  // 시스템이 깨어날 때 SysTick을 다시 시작합니다.
  HAL_ResumeTick();
}
