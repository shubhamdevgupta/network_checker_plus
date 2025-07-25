import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker_plus/network_checker_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNetworkCheckerPlus platform = MethodChannelNetworkCheckerPlus();
  const MethodChannel channel = MethodChannel('network_checker_plus');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
