// ignore_for_file: invalid_use_of_protected_member

import 'package:beacon_app/data_folder/ble_data.dart';
import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:beacon_app/data_folder/database_control.dart';
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
  final bleController = Get.put(BleController());
  final beaconController = Get.put(BeaconController());

  TextEditingController beaconIdController = TextEditingController();
  TextEditingController beaconNicknameController = TextEditingController();

  String tempNickname = 'Nickname', tempID = 'ID';
  int tempFloor = 0, tempX = 0, tempY = 0, tempZ = 0;

  @override
  void dispose() {
    beaconNicknameController.dispose();
    beaconIdController.dispose();
    super.dispose();
  }

  void settingButtonPressed(BuildContext context, String mac) {
    DatabaseHelper dhHelper = DatabaseHelper.instance;

    int index = beaconController.findMACIndex(mac);
    if (index != -1) {
      var temp = beaconController.beaconDataList.value[index];
      temp[1] = tempID;
      temp[2] = tempFloor;
      temp[3] = tempX;
      temp[4] = tempY;
      temp[5] = tempZ;
      temp[6] = tempNickname;

      // Update Database
      beaconController.beaconDataListUpdated();
    }

    Navigator.pop(context);
  }

  // 비콘 리스트
  Widget widgetBleList(ScanResult r, int index) {
    final deviceName = BleWidgets().deviceNameCheck(r);
    final deviceRSSI = r.rssi.toString();
    final deviceMAC = r.device.remoteId.str;

    return ExpansionTile(
      title: Text(
        beaconController.printBeaconNickname(deviceMAC),
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
                    return SingleChildScrollView(
                        child: beaconSettingDialog(context, deviceMAC));
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
          onChanged: (value) {
            tempNickname = beaconNicknameController.text;
          },
          decoration: InputDecoration(
              labelText: 'Nickname',
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        TextField(
          controller: beaconIdController,
          onChanged: (value) {
            tempID = beaconIdController.text;
          },
          decoration: const InputDecoration(
              labelText: 'ID',
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(
          height: 30,
        ),
        SpinBox(
          min: -100,
          max: 100,
          value: beaconController.printBeaconFloor(mac).toDouble(),
          decimals: 0,
          step: 1,
          onChanged: (value) {
            tempFloor = value.toInt();
          },
          decoration: const InputDecoration(
            label: Text(
              'Floor',
              style: TextStyle(
                fontSize: 18,
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
          value: beaconController.printBeaconXaxis(mac).toDouble(),
          decimals: 0,
          step: 1,
          onChanged: (value) {
            tempX = value.toInt();
          },
          decoration: const InputDecoration(
            label: Text(
              'X-axis',
              style: TextStyle(
                fontSize: 18,
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
          value: beaconController.printBeaconYaxis(mac).toDouble(),
          decimals: 0,
          step: 1,
          onChanged: (value) {
            tempY = value.toInt();
          },
          decoration: const InputDecoration(
            label: Text(
              'Y-axis',
              style: TextStyle(
                fontSize: 18,
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
          value: beaconController.printBeaconZaxis(mac).toDouble(),
          decimals: 0,
          step: 1,
          onChanged: (value) {
            tempZ = value.toInt();
          },
          decoration: const InputDecoration(
            label: Text(
              'Z-axis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        TextButton(
          onPressed: () {
            settingButtonPressed(context, mac);
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          child: const Text(
            'Setting',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
