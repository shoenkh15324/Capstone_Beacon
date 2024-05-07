// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';

class BeaconData extends GetxController{
  /* 스캔할 비콘의 MAC 주소 리스트 */
  List<String> beaconList = [
    'C8:0F:10:B3:5D:D5',
  ];

  /* 등록된 비콘 정보 리스트 */
  final RxList<List<dynamic>> beaconDataList = RxList<List<dynamic>>([
    //       MAC           ID   F  X  Y  Z   Nickname
    ['C8:0F:10:B3:5D:D5', 'ID', 0, 0, 0, 0, 'Nickname'],
  ]);

  // beaconDataList에 찾으려는 mac주소가 있는지 확인하는 함수
  bool isMacAddressExist(String mac) {
    for (var item in beaconDataList.value) {
      if (item.contains(mac)) {
        return true;
      }
    }
    return false;
  }

  // beaconDataList에 찾으려는 mac주소의 인덱스를 확인하는 함수
  int findMACIndex(String mac) {
    for (int i = 0; i < beaconDataList.value.length; i++) {
      if (beaconDataList.value[i].isNotEmpty &&
          beaconDataList.value[i][0] == mac) {
        return i;
      }
    }
    return -1;
  }

  void addNewListTobeaconDataList(List<dynamic> newList) {
    beaconDataList.add(newList);
    print(beaconDataList.value);
  }

  /* 비콘 정보 출력 및 세팅 함수들 */

  // Beacon Nickname 정보
  void settingBeaconNickname(String mac, String nickname) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][6] = nickname;
  }

  // Beacon ID 정보
  String printBeaconID(String mac) {
    int index = findMACIndex(mac);
    String beaconID = (index == -1) ? beaconDataList.value[index][1] : 'N/A';
    return beaconID;
  }

  void settingBeaconID(String mac, String id) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][1] = id;
  }

  // Beacon 층(Floor) 정보
  String printBeaconFloor(String mac) {
    int index = findMACIndex(mac);
    int floor = (index == -1) ? beaconDataList.value[index][2] : '0';
    return floor.toString();
  }

  void settingBeaconFloor(String mac, int floor) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][2] = floor;
  }

  // Beacon X좌표 정보
  String printBeaconXaxis(String mac) {
    int index = findMACIndex(mac);
    int x = (index == -1) ? beaconDataList.value[index][3] : '0';
    return x.toString();
  }

  void settingBeaconXaxis(String mac, int x) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][3] = x;
  }

  // Beacon Y좌표 정보
  String printBeaconYaxis(String mac) {
    int index = findMACIndex(mac);
    int x = (index == -1) ? beaconDataList.value[index][4] : '0';
    return x.toString();
  }

  void settingBeaconYaxis(String mac, int y) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][4] = y;
  }

  // Beacon Z좌표 정보
  String printBeaconZaxis(String mac) {
    int index = findMACIndex(mac);
    int x = (index == -1) ? beaconDataList.value[index][5] : '0';
    return x.toString();
  }

  void settingBeaconZaxis(String mac, int z) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][5] = z;
  }
}
