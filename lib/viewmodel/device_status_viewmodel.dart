import 'package:flutter/services.dart';
import '../model/device_status_model.dart';

class DeviceStatusViewModel {
  static const batteryChannel = MethodChannel('com.example.device_status_app/battery');
  static const sensorChannel = MethodChannel('com.example.device_status_app/sensor');

  Future<DeviceStatus> fetchDeviceStatus() async {
    try {
      final Map<dynamic, dynamic> batteryResult = await batteryChannel.invokeMethod('getBatteryInfo');
      final Map<dynamic, dynamic> sensorResult = await sensorChannel.invokeMethod('getSensorData');

      final batteryLevel = batteryResult['level'] as int;
      final batteryHealth = batteryResult['health'] as String;
      final batteryTemperature = batteryResult['temperature'] as int;
      final batteryVoltage = batteryResult['voltage'] as int;
      final batteryStatus = batteryResult['status'] as String;

      final accelerometer = List<double>.from(sensorResult['accelerometer']);
      final gyroscope = List<double>.from(sensorResult['gyroscope']);
      
      return DeviceStatus(
        batteryLevel: batteryLevel,
        batteryHealth: batteryHealth,
        batteryTemperature: batteryTemperature,
        batteryVoltage: batteryVoltage,
        batteryStatus: batteryStatus,
        accelerometer: accelerometer,
        gyroscope: gyroscope,
      );
    } on PlatformException catch (e) {
      throw 'Failed to get device status: ${e.message}';
    }
  }
}