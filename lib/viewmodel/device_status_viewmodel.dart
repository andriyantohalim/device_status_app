import 'package:flutter/services.dart';
import '../model/device_status_model.dart';

class DeviceStatusViewModel {
  static const platform = MethodChannel('com.example.device_status_app/battery');

  Future<DeviceStatus> fetchDeviceStatus() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getBatteryInfo');
      final batteryLevel = result['level'] as int;
      final batteryHealth = result['health'] as String;
      return DeviceStatus(batteryLevel: batteryLevel, batteryHealth: batteryHealth);
    } on PlatformException catch (e) {
      throw 'Failed to get device status: ${e.message}';
    }
  }
}