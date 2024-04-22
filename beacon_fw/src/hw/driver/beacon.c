/*
 * beacon.c
 *
 *  Created on: Apr 8, 2024
 *      Author: mok07
 */


#include "beacon.h"
#include "uart.h"
#include "cli.h"
#include "button.h"


#ifdef _USE_HW_BEACON


typedef struct
{
  uint8_t floor;          // 비콘의 층을 나타내는 변수
  uint8_t x;              // 비콘의 x 좌표를 나타내는 변수
  uint8_t y;              // 비콘의 y 좌표를 나타내는 변수
  uint8_t z;              // 비콘의 z 좌표를 나타내는 변수

  uint32_t beacon_id;     // 비콘의 고유 ID를 나타내는 변수
  uint8_t ch;             // 비콘의 통신 채널을 나타내는 변수
  uint32_t baud;          // 비콘의 통신 속도를 나타내는 변수
  bool beacon_started;    // 비콘의 통신이 시작되었는지 여부를 나타내는 변수
  bool ch_open;           // 채널이 열려 있는지 여부를 나타내는 변수

} beacon_t;

beacon_t beacon_tbl;      // 비콘 정보를 담는 구조체 변수

#ifdef _USE_HW_CLI
static void cliBeacon(cli_args_t *args);
#endif

/**
 * @brief 비콘 초기화 함수
 *
 * @return 초기화 성공 여부를 반환하는 변수
 *         - true: 초기화 성공
 *         - false: 초기화 실패
 */
bool beaconInit()
{
  bool ret = true;  // 반환 값 변수, 초기값은 성공(true)

  // 비콘의 위치 및 기본 설정 초기화
  beacon_tbl.floor = 0;                 // 층 초기화
  beacon_tbl.x = 0;                     // x 좌표 초기화
  beacon_tbl.y = 0;                     // y 좌표 초기화
  beacon_tbl.z = 0;                     // z 좌표 초기화
  beacon_tbl.ch = _DEF_UART3;           // 통신 채널 초기화
  beacon_tbl.baud = 9600;               // 통신 속도 초기화
  beacon_tbl.beacon_started = false;    // 비콘 시작 여부 초기화
  beacon_tbl.ch_open = false;           // 통신 채널 개방 여부 초기화
  beacon_tbl.beacon_id = 0;             // 비콘 ID 초기화

#ifdef _USE_HW_UART
  // UART 사용 시 해당 채널을 열고 결과를 ch_open에 저장
  beacon_tbl.ch_open = uartOpen(beacon_tbl.ch, beacon_tbl.baud);
#endif

#ifdef _USE_HW_CLI
  // CLI 사용 시 beacon 명령어 추가
  cliAdd("beacon", cliBeacon);
#endif

  return ret;  // 초기화 성공 여부 반환
}

/**
 * @brief 비콘 시작 여부에 따라 정보를 처리하는 함수
 *
 * 비콘이 시작되었을 때, 해당 비콘의 정보를 UART를 통해 출력합니다.
 *
 */
void handleBeaconStart(void)
{
  if(beacon_tbl.beacon_started)  // 비콘이 시작되었는지 확인
  {
    // UART를 통해 비콘 정보를 출력합니다.
    uartPrintf(beacon_tbl.ch, "%d %d %d %d %d\n", beacon_tbl.beacon_id,
                                                  beacon_tbl.floor,
                                                  beacon_tbl.x,
                                                  beacon_tbl.y,
                                                  beacon_tbl.z
                                                  );
  }
}

/**
 * @brief 비콘 시작 여부를 변경하는 함수
 *
 * @param value 변경할 시작 여부 값을 나타내는 변수
 *              - true: 시작
 *              - false: 중지
 */
void changeBeaconStarted(bool value)
{
  if(value == true)
    beacon_tbl.beacon_started = true;   // 주어진 값이 true일 경우 시작 상태로 설정
  else
    beacon_tbl.beacon_started = false;  // 그렇지 않으면 중지 상태로 설정
}



