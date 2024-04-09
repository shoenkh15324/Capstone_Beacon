/*
 * beacon.h
 *
 *  Created on: Apr 8, 2024
 *      Author: mok07
 */

#ifndef SRC_COMMON_HW_INCLUDE_BEACON_H_
#define SRC_COMMON_HW_INCLUDE_BEACON_H_

#include "hw_def.h"


bool beaconInit(void);
void beaconStart(uint8_t ch, uint32_t baud);


#endif /* SRC_COMMON_HW_INCLUDE_BEACON_H_ */
