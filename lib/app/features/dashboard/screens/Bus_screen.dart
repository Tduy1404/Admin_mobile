import 'package:flutter/material.dart';
import 'package:project1/app/services/api_service.dart'; // Giả sử đây là file chứa ApiService
// import 'BusRoute.dart'; // Giả sử đây là model cho BusRoute
import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_footer.dart';
import 'package:project1/app/features/dashboard/screens/BusRouteDetailScreen.dart'; // Giả sử đây là màn hình chi tiết
import 'package:project1/app/models/bus_route.dart';

// Màn hình hiển thị danh sách chuyến xe
class BusListScreen extends StatefulWidget {
  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<BusRoute>> futureBusRoutes;
  final ApiService apiService = ApiService(); // Khởi tạo ApiService

  @override
  void initState() {
    super.initState();
    futureBusRoutes = apiService.fetchBusRoutes(); // Lấy dữ liệu từ API
  }

  // Hàm làm mới danh sách
  void _refreshBusRoutes() {
    setState(() {
      futureBusRoutes = apiService.fetchBusRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      // appBar: AppBar(
      //   title: Text('Danh sách tuyến xe'),
      //   centerTitle: true,
      // ),
      body: FutureBuilder<List<BusRoute>>(
        future: futureBusRoutes,
        builder: (context, snapshot) {
          // Đang tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Có lỗi xảy ra
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${snapshot.error}'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshBusRoutes,
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          // Không có dữ liệu
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu chuyến xe'));
          }

          // Hiển thị danh sách chuyến xe
          final busRoutes = snapshot.data!;
          return ListView.builder(
            itemCount: busRoutes.length,
            itemBuilder: (context, index) {
              final busRoute = busRoutes[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.directions_bus, color: Colors.blue),
                  title: Text(
                    busRoute.routeName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${busRoute.routeId}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusRouteDetailScreen(routeId: busRoute.routeId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshBusRoutes,
        child: Icon(Icons.refresh),
        tooltip: 'Làm mới danh sách',
      ),
    );
  }
}