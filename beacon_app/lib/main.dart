import 'package:beacon_app/data_folder/beacon_data.dart';
import 'package:beacon_app/data_folder/database_control.dart';
import 'package:beacon_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Flutter 앱을 실행하기 전, 필요한 바인딩을 초기화.
  WidgetsFlutterBinding.ensureInitialized();

  // 앱을 초기화.
  initializeApp();

// MyApp을 실행합니다.
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
  // 데이터베이스 헬퍼 클래스의 인스턴스 생성.
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  // BeaconController를 사용할 수 있도록 GetX에 등록.
  final beaconController = Get.put(BeaconController());

  // 데이터베이스 초기화.
  await dbHelper.database;

  // 데이터베이스에서 데이터를 불러와서 beaconDataList를 업데이트.
  await beaconController.updateBeaconDataListFromDatabase();

  // beaconDataList를 데이터베스에 업데이트(소스 코드로 기기 등록시 필요)
  // dbHelper.clearBeaconData();
  // beaconController.updateDatabaseListFromBeaconDataList();
}
