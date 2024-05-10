import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:beacon_app/data_folder/database_control.dart';
import 'package:beacon_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

void initializeApp() async {
  // 데이터베이스 헬퍼 클래스의 인스턴스 생성
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  final beaconController = Get.put(BeaconController());
  // 데이터베이스 초기화
  await dbHelper.database;

  // 데이터베이스에서 데이터를 불러와서 beaconDataList를 업데이트
  await beaconController.updateBeaconDataListFromDatabase();
  print(beaconController.beaconDataList);
}