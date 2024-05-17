import "dart:math";
import "package:beacon_app/data_folder/beacon_data.dart";
import "package:beacon_app/data_folder/ble_data.dart";
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

class Trilateration {
  Trilateration();

  final bleController = Get.put(BleController());
  final beaconController = Get.put(BeaconController());

  List<Coordinate> beaconN = [];

  List trilaterationMethod(List<Coordinate> coordinateList) {
    const double maxDistance = 100.0;
    var matrixA = [];
    var matrixB = [];
    const Matrix2d m2d = Matrix2d();

    for (int idx = 1; idx <= coordinateList.length - 1; idx++) {
      matrixA.add([
        coordinateList[idx].centerX - coordinateList[0].centerX,
        coordinateList[idx].centerY - coordinateList[0].centerY
      ]);
      matrixB.add([
        ((pow(coordinateList[idx].centerX, 2) +
                    pow(coordinateList[idx].centerY, 2) -
                    pow(
                        coordinateList[idx].radius > maxDistance
                            ? maxDistance
                            : coordinateList[idx].radius,
                        2)) -
                (pow(coordinateList[0].centerX, 2) +
                    pow(coordinateList[0].centerY, 2) -
                    pow(
                        coordinateList[0].radius > maxDistance
                            ? maxDistance
                            : coordinateList[0].radius,
                        2))) /
            2
      ]);
    }

    var matrixATranspose = transposeDouble(matrixA);
    var matrixInverse = dim2InverseMatrix(m2d.dot(matrixATranspose, matrixA));
    var matrixDot = m2d.dot(matrixInverse, matrixATranspose);
    var position = m2d.dot(matrixDot, matrixB);
    return position;
  }

  List transposeDouble(List list) {
    var shape = list.shape;
    var temp = List.filled(shape[1], 0.0)
        .map((e) => List.filled(shape[0], 0.0))
        .toList();
    for (var i = 0; i < shape[1]; i++) {
      for (var j = 0; j < shape[0]; j++) {
        temp[i][j] = list[i][j];
      }
    }
    return temp;
  }

  List dim2InverseMatrix(List list) {
    var shape = list.shape;
    var temp = List.filled(shape[1], 0.0)
        .map((e) => List.filled(shape[0], 0.0))
        .toList();
    var determinant = list[0][0] * list[1][1] - list[1][0] * list[0][1];
    temp[0][0] = list[1][1] / determinant;
    temp[0][1] = list[0][1] / determinant;
    temp[1][0] = list[1][0] / determinant;
    temp[1][1] = list[0][0] / determinant;

    return temp;
  }

  double getDistance(int rssi) {
    const double alpha = 60;
    const double constantN = 2;
    double distance = pow(10, (alpha - rssi) / (10 * constantN)).toDouble();
    return distance;
  }
}
