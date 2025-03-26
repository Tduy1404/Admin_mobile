
import 'dart:convert';
class TripHistory {
  final int id;
  // final int customerId;
  final String customerName; // Thêm tên khách hàng
  final String busNumber;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration;
  final double fare;
  final String paymentStatus;
  final DateTime createdAt;

  TripHistory({
    required this.id,
    // required this.customerId,
    required this.customerName, // Nhận tên khách hàng
    required this.busNumber,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.fare,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory TripHistory.fromJson(Map<String, dynamic> json) {
    return TripHistory(
      id: json['id'] ?? 0, // Nếu null, gán 0
      // customerId: json['customerId'] ?? 0, // Nếu null, gán 0
      customerName: json['customerName'] ?? 'Không rõ', // Nếu null, gán mặc định
      busNumber: json['busNumber'] ?? 'Chưa có',
      startLocation: json['startLocation'] ?? 'Chưa có',
      endLocation: json['endLocation'] ?? 'Chưa có',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'] as int?, // Có thể null
      fare: (json['fare'] ?? 0).toDouble(), // Nếu null, gán 0
      paymentStatus: json['paymentStatus'] ?? 'Unknown',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }


  static List<TripHistory> fromJsonList(String jsonStr) {
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((json) => TripHistory.fromJson(json)).toList();
  }
}
