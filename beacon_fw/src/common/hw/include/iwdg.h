/*
 * iwdg.h
 *
 *  Created on: Apr 21, 2024
 *      Author: mok07
 */

#ifndef SRC_COMMON_HW_INCLUDE_IWDG_H_
#define SRC_COMMON_HW_INCLUDE_IWDG_H_

#include "hw_def.h"

#ifdef _USE_HW_IWDG

bool iwdgInit(void);
bool iwdgBegin(uint32_t time_ms);
bool iwdgRefresh(void);

#endif

#endif /* SRC_COMMON_HW_INCLUDE_IWDG_H_ */
