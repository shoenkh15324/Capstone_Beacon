/*
 * dht22.h
 *
 *  Created on: Apr 18, 2024
 *      Author: mok07
 */

#ifndef SRC_COMMON_HW_INCLUDE_DHT22_H_
#define SRC_COMMON_HW_INCLUDE_DHT22_H_

#include "hw_def.h"

#ifdef _USE_HW_DHT22


//Pin Mode enum
typedef enum
{
  ONE_OUTPUT = 0,
  ONE_INPUT,
} OnePinMode_Typedef;

//*** Functions prototypes ***//

//OneWire Initialise
bool dht22Init(GPIO_TypeDef* DataPort, uint16_t DataPin);

//Change pin mode
void ONE_WIRE_PinMode(OnePinMode_Typedef mode);

//One Wire pin HIGH/LOW Write
void ONE_WIRE_Pin_Write(bool state);
bool ONE_WIRE_Pin_Read(void);

//Begin function
void DHT22_StartAcquisition(void);

//Read 5 bytes
void DHT22_ReadRaw(uint8_t *data);

//Get Temperature and Humidity data
bool DHT22_GetTemp_Humidity();

#endif

#endif /* SRC_COMMON_HW_INCLUDE_DHT22_H_ */
