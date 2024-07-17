class DeviceStatus {
  final int batteryLevel;
  final String batteryHealth;
  final int batteryTemperature;
  final int batteryVoltage;
  final String batteryStatus;

  DeviceStatus({
    required this.batteryLevel,
    required this.batteryHealth,
    required this.batteryTemperature,
    required this.batteryVoltage,
    required this.batteryStatus,
  });
}