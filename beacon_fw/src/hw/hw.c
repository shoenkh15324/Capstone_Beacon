/*
 * hw.c
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */


#include "hw.h"

void hwInit(void)
{
  bspInit();

  ledInit();
  cdcInit();
  uartInit();
  cliInit();
  gpioInit();
  beaconInit();
}
