import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "com.example.device_status_app/battery",
                                                  binaryMessenger: controller.binaryMessenger)
        batteryChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
            if call.method == "getBatteryInfo" {
                self.receiveBatteryInfo(result: result)
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

        result(["level": batteryLevel, "health": batteryHealth, "temperature": batteryTemperature, "voltage": batteryVoltage, "status": statusString])
    }
}