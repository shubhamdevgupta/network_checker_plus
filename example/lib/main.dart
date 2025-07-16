import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_checker_plus/network_checker_plus.dart';

void main() {
  runApp(const NetworkCheckerApp());
}

class NetworkCheckerApp extends StatelessWidget {
  const NetworkCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Checker Plus Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NetworkCheckerHomePage(),
    );
  }
}

class NetworkCheckerHomePage extends StatefulWidget {
  const NetworkCheckerHomePage({super.key});

  @override
  State<NetworkCheckerHomePage> createState() => _NetworkCheckerHomePageState();
}

class _NetworkCheckerHomePageState extends State<NetworkCheckerHomePage> {
  bool _isConnected = false;
  String _connectionType = 'Unknown';
  String _networkSpeed = 'Unknown';
  int _signalStrength = -1;
  String _connectivityStream = 'Waiting...';
  String _realTimeSpeed = 'Calculating...';

  StreamSubscription<String>? _subscription;
  Timer? _realTimeSpeedTimer;

  Future<void> _updateNetworkInfo() async {
    try {
      final connected = await NetworkCheckerPlus.isConnected();
      final type = await NetworkCheckerPlus.getConnectionType();
      final speed = await NetworkCheckerPlus.getNetworkSpeed();
      final strength = await NetworkCheckerPlus.getSignalStrength();

      setState(() {
        _isConnected = connected;
        _connectionType = type;
        _networkSpeed = speed;
        _signalStrength = strength;
      });
    } catch (e) {
      debugPrint('Error fetching network info: $e');
    }
  }

  Future<void> _getRealTimeNetworkSpeed() async {
    const testUrl = 'https://t3.ftcdn.net/jpg/12/13/72/80/240_F_1213728051_pFIL7Ysaklimctx4U9s0wNvH4oKrNPCO.jpg';
    final uri = Uri.parse(testUrl);

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(uri);
      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes.length;
        final seconds = stopwatch.elapsedMilliseconds / 1000.0;
        final kbps = (bytes / 1024) / seconds;
        final mbps = kbps / 1024;

        setState(() {
          if (mbps >= 1) {
            _realTimeSpeed = '${mbps.toStringAsFixed(2)} MB/s';
          } else {
            _realTimeSpeed = '${kbps.toStringAsFixed(2)} KB/s';
          }
        });
      } else {
        setState(() {
          _realTimeSpeed = 'Failed (${response.statusCode})';
        });
      }
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _realTimeSpeed = 'Error: $e';
      });
    }
  }

  void _startListeningToConnectivity() {
    _subscription = NetworkCheckerPlus.connectivityStream.listen((event) {
      setState(() {
        _connectivityStream = event;
      });
    });
  }

  void _startRealTimeSpeedTest() {
    _realTimeSpeedTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _getRealTimeNetworkSpeed();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateNetworkInfo();
    _startListeningToConnectivity();
    _startRealTimeSpeedTest();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _realTimeSpeedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Checker Plus'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateNetworkInfo,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text("Is Connected"),
              trailing: Text(_isConnected ? '✅ Yes' : '❌ No'),
            ),
            ListTile(
              title: const Text("Connection Type"),
              trailing: Text(_connectionType),
            ),
            ListTile(
              title: const Text("Network Speed"),
              trailing: Text(_networkSpeed),
            ),
            ListTile(
              title: const Text("Signal Strength (Wi-Fi)"),
              trailing: Text(_signalStrength >= 0
                  ? '📶 $_signalStrength/4'
                  : 'Unavailable'),
            ),
            ListTile(
              title: const Text("Connectivity Stream"),
              trailing: Text(_connectivityStream),
            ),
            const Divider(),
            ListTile(
              title: const Text("Real-Time Speed (Auto Refresh)"),
              trailing: Text(_realTimeSpeed),
            ),
          ],
        ),
      ),
    );
  }
}
