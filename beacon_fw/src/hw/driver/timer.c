/*
 * timer.c
 *
 *  Created on: Apr 20, 2024
 *      Author: mok07
 */


#include "timer.h"


#ifdef _USE_HW_TIMER

// 하드웨어 타이머 채널의 최대 개수 정의
#define HWTIMER_MAX_CH 2

// 하드웨어 타이머 인덱스 정의
#define HWTIMER_TIMER1 0
#define HWTIMER_TIMER2 1
#define HWTIMER_TIMER3 2
#define HWTIMER_TIMER4 3

// 하드웨어 타이머 채널 정의
#define HWTIMER_CH1 0
#define HWTIMER_CH2 1
#define HWTIMER_CH3 2
#define HWTIMER_CH4 3


typedef struct
{
  TIM_HandleTypeDef hTIM;          /**< 타이머 핸들러 */
  TIM_OC_InitTypeDef sConfig[4];   /**< 타이머 채널 구성 */
  uint32_t freq;                   /**< 타이머 주파수 */
  void (*p_func[4])(void);         /**< 타이머 채널 인터럽트 콜백 함수 포인터 배열 */
} hwtimer_t;

typedef struct
{
  uint8_t number;            /**< 타이머 번호 */
  uint8_t index;             /**< 인덱스 */
  uint32_t active_channel;   /**< 활성 채널 */
} hwtimer_index_t;

static hwtimer_index_t hwtimer_index[TIMER_MAX_CH] = {
  { HWTIMER_TIMER1, HWTIMER_CH1, HAL_TIM_ACTIVE_CHANNEL_1}, // _DEF_TIMER1
  { HWTIMER_TIMER1, HWTIMER_CH2, HAL_TIM_ACTIVE_CHANNEL_2}, // _DEF_TIMER2
  { HWTIMER_TIMER1, HWTIMER_CH3, HAL_TIM_ACTIVE_CHANNEL_3}, // _DEF_TIMER3
  { HWTIMER_TIMER1, HWTIMER_CH4, HAL_TIM_ACTIVE_CHANNEL_4}, // _DEF_TIEMR4
};


static hwtimer_t timer_tbl[HWTIMER_MAX_CH];

void timerInit(void)
{
  // 타이머1 설정
  timer_tbl[HWTIMER_TIMER1].freq = 1000; // 타이머 주파수 설정 (1KHz)
  timer_tbl[HWTIMER_TIMER1].hTIM.Instance = TIM4; // 타이머 인스턴스 설정 (TIM4)
  timer_tbl[HWTIMER_TIMER1].hTIM.Init.Prescaler = (uint32_t)((SystemCoreClock / 1) / timer_tbl[HWTIMER_TIMER1].freq ) - 1; // 1Khz // 프리스케일러 설정
  timer_tbl[HWTIMER_TIMER1].hTIM.Init.ClockDivision = 0; // 클럭 분할 설정
  timer_tbl[HWTIMER_TIMER1].hTIM.Init.CounterMode = TIM_COUNTERMODE_UP; // 카운터 모드 설정
  timer_tbl[HWTIMER_TIMER1].hTIM.Init.RepetitionCounter = 0; // 반복 카운터 설정
  // 타이머 인터럽트 콜백 함수 초기화
  timer_tbl[HWTIMER_TIMER1].p_func[0] = NULL;
  timer_tbl[HWTIMER_TIMER1].p_func[1] = NULL;
  timer_tbl[HWTIMER_TIMER1].p_func[2] = NULL;
  timer_tbl[HWTIMER_TIMER1].p_func[3] = NULL;
}

void timerStop(uint8_t channel)
{
  hwtimer_t *p_timer;

  // 유효하지 않은 채널이면 함수를 종료합니다.
  if (channel >= TIMER_MAX_CH)
    return;

  // 타이머 구조체를 가져옵니다.
  p_timer = &timer_tbl[hwtimer_index[channel].number];

  // 타이머를 비활성화합니다.
  HAL_TIM_Base_DeInit(&p_timer->hTIM);
}

void timerSetPeriod(uint8_t channel, uint32_t period_data)
{
  hwtimer_t *p_timer;
  uint32_t period;

  // 유효하지 않은 채널이면 함수를 종료합니다.
  if (channel >= TIMER_MAX_CH)
    return;

  // 타이머 구조체를 가져옵니다.
  p_timer = &timer_tbl[hwtimer_index[channel].number];

  // 타이머 주파수가 1KHz인 경우
  if (p_timer->freq == 1000)
  {
    period = (period_data * 1000) / 100; // 주기 데이터를 주파수에 맞게 변환

    // 주기가 0인 경우 1로 설정합니다.
    if (period == 0)
    {
      period = 1;
    }
  }

  // 타이머의 주기를 설정합니다.
  p_timer->hTIM.Init.Period = period - 1;
}

void timerAttachInterrupt(uint8_t channel, void (*func)(void))
{
  hwtimer_t *p_timer;

  // 유효하지 않은 채널이면 함수를 종료합니다.
  if (channel >= TIMER_MAX_CH)
    return;

  // 타이머 구조체를 가져옵니다.
  p_timer = &timer_tbl[hwtimer_index[channel].number];

  // 타이머를 중지합니다.
  timerStop(channel);

  // 콜백 함수를 등록합니다.
  p_timer->p_func[hwtimer_index[channel].index] = func;
}

