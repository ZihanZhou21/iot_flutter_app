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

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'].toString(),
      name: json['name'],
      location: json['location'],
      status: json['status'],
      battery: json['battery'],
      gps: json['gps'],
    );
  }
}
