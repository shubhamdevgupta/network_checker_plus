## [1.0.4] - 2025-06-24

### ✨ Features
- ✅ `isConnected()` – Check if device is connected to the internet.
- ✅ `getConnectionType()` – Returns `wifi`, `mobile`, `ethernet`, or `none`.
- ✅ `getNetworkSpeed()` – Estimates connection speed using real-time response (Google).
- ✅ `getSignalStrength()` – Returns Wi-Fi signal strength (0–4 bars).
- ✅ `connectivityStream` – Realtime stream for network connectivity changes.

### 🐛 Fixes
- Fixed issue where network stream was crashing on background thread.
- Corrected method channel initialization logic.

### 🔧 Improvements
- Organized platform code and improved null safety.
- Added support for Android 6.0+ network callbacks.

---

## [0.0.1] - Initial Release

- Basic platform plugin structure.
- `isConnected()` and `getConnectionType()` supported.
