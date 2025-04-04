
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project1/app/models/bus_route.dart';
import 'package:project1/app/models/BusRouteDetail.dart';

class ApiService {
  static const String apiUrl = 'http://apicms.ebms.vn/businfo';

  Future<List<BusRoute>> fetchBusRoutes() async {
    final response = await http.get(Uri.parse('$apiUrl/getallroute'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => BusRoute.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bus routes');
    }
  }
  Future<BusRouteDetail> fetchBusRouteDetail(String routeId) async {
    final response = await http.get(Uri.parse('$apiUrl/getroutebyid/$routeId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return BusRouteDetail.fromJson(data);
    } else {
      throw Exception('Failed to load bus route details');
    }
  }

}
// tôi muốn dùng api này để tích hợp vào chức năng của customer_history

