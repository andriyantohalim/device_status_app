import 'package:flutter/material.dart';
import 'view/device_status_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Status App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeviceStatusView(),
    );
  }
}