
import 'package:flutter/services.dart'; // ✅ REQUIRED


class NetworkCheckerPlus {
  static const MethodChannel _channel = MethodChannel('network_checker_plus');

  static Future<String> getConnectionType() async {
    final String type = await _channel.invokeMethod('getConnectionType');
    return type;
  }

  static Future<bool> hasInternet() async {
    final bool status = await _channel.invokeMethod('hasInternet');
    return status;
  }
}