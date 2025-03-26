import 'package:flutter/material.dart';
import 'package:project1/app/models/accounts.dart';
import 'package:project1/app/services/api_account.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:project1/app/features/dashboard/widgets/dashboard_drawer.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  _AccountManagementScreenState createState() => _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final ApiService apiService = ApiService();
  List<CustomerAccount> accounts = [];
  List<CustomerAccount> filteredAccounts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  void fetchAccounts() async {
    try {
      List<CustomerAccount> fetchedAccounts = await apiService.fetchAccounts();
      setState(() {
        accounts = fetchedAccounts;
        filteredAccounts = fetchedAccounts; // Hiển thị toàn bộ danh sách ban đầu
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  void filterAccounts(String query) {
    query = query.toLowerCase(); // Chuyển về chữ thường để tìm kiếm không phân biệt chữ hoa/thường
    setState(() {
      filteredAccounts = accounts.where((account) {
        final name = account.name?.toLowerCase() ?? ""; // Kiểm tra null
        final email = account.email?.toLowerCase() ?? "";
        final phone = account.phoneNumber?.toLowerCase() ?? "";

        print("🔍 Đang tìm: $query trong $name - $email - $phone"); // Debug

        return name.contains(query) || email.contains(query) || phone.contains(query);
      }).toList();
    });
  }


  void showAccountDetail(CustomerAccount account) {
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
              Text("👤 Tên: ${account.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(" Email: ${account.email}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("📧 Password: ${account.password}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("📞 Số điện thoại: ${account.phoneNumber ?? 'Không có'}", style: TextStyle(fontSize: 18)),
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Tìm kiếm theo tên, email hoặc số điện thoại",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: filterAccounts,
            ),
          ),
          Expanded(
            child: filteredAccounts.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredAccounts.length,
              itemBuilder: (context, index) {
                final account = filteredAccounts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(account.name[0])),
                    title: Text(account.name),
                    subtitle: Text("Email: ${account.email}"),
                    onTap: () {
                      showAccountDetail(account);
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