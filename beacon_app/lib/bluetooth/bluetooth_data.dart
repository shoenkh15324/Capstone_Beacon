import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BLEController extends GetxController {
  // Raw BLE data
  var scanResultList = RxList<ScanResult>([]);
  var isScanning = RxBool(false);

  List<bool> beaconFlag = [];
  List<bool> deviceNameList = [];
  List<bool> macAddressList = [];
  List<bool> rssiList = [];

  // 스캔 시작/중지 토글 기능입니다.
  void toggleState() {
    isScanning.value = !isScanning.value;

    if (isScanning.value) {
      //scanResultList.clear();
      FlutterBluePlus.startScan(
        continuousUpdates: true,
        // androidUsesFineLocation: true,
        androidScanMode: AndroidScanMode.lowLatency,
      );
      bleScan();
    } else {
      FlutterBluePlus.stopScan();
    }

    update();
  }

  // 블루투스 스캔을 수행하는 메서드입니다.
  void bleScan() async {
    if (isScanning.value) {
      FlutterBluePlus.scanResults.listen((event) {
        scanResultList.value = event;
        update();
      });
    }
  }
}
