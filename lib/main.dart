import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Tracker',
      home: const DeviceListScreen(),
    );
  }
}

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  late Future<List<Device>> futureDevices;
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    futureDevices = fetchDevices();
  }

  Future<List<Device>> fetchDevices() async {
    //mock API endpoint
    final url = Uri.parse('https://iot-flutter.free.beeceptor.com/api/devices');

    final response = await http.get(url);
    logger.i("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return Device(
          id: item['id'].toString(),
          name: item['name'],
          location: item['location'],
          status: item['status'],
          battery: item['battery'],
          gps: item['gps'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Devices'),
          backgroundColor: Colors.tealAccent,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: FutureBuilder<List<Device>>(
          future: futureDevices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No devices found.'));
            }

            final devices = snapshot.data!;
            return ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text('Device ${device.id} - ${device.name}'),
                  subtitle: Text('Location: ${device.location}'),
                  trailing: Text(
                    device.status,
                    style: TextStyle(
                      color: device.status.toLowerCase() == 'online'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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
          },
        ),
      ),
    );
  }
}

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
        iconTheme: IconThemeData(
          color: Colors.black, // 修改 AppBar 上 Icon 的颜色
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${device.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Location: ${device.location}'),
            const SizedBox(height: 8),
            Text('Status: ${device.status}'),
            const SizedBox(height: 8),
            Text('Battery: ${device.battery}'),
            const SizedBox(height: 8),
            Text('GPS: ${device.gps}'),
          ],
        ),
      ),
    );
  }
}

class Device {
  final String id;
  final String name;
  final String location;
  final String status;
  final String battery;
  final String gps;

  Device({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.battery,
    required this.gps,
  });
}
