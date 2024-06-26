/*
 * hw_def.h
 *
 *  Created on: Apr 6, 2024
 *      Author: mok07
 */

#ifndef SRC_HW_HW_DEF_H_
#define SRC_HW_HW_DEF_H_

#include "def.h"
#include "bsp.h"


#define _USE_HW_CDC
#define _USE_HW_BEACON
#define _USE_HW_DHT22
#define _USE_HW_IWDG

#define _USE_HW_LED
#define      HW_LED_MAX_CH          1

#define _USE_HW_UART
#define      HW_UART_MAX_CH         2

#define _USE_HW_GPIO
#define      HW_GPIO_MAX_CH         1

#define _USE_HW_BUTTON
#define      HW_BUTTON_MAX_CH       1


#define _USE_HW_CLI
#define      HW_CLI_CMD_LIST_MAX    16
#define      HW_CLI_CMD_NAME_MAX    16
#define      HW_CLI_LINE_HIS_MAX    6
#define      HW_CLI_LINE_BUF_MAX    64


#endif /* SRC_HW_HW_DEF_H_ */
