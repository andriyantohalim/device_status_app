class DeviceStatus {
  final int batteryLevel;
  final String batteryHealth;
  final int batteryTemperature;
  final int batteryVoltage;
  final String batteryStatus;
  final List<double> accelerometer;
  final List<double> gyroscope;

  DeviceStatus({
    required this.batteryLevel,
    required this.batteryHealth,
    required this.batteryTemperature,
    required this.batteryVoltage,
    required this.batteryStatus,
    required this.accelerometer,
    required this.gyroscope,
  });
}