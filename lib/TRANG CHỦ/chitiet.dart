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
    var url = Uri.parse('http://192.168.52.1:3000/users');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Lấy thông tin từ người dùng đầu tiên trong danh sách
        var firstUser = data[1]; // Đây là người dùng đầu tiên trong danh sách

        setState(() {
          email = firstUser['email'];
          address = firstUser['diachi'];
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
            Text('Email: ${email ?? 'Chưa có email1'}'),
            SizedBox(height: 20),
            Text('Địa chỉ: ${address ?? 'Chưa có địa chỉ'}'),
          ],
        ),
      ),
    );
  }
}
