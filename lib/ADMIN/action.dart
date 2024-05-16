import 'dart:convert';
import 'package:fastfood/LOGIN/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<dynamic> users = [];
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchUsers();
  }

  Future<void> checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'x-access-token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.52.1:3000/users'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load users: $e');
    }
  }

  Future<void> clearSessionData() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'x-access-token');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài khoản'),
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
