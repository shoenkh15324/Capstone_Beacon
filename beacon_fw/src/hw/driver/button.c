/*
 * button.c
 *
 *  Created on: Apr 16, 2024
 *      Author: mok07
 */


#include "button.h"
#include "cli.h"


typedef struct
{
  GPIO_TypeDef *port;
  uint32_t      pin;
  GPIO_PinState on_state;
} button_tbl_t;


button_tbl_t button_tbl[BUTTON_MAX_CH] =
    {
        {GPIOB, GPIO_PIN_13, GPIO_PIN_RESET},
    };

bool toggleFlag[BUTTON_MAX_CH] = {0, };
bool toggleStatus[BUTTON_MAX_CH] = {0, };


#ifdef _USE_HW_CLI
static void cliButton(cli_args_t *args);
#endif


bool buttonInit(void)
{
  bool ret = true;

  GPIO_InitTypeDef GPIO_InitStruct = {0};


  __HAL_RCC_GPIOA_CLK_ENABLE();


  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLUP;

  for (int i=0; i<BUTTON_MAX_CH; i++)
  {
    GPIO_InitStruct.Pin = button_tbl[i].pin;
    HAL_GPIO_Init(button_tbl[i].port, &GPIO_InitStruct);
  }

#ifdef _USE_HW_CLI
  cliAdd("button", cliButton);
#endif

  return ret;
}

bool buttonGetPressed(uint8_t ch)
{
  bool ret = false;

  if (ch >= BUTTON_MAX_CH)
  {
    return false;
  }

  if (HAL_GPIO_ReadPin(button_tbl[ch].port, button_tbl[ch].pin) == button_tbl[ch].on_state)
  {
    ret = true;
  }

  return ret;
}

bool buttonToggle(uint8_t ch)
{
  // 해당 채널에 연결된 버튼의 상태를 읽어옵니다.
  bool pin_state = buttonGetPressed(ch);

  // 버튼이 눌려있는 경우
  if(pin_state == 0)
  {
    // 이전에 버튼이 눌려진 적이 없는 경우
    if(toggleFlag[ch] == false)
    {
      // 토글 플래그를 true로 설정합니다.
      toggleFlag[ch] = true;
    }
  }
  // 버튼이 떨어져 있는 경우
  else
  {
    // 이전에 버튼이 눌려진 적이 있는 경우
    if(toggleFlag[ch] == true)
    {
      // 이전에 토글된 상태가 true인 경우
      if(toggleStatus[ch] == true)
      {
        // 토글 상태를 false로 변경합니다.
        toggleStatus[ch] = false;
      }
      // 이전에 토글된 상태가 false인 경우
      else
      {
        // 토글 상태를 true로 변경합니다.
        toggleStatus[ch] = true;
      }
      // 토글 플래그를 다시 true로 설정합니다.
      toggleFlag[ch] = true;
    }
  }

  // 해당 채널의 현재 토글 상태를 반환합니다.
  return toggleStatus[ch];
}


#ifdef _USE_HW_CLI

void cliButton(cli_args_t *args)
{
  bool ret = false;


  if (args->argc == 1 && args->isStr(0, "show"))
  {
    while(cliKeepLoop())
    {
      for (int i=0; i<BUTTON_MAX_CH; i++)
      {
        cliPrintf("%d %d", buttonGetPressed(i), buttonToggle(i));
      }
      cliPrintf("\n");

      delay(100);
    }

    ret = true;
  }


  if (ret != true)
  {
    cliPrintf("button show\n");
  }
}

#endif
