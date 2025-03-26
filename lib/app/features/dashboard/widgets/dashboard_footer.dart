import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade200,
      child: const Center(
        child: Text(
          "© 2024 Your Company - All Rights Reserved",
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
