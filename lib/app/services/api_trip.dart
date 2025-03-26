import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/trip_history.dart';

class ApiTripService {
  final String apiUrl = "https://10.0.2.2:7017/api/triphistory"; // API URL


  Future<List<TripHistory>> fetchTrips() async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;

      HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
      HttpClientResponse response = await request.close();
      String jsonResponse = await response.transform(utf8.decoder).join();

      print("🔹 API Response: $jsonResponse"); // In response để debug

      if (response.statusCode == 200) {
        var decodedJson = json.decode(jsonResponse);

        // Nếu API trả về một Map có key "$values"
        if (decodedJson is Map<String, dynamic> && decodedJson.containsKey("\$values")) {
          return (decodedJson["\$values"] as List)
              .map((json) => TripHistory.fromJson(json))
              .toList();
        }

        // Nếu API trả về một List trực tiếp
        if (decodedJson is List) {
          return decodedJson.map((json) => TripHistory.fromJson(json)).toList();
        }

        throw Exception("Dữ liệu API không đúng định dạng mong đợi.");
      } else {
        throw Exception("Lỗi API: ${response.statusCode} - $jsonResponse");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối API: $e");
    }
  }

}
