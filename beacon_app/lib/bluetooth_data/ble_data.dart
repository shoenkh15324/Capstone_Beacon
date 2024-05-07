import 'dart:async';

import 'package:beacon_app/beacon_data/beacon_data.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';


/* 
  beacon_dat.dart 파일을 get 라이브러리를 사용해서 접근하면 안됨
  (final beaconController = Get.put(BeaconData()) 선언하면 안됨->스택이 재귀함수 꼴로 무한 호출되서 스택 오버플로우가 발생!)
 */


class BLEController extends GetxController {
  StreamSubscription<List<ScanResult>>? _scanSubscription;


  final scanResultList = RxList<ScanResult>([]);
  final isScanning = RxBool(false);


  // List<List<dynamic>> scanedBleList = [];

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  void toggleState() {
    isScanning.value = !isScanning.value;

    if (isScanning.value) {
      startScan();
    } else {
      stopScan();
    }

    update();
  }

  void startScan() {
    _scanSubscription = FlutterBluePlus.scanResults.listen((event) {
      scanResultList.value = event;
      scanResultList.sort((a, b) => b.rssi.compareTo(a.rssi));

      update();
    });

    FlutterBluePlus.startScan(
      continuousUpdates: true,
      androidScanMode: AndroidScanMode.lowLatency,
      withRemoteIds: BeaconData().beaconList,
    );
  }

  void stopScan() {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
  }

  // Set<String> uniqueMacs = {};
  // void converttoBeaconList(
  //     List<ScanResult> scanResults, List<List<dynamic>> beaconList) {
  //   List<List<dynamic>> newBeaconLists = [];

  //   for (var result in scanResults) {
  //     String macAddress = result.device.remoteId.toString();
  //     if (!uniqueMacs.contains(macAddress)) {
  //       List<dynamic> customList = [macAddress, 'ID', 0, 0, 0, 0];
  //       newBeaconLists.add(customList);
  //       uniqueMacs.add(macAddress);
  //     }
  //   }
  //   beaconList.addAll(newBeaconLists);
  // }
}
