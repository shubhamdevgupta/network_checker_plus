import 'dart:async';
import 'package:flutter/services.dart';

class NetworkCheckerPlus {
  static const MethodChannel _channel = MethodChannel('network_checker_plus');
  static const EventChannel _eventChannel = EventChannel('network_checker_plus/connection');

  /// Returns true if device is connected to the internet
  static Future<bool> isConnected() async {
    final bool result = await _channel.invokeMethod('isConnected');
    return result;
  }

  /// Returns the current connection type: wifi, mobile, ethernet, none
  static Future<String> getConnectionType() async {
    final String result = await _channel.invokeMethod('getConnectionType');
    return result;
  }

  /// Estimates current network speed (ping-based)
  static Future<String> getNetworkSpeed() async {
    final String result = await _channel.invokeMethod('getNetworkSpeed');
    return result;
  }

  /// Returns Wi-Fi signal strength (0–4)
  static Future<int> getSignalStrength() async {
    final int result = await _channel.invokeMethod('getSignalStrength');
    return result;
  }

  /// Emits 'connected' / 'disconnected' as real-time stream
  static Stream<String> get connectivityStream {
    return _eventChannel.receiveBroadcastStream().map((event) => event.toString());
  }
}
