/*
 * hw.c
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */


#include "hw.h"

void hwInit(void)
{
  iwdgInit();
  iwdgBegin(313); // 500.8ms

  bspInit();
  cliInit();
  ledInit();
  cdcInit();
  uartInit();
  gpioInit();
  beaconInit();
  buttonInit();
  dht22Init(GPIOB, GPIO_PIN_0);
}
