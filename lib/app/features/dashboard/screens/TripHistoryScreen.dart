import 'package:flutter/material.dart';
import 'package:project1/app/models/trip_history.dart';
import 'package:project1/app/services/api_trip.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiTripService apiTripService = ApiTripService();

  List<TripHistory> tripHistoryList = []; // Danh sách gốc
  List<TripHistory> filteredList = []; // Danh sách đã lọc
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTripHistory();
  }

  void fetchTripHistory() async {
    try {
      List<TripHistory> fetchedTrips = await apiTripService.fetchTrips();
      setState(() {
        tripHistoryList = fetchedTrips;
        filteredList = fetchedTrips; // Mặc định hiển thị toàn bộ
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  // Hàm lọc dữ liệu theo tên khách hàng hoặc busNumber
  void filterTrips(String query) {
    setState(() {
      filteredList = tripHistoryList.where((trip) {
        final customerName = trip.customerName.toLowerCase();
        final busNumber = trip.busNumber.toLowerCase();
        final input = query.toLowerCase();
        return customerName.contains(input) || busNumber.contains(input);
      }).toList();
    });
  }

  void showTripDetail(TripHistory trip) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🚌 Chuyến xe: ${trip.busNumber}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Tên: ${trip.customerName}", style: TextStyle(fontSize: 18)),
              Text("📍 Điểm đi: ${trip.startLocation}", style: TextStyle(fontSize: 18)),
              Text("📍 Điểm đến: ${trip.endLocation}", style: TextStyle(fontSize: 18)),
              Text("⏱ Bắt đầu: ${trip.startTime}", style: TextStyle(fontSize: 18)),
              Text("⌛ Thời gian: ${trip.duration ?? 'Chưa có'} phút", style: TextStyle(fontSize: 18)),
              Text("💰 Giá vé: ${trip.fare} VND", style: TextStyle(fontSize: 18)),
              Text("💳 Trạng thái: ${trip.paymentStatus}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Đóng"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          // Ô nhập tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Tìm kiếm theo tên khách hàng hoặc số xe",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: filterTrips,
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final trip = filteredList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")), // Số thứ tự
                    title: Text("${trip.startLocation} ➝ ${trip.endLocation}"),
                    subtitle: Text("Tên: ${trip.customerName}\nBắt đầu: ${trip.startTime}"),
                    onTap: () {
                      showTripDetail(trip);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
