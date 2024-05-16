import 'dart:convert';
import 'package:fastfood/LOGIN/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'action.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'x-access-token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  void logout() async {
    try {
      await clearSessionData();
      resetAppState();
      await revokeToken();
      setState(() {
        isLoggedIn = false;
      });
    } catch (e) {
      print('Có lỗi xảy ra khi đăng xuất: $e');
    }
  }

  Future<void> clearSessionData() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'x-access-token');
  }

  void resetAppState() {
    // Thực hiện đặt lại trạng thái của ứng dụng (nếu cần)
  }

  Future<void> revokeToken() async {
    // Hủy token đang lưu (nếu cần)
    // Thực hiện các yêu cầu API hoặc các hoạt động cụ thể để hủy token
  }

  Future<void> addVoucherToDatabase(String voucherCode) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.52.1:3000/voucher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name_voucher': voucherCode,
        }),
      );
      if (response.statusCode == 200) {
        print('Voucher added successfully');
      } else {
        print('Failed to add voucher: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to add voucher: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thao tác'),
        actions: [
          IconButton(
            icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
            onPressed: () {
              if (isLoggedIn) {
                logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                      (Route<dynamic> route) => false,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.discount),
            title: Text('Thêm voucher'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String voucherCode = '';
                  return AlertDialog(
                    title: Text('Thêm voucher'),
                    content: TextField(
                      decoration: InputDecoration(hintText: 'Nhập mã voucher'),
                      onChanged: (value) {
                        voucherCode = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          addVoucherToDatabase(voucherCode);
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Thao tác'),
            onTap: () {
              // Navigate to user management screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagement()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class UserManagement extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quản lý người dùng'),
//       ),
//       body: Center(
//         child: Text('Trang quản lý người dùng'),
//       ),
//     );
//   }
// }
