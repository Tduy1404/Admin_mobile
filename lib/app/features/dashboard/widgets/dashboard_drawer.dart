
import 'package:flutter/material.dart';
import 'package:project1/app/features/dashboard/screens/dashboard_screen.dart';
import 'package:project1/app/features/dashboard/screens/baiviet_screen.dart';
import 'package:project1/app/features/dashboard/screens/TripHistoryScreen.dart';
import 'package:project1/app/features/dashboard/screens/acount_management.dart';
import 'package:project1/app/features/dashboard/screens/customer_history.dart';
import 'package:project1/app/features/dashboard/screens/Bus_screen.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Đổi màu nền của toàn bộ danh sách
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrangeAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.departure_board_outlined, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "BUS MAP",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            _buildMenuItem(context, Icons.dashboard, "Dashboard", const DashboardScreen()),
            _buildMenuItem(context, Icons.person, "Account Management", const AccountManagementScreen()),
            _buildMenuItem(context, Icons.history, "Customer History", const TripHistoryScreen()),
            _buildMenuItem(context, Icons.add_card, "Advertising Information",  ArticleScreen()),
            _buildMenuItem(context, Icons.add_card, "Bus Information",  BusListScreen()),
            _buildMenuItem(context, Icons.logout, "Logout", null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget? page, {bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        onTap: () {
          if (isLogout) {
            // Xử lý đăng xuất
            Navigator.pop(context); // Đóng Drawer
            // Thêm logic đăng xuất ở đây (nếu có)
          } else if (page != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
      ),
    );
  }
}
