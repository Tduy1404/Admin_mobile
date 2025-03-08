import 'package:flutter/material.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome to Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Text(
                "Dashboard Content Here",
                style: Theme.of(context).textTheme.titleLarge,              ),
            ),
          ),
        ],
      ),
    );
  }
}
