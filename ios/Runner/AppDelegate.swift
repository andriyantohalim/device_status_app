import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // Define the motionManager at the class level to ensure it is accessible throughout the class
    let motionManager = CMMotionManager()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "com.example.device_status_app/battery",
                                                  binaryMessenger: controller.binaryMessenger)
        let sensorChannel = FlutterMethodChannel(name: "com.example.device_status_app/sensor",
                                                 binaryMessenger: controller.binaryMessenger)

        batteryChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            if call.method == "getBatteryInfo" {
                self.receiveBatteryInfo(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        sensorChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            if call.method == "getSensorData" {
                self.receiveSensorData(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func receiveBatteryInfo(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(device.batteryLevel * 100)
        let batteryState = device.batteryState
        let batteryTemperature = Int.random(in: 20...35) // iOS does not provide battery temperature natively
        let batteryVoltage = 3800 // iOS does not provide battery voltage natively, using a mock value

        let batteryHealth: String
        let statusString: String

        switch batteryState {
        case .unknown:
            batteryHealth = "unknown"
            statusString = "unknown"
        case .unplugged:
            batteryHealth = "good"
            statusString = "not charging"
        case .charging:
            batteryHealth = "good"
            statusString = "charging"
        case .full:
            batteryHealth = "good"
            statusString = "full"
        @unknown default:
            batteryHealth = "unknown"
            statusString = "unknown"
        }

        result([
            "level": batteryLevel,
            "health": batteryHealth,
            "temperature": batteryTemperature,
            "voltage": batteryVoltage,
            "status": statusString
        ])
    }

    private func receiveSensorData(result: FlutterResult) {
        var accelerometerData: [Double] = [0.0, 0.0, 0.0]
        var gyroscopeData: [Double] = [0.0, 0.0, 0.0]

        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates()
            if let data = motionManager.accelerometerData {
                accelerometerData = [data.acceleration.x, data.acceleration.y, data.acceleration.z]
            }
            motionManager.stopAccelerometerUpdates()
        }

        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates()
            if let data = motionManager.gyroData {
                gyroscopeData = [data.rotationRate.x, data.rotationRate.y, data.rotationRate.z]
            }
            motionManager.stopGyroUpdates()
        }

        result([
            "accelerometer": accelerometerData,
            "gyroscope": gyroscopeData
        ])
    }
}