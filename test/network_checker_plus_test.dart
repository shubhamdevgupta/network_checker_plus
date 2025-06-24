import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker_plus/network_checker_plus.dart';
import 'package:network_checker_plus/network_checker_plus_platform_interface.dart';
import 'package:network_checker_plus/network_checker_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNetworkCheckerPlusPlatform
    with MockPlatformInterfaceMixin
    implements NetworkCheckerPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NetworkCheckerPlusPlatform initialPlatform = NetworkCheckerPlusPlatform.instance;

  test('$MethodChannelNetworkCheckerPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNetworkCheckerPlus>());
  });

  test('getPlatformVersion', () async {
    NetworkCheckerPlus networkCheckerPlusPlugin = NetworkCheckerPlus();
    MockNetworkCheckerPlusPlatform fakePlatform = MockNetworkCheckerPlusPlatform();
    NetworkCheckerPlusPlatform.instance = fakePlatform;

    expect(await networkCheckerPlusPlugin.getPlatformVersion(), '42');
  });
}
