import 'package:flutter/material.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_footer.dart';
import 'package:project1/app/services/api_service.dart';
import 'package:project1/app/models/bus_route.dart';

class CustomerHistoryScreen extends StatefulWidget {
  const CustomerHistoryScreen({Key? key}) : super(key: key);

  @override
  _CustomerHistoryScreenState createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService apiService = ApiService();

  List<BusRoute> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // Gọi API để lấy danh sách tuyến xe khách hàng đã xem
  Future<void> _fetchHistory() async {
    try {
      List<BusRoute> routes = await apiService.fetchBusRoutes();
      setState(() {
        historyList = routes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Lỗi tải lịch sử: $e");
    }
  }

  // Xóa một tuyến xe khỏi danh sách
  void _deleteHistory(int index) {
    setState(() {
      historyList.removeAt(index);
    });
  }

  // Xem chi tiết tuyến xe bằng API
  void _viewDetails(String routeId, String routeName) async {
    try {
      final routeDetail = await apiService.fetchBusRouteDetail(routeId);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Chi tiết tuyến $routeName"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("🚏 Lộ trình đi:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(routeDetail.inboundDescription, style: TextStyle(color: Colors.blue)),
                SizedBox(height: 10),
                Text("🚌 Lộ trình về:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(routeDetail.outboundDescription, style: TextStyle(color: Colors.green)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Lỗi tải chi tiết tuyến: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : historyList.isEmpty
                ? const Center(child: Text("Không có lịch sử sử dụng", style: TextStyle(fontSize: 18)))
                : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item.routeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Mã tuyến: ${item.routeId}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                          onPressed: () => _viewDetails(item.routeId, item.routeName),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteHistory(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const DashboardFooter(),
        ],
      ),
    );
  }
}
