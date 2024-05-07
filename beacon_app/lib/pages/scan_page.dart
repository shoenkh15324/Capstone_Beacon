// ignore_for_file: invalid_use_of_protected_member

import 'package:beacon_app/beacon_data/beacon_data.dart';
import 'package:beacon_app/bluetooth_data/ble_data.dart';
import 'package:beacon_app/widgets/bluetooth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';

/* 
  BLE 기기를 스캔해서 스캔 결과를 리스트로 보여주는 페이지
  등록된 기기만 스캔이 가능하다. (등록된 기기는 별도의 리스트에 저장되어 있음)
  스캔된 기기의 여러 정보들(RSSI, MAC, ...)을 볼 수 있다
  세팅 버튼을 통해서 기기의 정보를 수정할 수 있다.
  플로팅 버튼으로 기기를 등록할 수 있다.
 */

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final bleController = Get.put(BLEController());
  final beaconController = Get.put(BeaconData());
  TextEditingController beaconIdController = TextEditingController();
  TextEditingController beaconNicknameController = TextEditingController();

  // 비콘 리스트
  Widget widgetBleList(ScanResult r, int index) {
    final deviceName = BleWidgets().deviceNameCheck(r);
    final deviceRSSI = r.rssi.toString();
    final deviceMAC = r.device.remoteId.str;

    return ExpansionTile(
      title: Text(
        beaconController
            .beaconDataList.value[beaconController.findMACIndex(deviceMAC)][6],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      leading: BleWidgets().bleIcon(),
      subtitle: Text(
        deviceName,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      trailing: Text(
        deviceRSSI,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      children: [
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${beaconController.printBeaconID(deviceMAC)}'),
                  Text('MAC: $deviceMAC'),
                  Text(
                      'Floor: ${beaconController.printBeaconFloor(deviceMAC)}'),
                  Text(
                      'X: ${beaconController.printBeaconXaxis(deviceMAC)}, Y: ${beaconController.printBeaconYaxis(deviceMAC)}, Z: ${beaconController.printBeaconZaxis(deviceMAC)}'),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return beaconSettingDialog(context, deviceMAC);
                  },
                );
              },
              icon: const Icon(Icons.settings),
              iconSize: 40,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    );
  }

  // 비콘 세팅창
  Widget beaconSettingDialog(BuildContext context, String mac) {
    return AlertDialog(
      title: const Text(
        'Beacon Setting',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      actions: [
        TextField(
          controller: beaconNicknameController,
          decoration: const InputDecoration(
            labelText: 'Nickname',
          ),
          onEditingComplete: () {
            beaconController.settingBeaconNickname(
                mac, beaconNicknameController.text);
          },
        ),
        TextField(
          controller: beaconIdController,
          decoration: const InputDecoration(
            labelText: 'ID',
          ),
          onEditingComplete: () {
            beaconController.settingBeaconID(mac, beaconIdController.text);
          },
        ),
        const SizedBox(
          height: 30,
        ),
        SpinBox(
          min: -100,
          max: 100,
          value: BeaconData().beaconDataList[BeaconData().findMACIndex(mac)][1],
          decimals: 0,
          step: 1,
          onChanged: (value) =>
              beaconController.settingBeaconFloor(mac, value.toInt()),
          decoration: const InputDecoration(
            label: Text(
              'Floor',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        SpinBox(
          // x-axis
          min: -100,
          max: 100,
          value: 0,
          decimals: 0,
          step: 1,
          onChanged: (value) =>
              beaconController.settingBeaconXaxis(mac, value.toInt()),
          decoration: const InputDecoration(
            label: Text(
              'X-axis',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        SpinBox(
          // y-axis
          min: -100,
          max: 100,
          value: 0,
          decimals: 0,
          step: 1,
          onChanged: (value) =>
              beaconController.settingBeaconYaxis(mac, value.toInt()),
          decoration: const InputDecoration(
            label: Text(
              'Y-axis',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        SpinBox(
          // z-axis
          min: -100,
          max: 100,
          value: 0,
          decimals: 0,
          step: 1,
          onChanged: (value) =>
              beaconController.settingBeaconZaxis(mac, value.toInt()),
          decoration: const InputDecoration(
            label: Text(
              'Z-axis',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => ListView.separated(
            itemBuilder: (context, index) =>
                widgetBleList(bleController.scanResultList[index], index),
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemCount: bleController.scanResultList.length,
          ),
        ),
      ),
    );
  }
}
