// ignore_for_file: invalid_use_of_protected_member

import 'package:beacon_app/data_folder/database_control.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class BeaconController extends GetxController {
  /* 등록된 비콘 정보 리스트 */
  RxList<List<dynamic>> beaconDataList = RxList<List<dynamic>>([
    //       MAC           ID   F  X  Y  Z   Nickname
    ['C8:0F:10:B3:5D:D5', 'ID', 0, 0, 0, 0, 'Nickname'],
  ]);

  BeaconController() {
    beaconDataList.listen((_) {
      beaconDataListUpdated();
    });
  }

  void beaconDataListUpdated(){
    DatabaseHelper dhHelper = DatabaseHelper.instance;
    // 데이터베이스 클리어
    dhHelper.clearBeaconData();
    // beaconDataList의 각 요소에 대해 데이터베이스에 추가
    beaconDataList.forEach((data) {
      dhHelper.addDataToDatabase(data);
    });
  }

  // 데이터베이스에서 데이터를 불러와서 beaconDataList를 갱신하는 함수
  Future<void> updateBeaconDataListFromDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    // 데이터베이스에서 모든 데이터 가져오기
    List<Map<String, dynamic>> rows = await dbHelper.getAllBeaconData();

    // 데이터베이스에서 가져온 데이터를 beaconDataList에 덮어씌우기
    List<List<dynamic>> updatedList = [];
    for (Map<String, dynamic> row in rows) {
      List<dynamic> rowData = [
        row['mac'],
        row['beaconId'],
        row['floor'],
        row['x'],
        row['y'],
        row['z'],
        row['nickname']
      ];
      updatedList.add(rowData);
    }
    // beaconDataList 갱신
    beaconDataList.assignAll(updatedList);
  }
  
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

  /* 
      비콘 정보 출력 및 세팅 함수들 
  */

  // Beacon Nickname 정보
  String printBeaconNickname(String mac) {
    int index = findMACIndex(mac);
    String nickname = (index == -1) ? 'N/A' : beaconDataList.value[index][6];
    return nickname;
  }

  void settingBeaconNickname(String mac, String nickname) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][6] = nickname;
  }

  // Beacon ID 정보
  String printBeaconID(String mac) {
    int index = findMACIndex(mac);
    String beaconID = (index == -1) ? 'N/A' : beaconDataList.value[index][1];
    return beaconID;
  }

  void settingBeaconID(String mac, String id) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][1] = id;
  }

  // Beacon 층(Floor) 정보
  int printBeaconFloor(String mac) {
    int index = findMACIndex(mac);
    int floor = (index == -1) ? 0 : beaconDataList.value[index][2];
    return floor;
  }

  void settingBeaconFloor(String mac, int floor) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][2] = floor;
  }

  // Beacon X좌표 정보
  int printBeaconXaxis(String mac) {
    int index = findMACIndex(mac);
    int x = (index == -1) ? 0 : beaconDataList.value[index][3];
    return x;
  }

  void settingBeaconXaxis(String mac, int x) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][3] = x;
  }

  // Beacon Y좌표 정보
  int printBeaconYaxis(String mac) {
    int index = findMACIndex(mac);
    int y = (index == -1) ? 0 : beaconDataList.value[index][4];
    return y;
  }

  void settingBeaconYaxis(String mac, int y) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][4] = y;
  }

  // Beacon Z좌표 정보
  int printBeaconZaxis(String mac) {
    int index = findMACIndex(mac);
    int z = (index == -1) ? 0 : beaconDataList.value[index][5];
    return z;
  }

  void settingBeaconZaxis(String mac, int z) {
    int index = findMACIndex(mac);
    beaconDataList.value[index][5] = z;
  }
}
