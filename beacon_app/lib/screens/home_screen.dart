// ignore_for_file: invalid_use_of_protected_member

import 'package:beacon_app/beacon_data/beacon_data.dart';
import 'package:beacon_app/bluetooth_data/ble_data.dart';
import 'package:beacon_app/pages/beacon_page.dart';
import 'package:beacon_app/pages/indoor_map_page.dart';
import 'package:beacon_app/pages/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bleController = Get.put(BLEController());
  final beaconController = Get.put(BeaconData());
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController addNicknameController = TextEditingController();
  final TextEditingController addIDController = TextEditingController();
  final TextEditingController addMACController = TextEditingController();

  int _selectedScreen = 0;

  String tempNickname = 'Nickname', tempID = 'ID', tempMAC = 'MAC';
  int tempFloor = 0, tempX = 0, tempY = 0, tempZ = 0;

  @override
  void dispose() {
    addNicknameController.dispose();
    addIDController.dispose();
    addMACController.dispose();
    super.dispose();
  }

  void pageChange(int index) {
    if (_selectedScreen != index) {
      setState(() {
        _selectedScreen = index;
      });
    }
  }

  void addButtonPressed(BuildContext context) {
    List<dynamic> newDevice = [
      tempMAC,
      tempID,
      tempFloor,
      tempX,
      tempY,
      tempZ,
      tempNickname,
    ];
    print(newDevice);
    beaconController.beaconDataList.add(newDevice);
    print(beaconController.beaconDataList.value);
    Navigator.pop(context);
  }

  Widget addDeviceDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Device',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      scrollable: true,
      actions: [
        TextField(
          controller: addNicknameController,
          decoration: const InputDecoration(label: Text('Nickname')),
          onChanged: (value) => tempNickname,
        ),
        TextField(
          controller: addIDController,
          decoration: const InputDecoration(label: Text('ID')),
          onChanged: (value) => tempID,
        ),
        TextField(
          controller: addMACController,
          decoration: const InputDecoration(label: Text('MAC Address')),
          onChanged: (value) => tempMAC,
        ),
        const SizedBox(height: 30),
        SpinBox(
          min: -100,
          max: 100,
          value: 0,
          decimals: 0,
          step: 1,
          onChanged: (value) => setState(() {
            tempFloor = value.toInt();
          }),
          decoration: const InputDecoration(
              label: Text(
                'Floor',
                style: TextStyle(fontSize: 22),
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
        TextButton(
          onPressed: () => addButtonPressed(context),
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Colors.deepPurple.shade100),
            fixedSize: const MaterialStatePropertyAll(Size(80, 50)),
          ),
          child: const Text(
            'Add',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                bleController.isScanning.value ? Icons.stop : Icons.search,
              ),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                bleController.toggleState();
              },
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: pageChange,
        children: const [
          ScanPage(),
          BeaconPage(),
          IndoorMapPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: "BLE Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_input_antenna),
            label: "Beacon",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "IndoorMap",
          ),
        ],
        currentIndex: _selectedScreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: (int index) {
          _pageController.jumpToPage(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return addDeviceDialog(context);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
