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
}

void apMain(void)
{

  while(1)
  {

    cliMain();
  }
}
