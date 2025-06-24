import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_checker_plus_method_channel.dart';

abstract class NetworkCheckerPlusPlatform extends PlatformInterface {
  /// Constructs a NetworkCheckerPlusPlatform.
  NetworkCheckerPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static NetworkCheckerPlusPlatform _instance = MethodChannelNetworkCheckerPlus();

  /// The default instance of [NetworkCheckerPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelNetworkCheckerPlus].
  static NetworkCheckerPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NetworkCheckerPlusPlatform] when
  /// they register themselves.
  static set instance(NetworkCheckerPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
