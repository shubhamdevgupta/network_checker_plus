import 'package:flutter/material.dart';
import 'package:network_checker_plus/network_checker_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: HomePage());
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _type = 'Checking...';
  bool _internet = false;

  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  Future<void> checkNetwork() async {
    final type = await NetworkCheckerPlus.getConnectionType();
    final hasNet = await NetworkCheckerPlus.hasInternet();
    setState(() {
      _type = type;
      _internet = hasNet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Checker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection Type: $_type'),
            Text('Internet: $_internet'),
          ],
        ),
      ),
    );
  }
}
