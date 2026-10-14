## 0.0.2

* **Major System Intelligence & Hardware Expansion**:
  * **Thermal & Power Management (`ThermalInfo`)**:
    * Added thermal throttling state (`NONE`, `LIGHT`, `MODERATE`, `SEVERE`, `CRITICAL`, `EMERGENCY`, `SHUTDOWN`).
    * Added `isThrottling` boolean helper, system battery saver mode detection, and device idle / doze mode state.
  * **Display HDR & Refresh Rate Capabilities (`DisplayCapabilitiesInfo`)**:
    * Added HDR detection and supported HDR standards (`HDR10`, `HDR10_PLUS`, `DOLBY_VISION`, `HLG`).
    * Added Wide Color Gamut (DCI-P3) display panel detection.
    * Added display supported refresh rates (e.g., 60Hz, 90Hz, 120Hz).
    * Added screen brightness level and auto-brightness state.
  * **Hardware Peripherals & Radios (`PeripheralsInfo`)**:
    * Added NFC hardware availability and enabled state.
    * Added Bluetooth radio adapter availability and enabled state.
    * Added camera lenses count (total, front, rear) and LED flashlight / torch detection.
    * Added vibration motor and advanced amplitude modulation / haptic control detection.
  * **Audio Streams & Volume Controls (`AudioVolumeInfo`)**:
    * Added volume levels and maximum steps for Media, Ringtone, Call, Alarm, and Notification streams.
    * Added normalized media volume percentage getter.
    * Added hardware microphone mute detection and Bluetooth A2DP audio route streaming state.
  * **Regional, Theme & Accessibility (`LocaleThemeInfo`)**:
    * Added device timezone ID and formatted UTC offset (e.g. `Asia/Kolkata (+05:30)`).
    * Added user's ordered list of preferred system languages.
    * Added 24-hour vs 12-hour clock format detection.
    * Added system font scale multiplier, TalkBack / VoiceOver screen reader detection, and OS dark mode status.
  * **Security & Anti-Fraud Suite (`SecurityInfo`)**:
    * Added Developer Options, USB debugging (ADB), and Wireless ADB detection.
    * Added Fake GPS / Mock Location provider detection.
    * Added USB cable connection state and USB app verification checks.
    * Added Screen lock security (PIN/pattern/biometric) and native debugger attachment detection.
  * **DRM & OTT Video Streaming Certification (`DrmInfo`)**:
    * Added Widevine security level (`L1` vs `L3`), vendor, version, system ID, and `isHdCapable` flag.
  * **Biometric Hardware & Enrollment (`BiometricInfo`)**:
    * Added Touch ID, Face ID, Fingerprint, Iris, Optic ID hardware detection and user enrollment status.
  * **Hardware Sensors (`SensorsInfo`)**:
    * Added accelerometer, gyroscope, magnetometer, barometer, proximity, light, and step counter detection.
    * Added total sensor inventory and sensor names list.
  * **Live Hardware Signals (`LiveHardwareInfo`)**:
    * Added interactive screen state, Wi-Fi radio status, active phone/VoIP call, headphones route, and SIM slot count.
  * **"About Phone" Build Details (`DeviceInfo`)**:
    * Added security patch date, OS kernel release, baseband/radio firmware, bootloader, supported ABIs, and formatted uptime.
  * **Aggregated Snapshot (`SystemInfo`)**:
    * Updated `getSystemInfo()` to return all metrics in a single optimized native platform invocation.

## 0.0.1

* Initial release of `advanced_device_info` containing Core Device Information:
  * **Device Info**: Retrieve brand, manufacturer, model, name, isEmulator, and raw build details.
  * **Storage Info**: Query total, free, and used disk storage space with convenient GB formatters.
  * **RAM Memory Info**: Query total, free, used RAM with usage percentages and low memory flags.
  * **CPU Info**: Query CPU architecture and core count.
  * **Screen Info**: Query device width, height, density scale, and refresh rate.
  * **Unified System Info**: Query all information in a single efficient call.
