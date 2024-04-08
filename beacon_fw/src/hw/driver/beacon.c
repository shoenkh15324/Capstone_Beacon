/*
 * beacon.c
 *
 *  Created on: Apr 8, 2024
 *      Author: mok07
 */


#include "beacon.h"
#include "uart.h"
#include "cli.h"


typedef struct
{
  uint8_t floor;
  uint8_t x;
  uint8_t y;

} beacon_t;

beacon_t beacon_tbl;

#ifdef _USE_HW_CLI
static void cliBeacon(cli_args_t *args);
#endif


bool beaconInit()
{
  bool ret = true;

  beacon_tbl.floor = 0;
  beacon_tbl.x = 0;
  beacon_tbl.y = 0;

#ifdef _USE_HW_CLI
  cliAdd("beacon", cliBeacon);
#endif

  return ret;
}


#ifdef _USE_HW_CLI

void cliBeacon(cli_args_t *args)
{
  bool ret = false;

  if(args->argc == 1 && args->isStr(0, "info") == true)
  {
    uint8_t beacon_floor = beacon_tbl.floor;
    uint8_t beacon_x = beacon_tbl.x;
    uint8_t beacon_y = beacon_tbl.y;

    cliPrintf("Floor: %d, [x, y]: [%d, %d]\n", beacon_floor, beacon_x, beacon_y);

    ret = true;
  }

  if(args->argc == 4 && args->isStr(0, "set") == true)
  {
    uint8_t beacon_floor = (uint8_t)args->getData(1);
    uint8_t beacon_x = (uint8_t)args->getData(2);
    uint8_t beacon_y = (uint8_t)args->getData(3);

    beacon_tbl.floor = beacon_floor;
    beacon_tbl.x = beacon_x;
    beacon_tbl.y = beacon_y;

    ret = true;
  }

  if(ret != true)
  {
    cliPrintf("beacon info\n");
    cliPrintf("beacon set floor x_axis y_axis\n");
  }
}

#endif
