import "dart:math";
import "package:beacon_app/data_folder/beacon_data.dart";
import "package:beacon_app/data_folder/ble_data.dart";
import "package:beacon_app/pages/indoor_map_page.dart";
import "package:get/get.dart";
import "package:matrix2d/matrix2d.dart";

class Coordinate {
  double centerX;
  double centerY;
  double radius;

  Coordinate({
    required this.centerX,
    required this.centerY,
    required this.radius,
  });
}

class Triangulation {
  Triangulation();

  final bleController = Get.put(BleController());
  final beaconController = Get.put(BeaconController());

  List<Coordinate> beaconN = [];

  double getDistance(int rssi) {
    const double alpha = 60;
    const double constantN = 2;
    double distance = pow(10, (alpha - rssi) / (10 * constantN)).toDouble();
    return distance;
  }
}
