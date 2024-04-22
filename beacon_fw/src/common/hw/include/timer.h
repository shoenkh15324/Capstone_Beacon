/*
 * timer.h
 *
 *  Created on: Apr 20, 2024
 *      Author: mok07
 */

#ifndef SRC_COMMON_HW_INCLUDE_TIMER_H_
#define SRC_COMMON_HW_INCLUDE_TIMER_H_

#include "hw_def.h"


#ifdef _USE_HW_TIMER


#define TIMER_MAX_CH 4 // 타이머 채널 개수 정의


void timerInit(void); // 타이머 초기화 함수 선언
void timerStop(uint8_t channel); // 타이머 중지 함수 선언
void timerSetPeriod(uint8_t channel, uint32_t period_data); // 타이머 주기 설정 함수 선언
void timerAttachInterrupt(uint8_t channel, void (*func)(void)); // 타이머 인터럽트 함수 등록 함수 선언
void timerDetachInterrupt(uint8_t channel); // 타이머 인터럽트 함수 해제 함수 선언
void timerStart(uint8_t channel); // 타이머 시작 함수 선언

#endif

#endif /* SRC_COMMON_HW_INCLUDE_TIMER_H_ */
