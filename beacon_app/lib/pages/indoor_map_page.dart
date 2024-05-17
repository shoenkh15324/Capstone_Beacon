import 'dart:ui';

import 'package:beacon_app/calculation/trilateration.dart';
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
  Worker? rssiListListener;
  Worker? coordinateListListener;

  List<Coordinate> coordinateList = [];
  List<dynamic> userPosition = [];

  void updateCoordinateList() {
    coordinateList.clear();

    for (var i = 0; i < bleController.rssiList.length; i++) {
      if (i >= maxDevice) break;

      var index = beaconController
          .findMACIndex(bleController.rssiList[i]['macAddress']);

      if (index == -1) continue;

      coordinateList.add(Coordinate(
        centerX: beaconController.beaconDataList[index][3].toDouble(),
        centerY: beaconController.beaconDataList[index][4].toDouble(),
        radius: bleController.rssiList[i]['rssi'].toDouble(),
      ));
    }
  }

  void updateUserPositionList() {
    Trilateration trilateration = Trilateration();

    List position = trilateration.trilaterationMethod(coordinateList);
    userPosition = position;
  }

  @override
  void initState() {
    super.initState();

    // rssiList가 업데이트될 때마다 화면을 다시 그리도록 함
    rssiListListener = ever(bleController.rssiList, (_) {
      if (mounted) {
        updateCoordinateList();
        updateUserPositionList();
        print(userPosition);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    rssiListListener?.dispose();
    super.dispose();
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
              Positioned(
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
            if (coordinateList.length >= 3)
              Positioned(
                child: CustomPaint(
                  painter: UserPosition(
                    x: userPosition[0][0].toDouble(),
                    y: userPosition[1][0].toDouble(),
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
    if (x == null || y == null || rssi == null) return;

    const double maxDistance = 80.0;
    final double distance = rssi!.abs().toDouble();

    final double radius = distance > maxDistance ? maxDistance : distance;
    final Offset center = Offset(x!.toDouble(), y!.toDouble());

    final pointPaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawPoints(PointMode.points, [center], pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //  항상 다시 그리도록 설정.
    return true;
  }
}

class UserPosition extends CustomPainter {
  final double? x;
  final double? y;

  UserPosition({required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(x!, y!);

    final pointPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    canvas.drawPoints(PointMode.points, [center], pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //  항상 다시 그리도록 설정.
    return true;
  }
}
