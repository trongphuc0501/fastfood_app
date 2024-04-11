import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fastfood/LOGIN/signin.dart';
class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.66.1:3000/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> signOut() async {
    // Thực hiện các thao tác cần thiết để đăng xuất tại đây
    // Ví dụ: xóa token, xoá dữ liệu người dùng địa phương, vv.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài khoản'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut(); // Gọi phương thức đăng xuất khi nút được nhấn
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignInPage()),
                      (Route<dynamic> route) => false); // Chuyển về màn hình đăng nhập và loại bỏ mọi màn hình còn lại khỏi ngăn xếp
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]['username']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${users[index]['email']}'),
                Text('Địa chỉ: ${users[index]['diachi']}'),
                Text('Chức vụ: ${users[index]['chucvu']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
