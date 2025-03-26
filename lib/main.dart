// import 'package:flutter/material.dart';
// import 'package:project1/app/features/dashboard/screens/dashboard_screen.dart';
// import 'package:project1/app/features/dashboard/screens/TripHistoryScreen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Admin Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home:  DashboardScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:project1/app/features/dashboard/screens/dashboard_screen.dart';
import 'package:project1/app/features/dashboard/screens/Welcome_Admin.dart'; // Import WelcomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(), // Bắt đầu từ WelcomeScreen
      routes: {
        '/dashboard': (context) => DashboardScreen(), // Định nghĩa route cho DashboardScreen
      },
    );
  }
}