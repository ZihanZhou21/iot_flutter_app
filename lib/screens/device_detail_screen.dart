import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        backgroundColor: Colors.tealAccent,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${device.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Location: ${device.location}'),
            Text('Status: ${device.status}'),
            Text('Battery: ${device.battery}'),
            Text('GPS: ${device.gps}'),
          ],
        ),
      ),
    );
  }
}
