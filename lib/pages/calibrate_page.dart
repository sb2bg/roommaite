import 'package:flutter/material.dart';

class CalibratePage extends StatefulWidget {
  const CalibratePage({super.key});

  @override
  State<CalibratePage> createState() => _CalibratePageState();
}

class _CalibratePageState extends State<CalibratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibrate'),
      ),
      body: Center(
        child: const Text('Calibrate'),
      ),
    );
  }
}
