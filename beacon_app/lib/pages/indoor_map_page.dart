import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:beacon_app/data_folder/ble_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndoorMapPage extends StatefulWidget {
  const IndoorMapPage({super.key});

  @override
  State<IndoorMapPage> createState() => _IndoorMapPageState();
}

class _IndoorMapPageState extends State<IndoorMapPage> {
  final bleController = Get.put(BleController());
  final beaconController = Get.put(BeaconController());

  late List<Map<String, dynamic>> top3Device = [];

  @override
  void initState() {
    super.initState();
    // 데이터를 가져와서 top3Device를 업데이트합니다.
    updateTop3Device();
    print('top3: $top3Device');
  }

  void updateTop3Device() {
    if (bleController.rssiList.length >= 3) {
      top3Device.add({
        'mac': bleController.rssiList[0]['macAddress'],
        'rssi': bleController.rssiList[0]['rssi']
      });
      top3Device.add({
        'mac': bleController.rssiList[1]['macAddress'],
        'rssi': bleController.rssiList[1]['rssi']
      });
      top3Device.add({
        'mac': bleController.rssiList[2]['macAddress'],
        'rssi': bleController.rssiList[2]['rssi']
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/6th_floor.png',
              fit: BoxFit.cover,
            ),
            // Positioned(
            //   child: CustomPaint(
            //     painter: BeaconCircle1(
            //       x: ,
            //       y: ,
            //       rssi: ,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class BeaconCircle1 extends CustomPainter {
  final double? x;
  final double? y;
  final int? rssi;

  BeaconCircle1({this.x, this.y, this.rssi});

  @override
  void paint(Canvas canvas, Size size) {
    // 여기에 원 그리기 로직 구현
    final circle = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(const Offset(500, 350), 100, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //  항상 다시 그리도록 설정.
    return true;
  }
}
