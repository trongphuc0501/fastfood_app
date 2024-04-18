import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String? email;
  String? address;
  String? username;
  String? role;

  Future<void> _getUserInfo() async {
    try {
      final storage = FlutterSecureStorage();
      //String? token = await storage.read(key: 'token');
      String? token = await storage.read(key: 'x-access-token');


      if (token != null) {
        var response = await http.get(
          Uri.parse('http://192.168.52.1:3000/profile'),
          headers: {'x-access-token': token},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          //var username = data['user']['username'];
          setState(() {
            email = data['user']['email'];
            address = data['user']['diachi'];
            username = data['user']['username'];
            role = data['user']['chucvu'];
          });
        } else {
          print('Có lỗi xảy ra khi lấy thông tin người dùng');
        }
      } else {
        print('Không tìm thấy token');
      }
    } catch (e) {
      print('Có lỗi xảy ra: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
            if(username == null||username!.isEmpty)
              Text('Hãy đăng nhập!',style: TextStyle(
                fontSize: 40,
              ),),
            if(username != null)
              Container(
                child: Column(
                  children: [
                    Text('UserName: ${username}',
                      style: TextStyle(
                        fontSize: 30,
                    ),),
                    SizedBox(height: 20),
                    Text('Role: ${role}',
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                    SizedBox(height: 20),
                    Text('Email: ${email}',
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                    SizedBox(height: 20),
                    Text('Địa chỉ: ${address}',
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                  ],
                ),
              ),
          ],
        ),
      ),

    );
  }
}
