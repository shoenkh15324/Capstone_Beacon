import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:beacon_app/data_folder/ble_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndoorMapPage extends StatefulWidget {
  const IndoorMapPage({super.key});

  @override
  State<IndoorMapPage> createState() => IndoorMapPageState();
}

class IndoorMapPageState extends State<IndoorMapPage> {
  final bleController = Get.put(BleController());
  final beaconController = Get.put(BeaconController());

  int maxDevice = 3;

  @override
  void initState() {
    super.initState();

    // rssiList가 업데이트될 때마다 화면을 다시 그리도록 함
    ever(bleController.rssiList, (_) {
      setState(() {});
    });
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
            for (var i = 0;
                i <
                    (bleController.rssiList.length < maxDevice
                        ? bleController.rssiList.length
                        : maxDevice);
                i++)
              Obx(
                () => Positioned(
                  child: CustomPaint(
                    painter: BeaconCircle(
                      x: beaconController.beaconDataList[
                          beaconController.findMACIndex(
                              bleController.rssiList[i]['macAddress'])][3],
                      y: beaconController.beaconDataList[
                          beaconController.findMACIndex(
                              bleController.rssiList[i]['macAddress'])][4],
                      rssi: bleController.rssiList[i]['rssi'],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BeaconCircle extends CustomPainter {
  final int? x;
  final int? y;
  final int? rssi;

  BeaconCircle({this.x, this.y, this.rssi});

  @override
  void paint(Canvas canvas, Size size) {
    // 여기에 원 그리기 로직 구현
    final circle = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(x!.toDouble(), y!.toDouble()), 100, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //  항상 다시 그리도록 설정.
    return true;
  }
}