void timerDetachInterrupt(uint8_t channel)
{
  hwtimer_t *p_timer;

  // 유효하지 않은 채널이면 함수를 종료합니다.
  if (channel >= TIMER_MAX_CH)
    return;

  // 타이머 구조체를 가져옵니다.
  p_timer = &timer_tbl[hwtimer_index[channel].number];

  // 타이머를 중지합니다.
  timerStop(channel);

  // 콜백 함수를 NULL로 설정하여 해제합니다.
  p_timer->p_func[hwtimer_index[channel].index] = NULL;
}

void timerStart(uint8_t channel)
{
  hwtimer_t *p_timer;
  uint32_t timer_sub_ch = 0;

  // 유효하지 않은 채널이면 함수를 종료합니다.
  if (channel >= TIMER_MAX_CH)
    return;

  // 타이머 구조체를 가져옵니다.
  p_timer = &timer_tbl[hwtimer_index[channel].number];

  // 타이머 채널에 따라 타이머 서브 채널을 설정합니다.
  switch (hwtimer_index[channel].index)
  {
    case HWTIMER_CH1:
      timer_sub_ch = TIM_CHANNEL_1;
      break;
    case HWTIMER_CH2:
      timer_sub_ch = TIM_CHANNEL_2;
      break;
    case HWTIMER_CH3:
      timer_sub_ch = TIM_CHANNEL_3;
      break;
    case HWTIMER_CH4:
      timer_sub_ch = TIM_CHANNEL_4;
      break;
  }

  // 타이머를 초기화합니다.
  HAL_TIM_OC_Init(&p_timer->hTIM);

  // 타이머 채널에 대한 설정을 적용합니다.
  HAL_TIM_OC_ConfigChannel(&p_timer->hTIM, &p_timer->sConfig[hwtimer_index[channel].index], timer_sub_ch);

  // 타이머 인터럽트를 활성화하고 타이머를 시작합니다.
  HAL_TIM_OC_Start_IT(&p_timer->hTIM, timer_sub_ch);
}

void timerCallback(TIM_HandleTypeDef *htim)
{
  uint8_t i;
  uint32_t index;
  hwtimer_t *p_timer;

  // 모든 타이머 채널에 대해 반복합니다.
  for (i = 0; i < TIMER_MAX_CH; i++)
  {
    // 타이머 구조체를 가져옵니다.
    p_timer = &timer_tbl[hwtimer_index[i].number];
    // 인덱스를 가져옵니다.
    index = hwtimer_index[i].index;

    // 활성화된 채널과 현재 타이머 채널이 일치하는지 확인합니다.
    if (htim->Channel == hwtimer_index[i].active_channel)
    {
      // 콜백 함수가 등록되어 있는지 확인하고 있다면 실행합니다.
      if (p_timer->p_func[index] != NULL)
      {
        (*p_timer->p_func[index])(); // 콜백 함수 호출
      }
    }
  }
}

void HAL_TIM_OC_DelayElapsedCallback(TIM_HandleTypeDef *htim)
{
  timerCallback(htim); // 타이머 콜백 함수 호출
}

void TIM4_IRQHandler(void)
{
  // TIM4 핸들러 함수를 호출하여 타이머 인터럽트를 처리합니다.
  HAL_TIM_IRQHandler(&timer_tbl[HWTIMER_TIMER1].hTIM);
}

void HAL_TIM_Base_MspInit(TIM_HandleTypeDef *htim)
{
  // TIM 핸들러의 인스턴스가 TIM4와 일치하는 경우
  if (htim->Instance == timer_tbl[HWTIMER_TIMER1].hTIM.Instance)
  {
    // TIM4 클럭을 활성화합니다.
    __HAL_RCC_TIM4_CLK_ENABLE();

    // TIM4 인터럽트의 우선순위를 설정합니다.
    HAL_NVIC_SetPriority(TIM4_IRQn, 15, 0);
    // TIM4 인터럽트를 활성화합니다.
    HAL_NVIC_EnableIRQ(TIM4_IRQn);
  }
}

void HAL_TIM_Base_MspDeInit(TIM_HandleTypeDef *htim)
{
  // TIM 핸들러의 인스턴스가 TIM4와 일치하는 경우
  if (htim->Instance == timer_tbl[HWTIMER_TIMER1].hTIM.Instance)
  {
    // TIM4 인터럽트를 비활성화합니다.
    HAL_NVIC_DisableIRQ(TIM4_IRQn);
  }
}

void HAL_TIM_OC_MspInit(TIM_HandleTypeDef *htim)
{
  // TIM 핸들러의 인스턴스가 TIM4와 일치하는 경우
  if (htim->Instance == timer_tbl[HWTIMER_TIMER1].hTIM.Instance)
  {
    // TIM4 클럭을 활성화합니다.
    __HAL_RCC_TIM4_CLK_ENABLE();

    // TIM4 인터럽트의 우선순위를 설정합니다.
    HAL_NVIC_SetPriority(TIM4_IRQn, 15, 0);
    // TIM4 인터럽트를 활성화합니다.
    HAL_NVIC_EnableIRQ(TIM4_IRQn);
  }
}

#endif
