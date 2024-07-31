# Device Status App

The Device Status App is a cross-platform mobile application built using Flutter. This app provides real-time information about the device’s battery status and sensor data, such as the accelerometer and gyroscope. The app uses Flutter’s Platform Channels to communicate with native code, enabling access to platform-specific features.

## Features

- **Battery Level:** Display battery level as a percentage.
- **Battery Health:** Show battery health status (good, cold, dead, overheat, over voltage, unspecified failure, or unknown).
- **Battery Temperature:** Display battery temperature in degrees Celsius.
- **Battery Voltage:** Show battery voltage in millivolts (mV).
- **Charging Status:** Indicate battery charging status (charging, discharging, full, or not charging).
- **Accelerometer:** Provides real-time data on the device’s acceleration along the X, Y, and Z axes.
- **Gyroscope:** Provides real-time data on the device’s rotational movement along the X, Y, and Z axes.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) for iOS development
- A physical device or emulator for testing

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/andriyantohalim/device_status_app.git
   cd device_status_app
   ```
2. **Install dependencies:**
    ```bash
    flutter pub get
    ```
3. **Run the app:**
    ```bash
    flutter run
    ```

## Platform-Specific Implementation

### Android
The Android implementation uses native code to access battery and sensor information. This is done through the MainActivity.kt file, where we define methods to retrieve battery information and sensor data using the SensorManager.

Key Methods:
- getBatteryInfo: Fetches the battery level, health, temperature, voltage, and charging status.
- getSensorData: Retrieves data from the accelerometer and gyroscope sensors.

### iOS
The iOS implementation leverages the CoreMotion framework to access sensor data. Battery information is retrieved using the UIDevice class.

Key Methods:
- receiveBatteryInfo: Retrieves battery-related information, including level, health, temperature, voltage, and charging status.
- receiveSensorData: Fetches data from the accelerometer and gyroscope using the CMMotionManager.

## Contributing

We welcome contributions from the community! Follow these steps to contribute:
1. Fork the repository.
2. Create a new branch:
    ```bash
    git checkout -b feature/your-feature-name
    ```
3. Commit your changes:
    ```bash
    git commit -m 'Add some feature'
    ```
4. Push to the branch:
    ```bash
    git push origin feature/your-feature-name
    ```
5. Open a pull request on GitHub.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

- [Flutter](https://flutter.dev/) for providing the framework.

For more information, visit the [project repository](https://github.com/andriyantohalim/device_status_app.git).
