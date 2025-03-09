import 'package:flutter/material.dart';
import 'RouterDetail.dart';
import 'api_service.dart';
class BusRouteDetailScreen extends StatelessWidget {
  final String routeId;

  BusRouteDetailScreen({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết tuyến xe')),
      body: FutureBuilder<BusRouteDetail>(
        future: ApiService().fetchBusRouteDetail(routeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          }

          final routeDetail = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên tuyến: ${routeDetail.routeName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Lộ trình lượt đi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(routeDetail.inboundDescription),
                SizedBox(height: 10),
                Text('Lộ trình lượt về:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(routeDetail.outboundDescription),
              ],
            ),
          );
        },
      ),
    );
  }
}
