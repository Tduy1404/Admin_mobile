import 'package:flutter/material.dart';

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
                  SizedBox(height: 10), // Khoảng cách giữa icon và text
                  Text(
                    "BUS MAP",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            _buildMenuItem(Icons.dashboard, "Dashboard", () {}),
            _buildMenuItem(Icons.person, "Account Management", () {}),
            _buildMenuItem(Icons.history, "Customer History", () {}),
            _buildMenuItem(Icons.add_card, "Advertising Information", () {}),
            _buildMenuItem(Icons.logout, "Logout", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        onTap: onTap,
      ),
    );
  }
}
