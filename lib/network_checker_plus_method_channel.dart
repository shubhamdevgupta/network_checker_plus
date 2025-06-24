import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'network_checker_plus_platform_interface.dart';

/// An implementation of [NetworkCheckerPlusPlatform] that uses method channels.
class MethodChannelNetworkCheckerPlus extends NetworkCheckerPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('network_checker_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
