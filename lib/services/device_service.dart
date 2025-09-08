import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/device.dart';

class DeviceService {
  static final logger = Logger();
  static Future<List<Device>> fetchDevices() async {
    final url = Uri.parse('https://iot-flutter.free.beeceptor.com/api/devices');
    final response = await http.get(url);
    logger.i(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Device.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
}