#ifdef _USE_HW_CLI

/**
 * @brief CLI에서 입력된 명령어를 처리하는 함수
 *
 * @param args CLI 명령어와 인수를 포함하는 구조체
 */
void cliBeacon(cli_args_t *args)
{
  bool ret = false;  // 명령어 처리 결과 변수, 기본적으로 실패로 설정

  // "info" 명령어를 받았을 때 비콘 정보 출력
  if(args->argc == 1 && args->isStr(0, "info") == true)
  {
    uint32_t beacon_id = beacon_tbl.beacon_id;  // 비콘 ID 정보
    uint8_t beacon_floor = beacon_tbl.floor;    // 비콘 층 정보
    uint8_t beacon_x = beacon_tbl.x;            // 비콘 x 좌표 정보
    uint8_t beacon_y = beacon_tbl.y;            // 비콘 y 좌표 정보
    uint8_t beacon_z = beacon_tbl.z;            // 비콘 z 좌표 정보

    // 비콘 정보 출력
    cliPrintf("ID: %d, Floor: %d, [x, y, z]: [%d, %d, %d]\n", beacon_id,
                                                              beacon_floor,
                                                              beacon_x,
                                                              beacon_y,
                                                              beacon_z
                                                              );

    ret = true;  // 처리 성공
  }

  // "start" 명령어를 받았을 때 비콘 시작
  if(args->argc == 1 && args->isStr(0, "start") == true)
  {
    if(beacon_tbl.ch_open == true)  // 통신 채널이 열려 있는지 확인
    {
      cliPrintf("Open Success\n");  // 통신 채널이 열렸으면 성공 메시지 출력

      changeBeaconStarted(true);    // 비콘 시작 상태 변경
    }
    else
    {
      cliPrintf("Open Fail\n");     // 통신 채널이 닫혔으면 실패 메시지 출력
    }

    ret = true;  // 처리 성공
  }

  // "end" 명령어를 받았을 때 비콘 종료
  if(args->argc == 1 && args->isStr(0, "end") == true)
  {
    changeBeaconStarted(false);  // 비콘 종료 상태 변경

    ret = true;  // 처리 성공
  }

  // "set" 명령어를 받았을 때 비콘의 ID, 층 및 좌표 설정
  if(args->argc == 6 && args->isStr(0, "set") == true)
  {
    uint32_t beacon_id = (uint32_t)args->getData(1);  // 매개변수로 받은 비콘 ID 정보
    uint8_t beacon_floor = (uint8_t)args->getData(2); // 매개변수로 받은 비콘 층 정보
    uint8_t beacon_x = (uint8_t)args->getData(3);     // 매개변수로 받은 비콘 x 좌표 정보
    uint8_t beacon_y = (uint8_t)args->getData(4);     // 매개변수로 받은 비콘 y 좌표 정보
    uint8_t beacon_z = (uint8_t)args->getData(5);     // 매개변수로 받은 비콘 z 좌표 정보

    // 비콘의 ID, 층 및 좌표 설정
    beacon_tbl.beacon_id = beacon_id;
    beacon_tbl.floor = beacon_floor;
    beacon_tbl.x = beacon_x;
    beacon_tbl.y = beacon_y;
    beacon_tbl.z = beacon_z;

    ret = true;  // 처리 성공
  }

  // 처리되지 않은 명령어가 있을 경우 사용법 출력
  if(ret != true)
  {
    cliPrintf("beacon info\n");             // 비콘 정보 출력 명령어 사용법
    cliPrintf("beacon set id, floor, x, y, z\n");  // 비콘 설정 명령어 사용법
    cliPrintf("beacon start\n");            // 비콘 시작 명령어 사용법
    cliPrintf("beacon end\n");              // 비콘 종료 명령어 사용법
  }
}

#endif

#endif
