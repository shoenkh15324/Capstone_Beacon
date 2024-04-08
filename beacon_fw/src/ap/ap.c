/*
 * ap.c
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */


#include "ap.h"




void apInit(void)
{
  cliOpen(_DEF_UART2, 57600);
  uartOpen(_DEF_UART3, 9600);
}

void apMain(void)
{
  uint32_t pre_uart2_time;

  pre_uart2_time = millis();
  while(1)
  {
    if(millis() - pre_uart2_time >= 500)
    {
      if(uartAvailable(_DEF_UART3) >= 0)
      {
        pre_uart2_time = millis();
        uartPrintf(_DEF_UART3, "RF TEST\n");
      }
    }

    cliMain();
  }
}
