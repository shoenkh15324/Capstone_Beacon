import 'package:flutter/material.dart';

class IndoorMapPage extends StatefulWidget {
  const IndoorMapPage({super.key});

  @override
  State<IndoorMapPage> createState() => _IndoorMapPageState();
}

class _IndoorMapPageState extends State<IndoorMapPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        child: const Text('IndoorMap Page'),
      ),
    );
  }
}
