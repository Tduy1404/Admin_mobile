import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DashboardAppBar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(


      backgroundColor: Colors.teal[300],
            elevation: 2, // Đổ bóng nhẹ
      title: Row(
        children: [
          const Icon(Icons.departure_board_outlined, size: 30, color: Colors.lightGreen),
          const SizedBox(width: 10), // Khoảng cách giữa icon và text
          const Text(
            "BUS MAP",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.notifications,color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
