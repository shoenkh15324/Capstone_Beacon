import 'dart:async';

import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

/* 
  beacon_data.dart 파일을 get 라이브러리를 사용해서 접근하면 안됨
  (final beaconController = Get.put(BeaconData()) 선언하면 안됨->스택이 재귀함수 꼴로 무한 호출되서 스택 오버플로우가 발생!)
 */

class BleController extends GetxController {
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  // 모든 BLE 기기 스캔 결과
  final scanResultList = RxList<ScanResult>([]);
  final isScanning = RxBool(false);

  /* 스캔할 기기의 MAC 주소 리스트 */
  RxList<String> beaconList = RxList<String>([
    'C8:0F:10:B3:5D:D5',
  ]);

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  void toggleState() async {
    isScanning.value = !isScanning.value;

    if (isScanning.value) {
      updateBeaconList();
      startScan();
    } else {
      stopScan();
    }
    update();
  }

  void startScan() async {
    _scanSubscription = FlutterBluePlus.scanResults.listen((event) {
      scanResultList.value = event;
      scanResultList.sort((a, b) => b.rssi.compareTo(a.rssi));
      update();
    });

    FlutterBluePlus.startScan(
      continuousUpdates: true,
      androidScanMode: AndroidScanMode.lowLatency,
      withRemoteIds: beaconList,
    );
  }

  void stopScan() async {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
  }

  void updateBeaconList() {
    final beaconController = Get.put(BeaconController());
    RxList<String> tempList = RxList<String>([]);
    for(var data in beaconController.beaconDataList) {
      String mac = data[0];
      tempList.add(mac);
    }
    beaconList = tempList;
  }
}
