import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp()); // 앱 시작해주세요~ (메인페이지 필요)
}

class MyApp extends StatelessWidget {
  // 앱 메인페이지 만드는 법(기본 문법-무시해도 됨)
  final title = 'BLE Scan';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage ({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  // 장치명을 지정해 해당 장치만 표시되게함
  final String targetDeviceName = 'Vector cube';

  @override
  initState() {
    super.initState();
    // 블루투스 초기화
    initBle();
  }

  void initBle() {
    // BLE 상태를 얻기 위한 리스너
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
   */

  scan() async {
    if(!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();

      // 스캔 시작, 제한 시간 4초
      flutterBlue.startScan(timeout: Duration(seconds: 4));

      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
          // 결과값을 루프로 돌림
          results.forEach((element) {
            if (element.device.name == targetDeviceName) {
                // 장치의 ID를 비교해 이미 등록된 장치인지 확인
                if (scanResultList.indexWhere((e) => e.device.id == element.device.id) < 0) {
                  // 찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
                  scanResultList.add(element);
                }
              }
            }
          );
          // List<ScanResult> 형태의 results 값을 scanResultList에 복사
          scanResultList = results;

          // UI 갱신
          setState(() {});
        }
      );
    }
    else {
      // 스캔 중이라면 스캔 정지
      flutterBlue.stopScan();
    }
  }

  /*
  여기서부터는 장치별 출력용 함수들
   */

  // 장치의 신호값 및 위젯
  Widget deviceSignal(ScanResult r) {
    return Text(
      r.rssi.toString(),
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  // 장치의 MAC 주소 위젯
  Widget deviceMacAddress(ScanResult r) {
    return Text(
      r.device.id.id,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  // 장치의 이름 위젯
  Widget deviceName(ScanResult r) {
    String name = '';

    if(r.device.name.isNotEmpty) {
      // device.name에 값이 없다면
      name = r.device.name;
    }
    else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    }
    else {
      // 둘 다 없다면 이름 알 수 없음
      name = 'N/A';
    }
    return Text(
      name,
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

  // BLE 아이콘 위젯
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
        size: 30,
      ),
      backgroundColor: Colors.cyan,
      radius: 25,
    );
  }

  // 장치 아이템을 탭 했을 때 호출 되는 함수
  void onTap(ScanResult r) {
    // 단순히 이름만 출력
    print('&{r.device.name}');
  }

  // 장치 아이템 위젯
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        // 장치 리스트 출력
        child: ListView.separated(
            itemBuilder: (context, index) {
              return listItem(scanResultList[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: scanResultList.length,
        ),
      ),

      // 장치 검색 or 검색 중지
      floatingActionButton: FloatingActionButton(
        onPressed: scan,

        // 스캔 중이라면 stop 아이콘을, 정지 상태라면 search 아이콘을 표시
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}



