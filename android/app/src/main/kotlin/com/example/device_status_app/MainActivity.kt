package com.example.device_status_app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.BatteryManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), SensorEventListener {
    private val CHANNEL_BATTERY = "com.example.device_status_app/battery"
    private val CHANNEL_SENSOR = "com.example.device_status_app/sensor"

    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null
    private var gyroscope: Sensor? = null

    private var accelerometerData: FloatArray = FloatArray(3)
    private var gyroscopeData: FloatArray = FloatArray(3)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        gyroscope = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_BATTERY).setMethodCallHandler {
            call, result ->
            if (call.method == "getBatteryInfo") {
                val batteryInfo = getBatteryInfo()
                if (batteryInfo != null) {
                    result.success(batteryInfo)
                } else {
                    result.error("UNAVAILABLE", "Battery info not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SENSOR).setMethodCallHandler {
            call, result ->
            if (call.method == "getSensorData") {
                val sensorData = getSensorData()
                result.success(sensorData)
            } else {
                result.notImplemented()
            }
        }

        accelerometer?.also { accel ->
            sensorManager.registerListener(this, accel, SensorManager.SENSOR_DELAY_NORMAL)
        }

        gyroscope?.also { gyro ->
            sensorManager.registerListener(this, gyro, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            when (it.sensor.type) {
                Sensor.TYPE_ACCELEROMETER -> accelerometerData = it.values.clone()
                Sensor.TYPE_GYROSCOPE -> gyroscopeData = it.values.clone()
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    private fun getBatteryInfo(): Map<String, Any>? {
        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val batteryLevel = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val batteryHealth = intent?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1
        val batteryTemperature = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
        val batteryVoltage = intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: -1
        val batteryStatus = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1

        val healthString = when (batteryHealth) {
            BatteryManager.BATTERY_HEALTH_COLD -> "cold"
            BatteryManager.BATTERY_HEALTH_DEAD -> "dead"
            BatteryManager.BATTERY_HEALTH_GOOD -> "good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "overheat"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "over voltage"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "unspecified failure"
            else -> "unknown"
        }

        val statusString = when (batteryStatus) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "discharging"
            BatteryManager.BATTERY_STATUS_FULL -> "full"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "not charging"
            else -> "unknown"
        }

        return mapOf(
            "level" to batteryLevel,
            "health" to healthString,
            "temperature" to batteryTemperature,
            "voltage" to batteryVoltage,
            "status" to statusString
        )
    }

    private fun getSensorData(): Map<String, Any> {
        return mapOf(
            "accelerometer" to accelerometerData.toList(),
            "gyroscope" to gyroscopeData.toList()
        )
    }
}