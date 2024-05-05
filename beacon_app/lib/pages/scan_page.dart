import 'package:beacon_app/bluetooth/bluetooth_data.dart';
import 'package:beacon_app/widgets/bluetooth_wideget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:rolling_switch/rolling_switch.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  var bleController = Get.put(BLEController());

  // // 리스트 아이템을 빌드하는 메서드입니다.
  // Widget listItem(ScanResult r) {
  //   return ListTile(
  //     onTap: () => onTap(r), // 탭 이벤트 핸들러를 설정합니다.
  //     leading: BleWidgets().bleIcon(), // 블루투스 아이콘 위젯입니다.
  //     title: BleWidgets().deviceName(r), // 디바이스 이름 위젯입니다.
  //     subtitle: BleWidgets().deviceMAC(r), // 디바이스 MAC 주소 위젯입니다.
  //     trailing: BleWidgets().deviceRSSI(r), // 디바이스 RSSI 위젯입니다.
  //   );
  // }

  Widget widgetBleList(ScanResult r, int index) {
    var deviceName = BleWidgets().deviceNameCheck(r);
    var deviceRSSI = r.rssi.toString();
    var deviceMAC = r.device.remoteId.str;

    return ExpansionTile(
      title: Text(
        deviceName,
        style: const TextStyle(),
      ),
      subtitle: Text(
        deviceMAC,
        style: const TextStyle(),
      ),
      trailing: Text(
        deviceRSSI,
        style: const TextStyle(),
      ),
      leading: BleWidgets().bleIcon(),
      children: <Widget>[
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RollingSwitch.icon(
                animationDuration: const Duration(milliseconds: 400),
                width: 170,
                onChanged: (bool state) {},
                rollingInfoRight: const RollingIconInfo(
                  icon: Icons.link,
                  iconColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  text: Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                rollingInfoLeft: const RollingIconInfo(
                  icon: Icons.link_off,
                  iconColor: Colors.grey,
                  backgroundColor: Colors.grey,
                  text: Text(
                    'Disconnected',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
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
            separatorBuilder: (context, index) => const Divider(),
            itemCount: bleController.scanResultList.length,
          ),
        ),
      ),
    );
  }
}
