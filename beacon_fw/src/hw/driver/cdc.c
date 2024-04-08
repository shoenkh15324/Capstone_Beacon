/*
 * cdc.c
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */


#include "cdc.h"

static bool is_init = false;


bool cdcInit(void)
{
  bool ret = true;


  is_init = true;

  return ret;
}

bool cdcIsInit(void)
{
  return is_init;
}
