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

        let batteryHealth: String
        switch batteryState {
        case .unknown:
            batteryHealth = "unknown"
        case .unplugged, .charging, .full:
            batteryHealth = "good"
        @unknown default:
            batteryHealth = "unknown"
        }

        result(["level": batteryLevel, "health": batteryHealth])
    }
}