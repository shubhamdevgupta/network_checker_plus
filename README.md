# 📡 network\_checker\_plus

[![Pub Version](https://img.shields.io/pub/v/network_checker_plus.svg)](https://pub.dev/packages/network_checker_plus)
[![Platform Support](https://img.shields.io/badge/platforms-android%20%7C%20ios-lightgrey)]()
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A lightweight and efficient Flutter plugin to check the network status of the device. Easily determine whether the user is connected to the internet and what type of network they’re using — Wi-Fi, mobile data, or none. Now with support for network speed, signal strength, and real-time connectivity stream.   

---

## ✨ Features

✅ Check if the device is connected to the internet
✅ Detect the type of connection (Wi-Fi, Mobile, or None)
✅ Estimate network speed (e.g., ping a server or download a small file)
✅ Measure signal strength (Wi-Fi)
✅ Real-time stream of connectivity status

---

## 🚀 Getting Started

### 1️⃣ Add Dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  network_checker_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### 2️⃣ Import the Package

```dart
import 'package:network_checker_plus/network_checker_plus.dart';
```

---

## 🔍 Usage

### ✅ Check Internet Status

```dart
final bool isConnected = await NetworkCheckerPlus.isConnected();
print('Connected: \$isConnected');
```

### 📡 Get Connection Type

```dart
final String type = await NetworkCheckerPlus.getConnectionType();
print('Connection Type: \$type');
```

> Possible values:
>
> * 'wifi'
> * 'mobile'
> * 'none'
> * 'unknown'

### ⌛️ Estimate Network Speed

```dart
final String speed = await NetworkCheckerPlus.getNetworkSpeed();
print('Network Speed: \$speed');
```

> Possible values:
>
> * "Excellent"
> * "Good"
> * "Moderate"
> * "Poor"
> * "No Connection"

### 📶 Get Signal Strength (Wi-Fi only)

```dart
final int strength = await NetworkCheckerPlus.getSignalStrength();
print('Signal Strength: \$strength/4');
```

> Signal levels range from 0 (Weak) to 4 (Excellent).

### ⏳ Listen to Connectivity Changes

```dart
NetworkCheckerPlus.connectivityStream.listen((event) {
  print('Connectivity Changed: \$event');
});
```

> Events:
>
> * 'connected'
> * 'disconnected'

---

## 🛡 Permissions

### 📱 Android

Ensure you add the following permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```

Some features (e.g., signal strength) may require `ACCESS_FINE_LOCATION` on newer Android versions.

---

## 🧪 Example

Clone this repo and run the example app to see it in action:

```bash
cd example
flutter run
```

---

## 💡 Roadmap

* [x] Check network connection
* [x] Detect connection type (Wi-Fi or Mobile)
* [x] Estimate basic network speed
* [x] Measure Wi-Fi signal strength
* [x] Real-time listener for network changes
* [ ] Support signal strength for mobile networks

---

## 👥 Contributing

We welcome contributions! Whether it’s bug reports, feature requests, documentation, or code — all are appreciated.

1. Fork the repo
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a pull request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💬 Support

If you find this plugin helpful, please consider giving it a ⭐ on [GitHub](https://github.com/yourusername/network_checker_plus) and sharing it with other Flutter developers!

Questions? Suggestions? [Open an issue](https://github.com/yourusername/network_checker_plus/issues)

---

Made with ❤️ for Flutter developers.
