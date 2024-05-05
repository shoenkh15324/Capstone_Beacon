// 필요한 Flutter와 flutter_blue_plus 패키지를 가져옵니다.
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleWidgets {
  Widget deviceRSSI(ScanResult r) {
    return Text(
      r.rssi.toString(),
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }

  // deviceMAC는 Bluetooth 기기의 MAC 주소를 표시합니다.
  // ScanResult 객체를 인자로 받아, 기기의 remoteId를 Text 위젯으로 반환합니다.
  Widget deviceMAC(ScanResult r) {
    return Text(r.device.remoteId.str); // 기기의 remoteId를 문자열로 변환하여 표시합니다.
  }

  /* device name check */
  String deviceNameCheck(ScanResult r) {
    String name;

    if (r.device.advName.isNotEmpty) {
      // Is device.name
      name = r.device.advName;
    } else if (r.advertisementData.advName.isNotEmpty) {
      // Is advertisementData.localName
      name = r.advertisementData.advName;
    } else {
      // null
      name = 'N/A';
    }
    return name;
  }

  // bleIcon은 Bluetooth 기기를 나타내는 아이콘을 표시합니다.
  Widget bleIcon() {
    return const CircleAvatar(
      backgroundColor: Colors.cyan, // 아이콘 배경색을 설정합니다.
      child: Icon(
        Icons.bluetooth, // Bluetooth 아이콘을 설정합니다.
        color: Colors.white, // 아이콘 색상을 설정합니다.
      ),
    );
  }
}
