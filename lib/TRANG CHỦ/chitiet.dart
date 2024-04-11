import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String? email;
  String? address;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    // Thực hiện yêu cầu GET để lấy thông tin người dùng từ máy chủ
    var url = Uri.parse('http://192.168.66.1:3000/signup');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          email = data['email'];
          address = data['address'];
        });
      } else {
        print('Lỗi khi gửi yêu cầu GET: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi thực hiện yêu cầu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${email ?? 'Chưa có email'}'),
            SizedBox(height: 20),
            Text('Địa chỉ: ${address ?? 'Chưa có địa chỉ'}'),
          ],
        ),
      ),
    );
  }
}
