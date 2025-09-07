import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import 'device_detail_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  late Future<List<Device>> futureDevices;
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    futureDevices = DeviceService.fetchDevices();
  }

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onSelected: (value) {
              setState(() {
                if (value == 'status') {
                  devices.sort((a, b) => a.status.compareTo(b.status));
                } else if (value == 'battery') {
                  int batteryValue(String b) =>
                      int.tryParse(b.replaceAll('%', '')) ?? 0;
                  devices.sort(
                    (a, b) => batteryValue(
                      a.battery,
                    ).compareTo(batteryValue(b.battery)),
                  );
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'status',
                child: Text('Sort by Status'),
              ),
              const PopupMenuItem(
                value: 'battery',
                child: Text('Sort by Battery'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Device>>(
        future: futureDevices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (devices.isEmpty) {
              devices = List.from(snapshot.data!);
            }
            return ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text('Device ${device.id} - ${device.name}'),
                  subtitle: Text('Location: ${device.location}'),
                  trailing: Chip(
                    label: Text(
                      device.status,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: device.status.toLowerCase() == 'online'
                        ? Colors.green
                        : Colors.red,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeviceDetailScreen(device: device),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
