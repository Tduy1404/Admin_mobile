// class CustomerAccount {
//   final String id;
//   final String name;
//   final String email;
//   final String password;
//   final String phoneNumber;
//   final int age;
//
//   CustomerAccount({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.phoneNumber,
//     required this.age,
//   });
//
//   // Chuyển đổi từ JSON
//   factory CustomerAccount.fromJson(Map<String, dynamic> json) {
//     return CustomerAccount(
//       id: json['id'].toString(),
//       name: json['name'],
//       email: json['email'],
//       password: json['password'], // Mật khẩu cần mã hóa khi lưu thực tế
//       phoneNumber: json['phoneNumber'],
//       age: json['age'],
//     );
//   }
//
//   // Chuyển đổi thành JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'password': password,
//       'phoneNumber': phoneNumber,
//       'age': age,
//     };
//   }
// }
class CustomerAccount {
  final int id;
  final String name;
  final String email;
 final String password;
  final String phoneNumber;

  CustomerAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  factory CustomerAccount.fromJson(Map<String, dynamic> json) {
    return CustomerAccount(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

