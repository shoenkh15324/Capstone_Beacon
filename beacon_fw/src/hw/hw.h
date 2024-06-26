/*
 * hw.h
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */

#ifndef SRC_HW_HW_H_
#define SRC_HW_HW_H_

#include "hw_def.h"

#include "iwdg.h"
#include "led.h"
#include "cli.h"
#include "cdc.h"
#include "uart.h"
#include "gpio.h"
#include "beacon.h"
#include "button.h"
#include "dht22.h"


void hwInit(void);

#endif /* SRC_HW_HW_H_ */
