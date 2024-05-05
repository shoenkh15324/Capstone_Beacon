import 'package:beacon_app/bluetooth/bluetooth_data.dart';
import 'package:beacon_app/pages/beacon_page.dart';
import 'package:beacon_app/pages/indoor_map_page.dart';
import 'package:beacon_app/pages/scan_page.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // 생성자에서 key를 받아옵니다

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // 상태 객체를 생성합니다.
}

class _HomeScreenState extends State<HomeScreen> {
  final bleController = Get.put(BLEController());
  int _selectedScreen = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void pageChange(int index) {
    _selectedScreen = index;
    setState(() {});
  }

// Flutter 앱의 화면을 구성하는 위젯입니다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 상단의 앱 바를 구성합니다.
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
        shadowColor: Colors.black,
        title: const Text(
          'Receiver App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                  bleController.isScanning.value ? Icons.stop : Icons.search),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                bleController.toggleState();
              },
            ),
          ),
        ],
      ),
      // 앱의 본문을 구성합니다.
      body: PageView(
        controller: _pageController,
        physics: const PageScrollPhysics(),
        onPageChanged: pageChange,
        children: const [
          ScanPage(),
          BeaconPage(),
          IndoorMapPage(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text("BLE Scan"),
            activeColor: Colors.white,
            activeTitleColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomBarItem(
            icon: Icon(Icons.settings_input_antenna),
            title: Text("Beacon"),
            activeColor: Colors.white,
            activeTitleColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomBarItem(
            icon: Icon(Icons.map),
            title: Text("IndoorMap"),
            activeColor: Colors.white,
            activeTitleColor: Colors.white,
            inactiveColor: Colors.white,
          ),
        ],
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.blue,
        selectedIndex: _selectedScreen,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _selectedScreen = index);
        },
      ),
    );
  }
}
