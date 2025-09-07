import 'package:flutter/material.dart';
import 'screens/device_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      title: 'Device Tracker',
      home: const DeviceListScreen(),
    );
  }
}
