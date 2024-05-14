// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

/*
  BLE 기능 관련 코드
    BLE(Bluetooth Low Energy) 기기를 스캔하고 관리하는데 사용되는 여러 클래스와 기능을 포함.
    BLE 장치를 효율적으로 관리하고, 사용자 인터페이스를 통해 스캔된 장치 및 비콘을 관리할 수 있도록 한다.

    1. HomeScreen 클래스: 
      애플리케이션의 홈 화면을 정의합니다. 이 화면은 BLE 스캔을 시작하고 정지하고, 스캔된 장치 목록을       표시하고, 비콘을 추가하는 등의 작업을 수행할 수 있습니다.

    2. ScanPage 클래스: 
      BLE 장치를 스캔하고 그 결과를 표시하는 화면입니다. 각 장치에 대한 세부 정보를 보여주며, 설정 및 삭제 기능을 제공합니다.

    3. BleController 클래스: 
      BLE 스캔 및 관련 데이터 처리를 담당하는 GetX 컨트롤러입니다. 장치 스캔을 시작하고 중지하며, 스캔된 장치의 RSSI 값과 플랫폼 이름을 업데이트합니다.

    4. BeaconController 클래스: 
      비콘 데이터를 관리하는 GetX 컨트롤러입니다. 비콘을 추가하고 편집하며, 데이터베이스에서 비콘 정보를 읽고 쓰는 작업을 수행합니다.

    5. DatabaseHelper 클래스: 
      SQLite 데이터베이스를 사용하여 비콘 데이터를 영구 저장하는데 사용됩니다.
*/

/* 
    *** 주의! ***
      BleController 클래스에 'final beaconController = Get.put(BeaconData())'를 선언하면 안됨
        -> GetX 컨트롤러가 변경사항을 재귀함수 꼴로 무한 호출해서 스택 오버플로우가 발생!
        -> 함수에 local하게 선언하는 것은 가능.
 */

// GetX 라이브러리를 통해 BLE 기능을 관리하는 클래스
class BleController extends GetxController {
  // BLE 스캔 결과를 구독하는 Subscription
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  // BLE 기기 스캔 결과
  final scanResultList = RxList<ScanResult>([]);

  BleController() {
    rssiList.listen((_) {
      print(rssiList);
    });
  }

  // 스캔 상태 플래그
  final isScanning = RxBool(false);

  // RSSI 값 목록
  final rssiList = RxList<Map<String, dynamic>>([]);

  // 기기명 목록
  final platformNameList = RxList<Map<String, String>>([]);

  /* 스캔할 기기의 MAC 주소 리스트 */
  RxList<String> beaconList = RxList<String>([
    'C8:0F:10:B3:5D:D5', // TEST1
    '54:44:A3:EB:E7:E1', // TEST2
    '68:27:37:AE:EF:19', // TEST3
    'C4:F3:12:51:AE:21', // BEACON1
    'BC:6A:29:C3:44:E2', // BEACON2
    '34:15:13:88:8A:60', // BEACON3
    'D4:36:39:6F:BA:D5', // BEACON4
    'F8:30:02:4A:E4:5F', // BEACON5
  ]);

  // 사용이 끝난 리소스 해제
  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  // BLE 스캔 상태를 전환하는 함수
  void toggleState() async {
    // 스캔 상태 전환
    isScanning.value = !isScanning.value;

    if (isScanning.value) {
      updateBeaconList(); // beaconList 업데이트
      startScan(); // 스캔 시작
    } else {
      stopScan(); // 스캔 중단
    }
  }

  // BLE 장치 스캔을 시작하는 함수
  Future<void> startScan() async {
    _scanSubscription = FlutterBluePlus.scanResults.listen((event) {
      updateLists(event); // 스캔 결과를 여러 리스트에 업데이트
      scanResultList.sort((a, b) => b.rssi.compareTo(a.rssi)); // RSSI에 따라 정렬
    });

    // 초기 스캔 시작
    await _scanForDevices();

    // isScanning 값이 true인 동안 반복해서 스캔
    while (isScanning.value) {
      await Future.delayed(const Duration(seconds: 4)); // 4초 대기
      if (isScanning.value) {
        await _scanForDevices(); // 장치 스캔
      }
    }
  }

  // BLE 장치를 스캔하는 함수
  Future<void> _scanForDevices() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4), // 타임아웃(스캔 시간)
      continuousUpdates: true, // 실시간 업데이트
      androidScanMode: AndroidScanMode.balanced, // 스캔 모드 설정
      withRemoteIds: beaconList, // beaconList에 있는 MAC주소만 스캔
    );
  }

  // BLE 스캔을 중지하는 함수
  void stopScan() async {
    _scanSubscription?.cancel(); // 구독 해제
    FlutterBluePlus.stopScan(); // 스캔 중지
  }

  // 스캔 결과를 업데이트하는 함수
  Future<void> updateLists(List<ScanResult> results) async {
    for (var result in results) {
      final macAddress = result.device.remoteId.toString();
      final rssi = result.rssi;
      final platformName = result.device.platformName;

      // RSSI 업데이트
      updateListEntry(
          rssiList, macAddress, {"macAddress": macAddress, "rssi": rssi});

      // Platform 이름 업데이트
      updateListEntry(platformNameList, macAddress,
          {"macAddress": macAddress, "platformName": platformName});
    }

    rssiList.sort((a, b) => b['rssi'].compareTo(a['rssi']));
  }

  // 리스트 업데이트를 처리하는 보조 메서드
  void updateListEntry(RxList<Map<String, dynamic>> list, String macAddress,
      Map<String, dynamic> newValue) {
    final index = list.indexWhere((item) => item["macAddress"] == macAddress);
    if (index != -1) {
      list[index] = newValue;
    } else {
      list.add(newValue);
    }
  }

  // beaconList를 업데이트하는 함수
  void updateBeaconList() {
    final beaconController = Get.put(BeaconController());
    RxList<String> tempList = RxList<String>([]);
    for (var data in beaconController.beaconDataList) {
      String mac = data[0];
      tempList.add(mac);
    }
    beaconList = tempList;
  }

  // MAC 주소에 해당하는 RSSI 값을 가져오는 함수
  dynamic getRssi(String mac) {
    for (var item in rssiList.value) {
      if (item['macAddress'] == mac) {
        return item['rssi'].toString();
      }
    }
    return '0';
  }

  // MAC 주소에 해당하는 기기 이름을 가져오는 함수
  String getPlatformName(String mac) {
    for (var item in platformNameList.value) {
      if (item['macAddress'] == mac) {
        return item['platformName'].toString();
      }
    }
    return "Unknown";
  }
}
