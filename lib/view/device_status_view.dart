import 'package:flutter/material.dart';
import '../viewmodel/device_status_viewmodel.dart';
import '../model/device_status_model.dart';

class DeviceStatusView extends StatefulWidget {
  const DeviceStatusView({super.key});

  @override
  _DeviceStatusViewState createState() => _DeviceStatusViewState();
}

class _DeviceStatusViewState extends State<DeviceStatusView> {
  late Future<DeviceStatus> _deviceStatus;

  @override
  void initState() {
    super.initState();
    _deviceStatus = DeviceStatusViewModel().fetchDeviceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Status'),
      ),
      body: Center(
        child: FutureBuilder<DeviceStatus>(
          future: _deviceStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final deviceStatus = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Battery Level: ${deviceStatus.batteryLevel}%'),
                  Text('Battery Health: ${deviceStatus.batteryHealth}'),
                  Text('Battery Temperature: ${deviceStatus.batteryTemperature / 10}°C'),
                  Text('Battery Voltage: ${deviceStatus.batteryVoltage} mV'),
                  Text('Battery Status: ${deviceStatus.batteryStatus}'),
                ],
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}