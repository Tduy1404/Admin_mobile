import 'package:flutter/material.dart';
import 'api_service.dart';
import 'BusRoute.dart';
import 'package:test2/ScreenDetail.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Routes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BusListScreen(),
    );
  }
}

// Screen to show list of bus routes
class BusListScreen extends StatefulWidget {
  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  late Future<List<BusRoute>> futureBusRoutes;

  @override
  void initState() {
    super.initState();
    futureBusRoutes = ApiService().fetchBusRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách tuyến xe')),
      body: FutureBuilder<List<BusRoute>>(
        future: futureBusRoutes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final busRoute = snapshot.data![index];
              return ListTile(
                title: Text(busRoute.routeName),
                subtitle: Text('ID: ${busRoute.routeId}'),
                leading: Icon(Icons.directions_bus),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusRouteDetailScreen(routeId: busRoute.routeId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}