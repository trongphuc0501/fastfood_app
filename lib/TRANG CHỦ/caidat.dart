import 'dart:convert';
import 'package:fastfood/LOGIN/signin.dart';
import 'chitiet.dart';
import '../LOGIN/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Thông tin tài khoản'),
            onTap: () {
              // Điều hướng đến màn hình xem thông tin tài khoản
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInformation()),
              );

            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Giỏ hàng'),
            onTap: () {
              // Điều hướng đến màn hình xem thông tin tài khoản
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UserInformation()),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              // Thực hiện các hoạt động để đăng xuất tại đây
              // Ví dụ: xóa dữ liệu phiên đăng nhập, đặt lại trạng thái, vv.

              // Điều hướng đến màn hình đăng nhập (ThongTinScreen) sau khi đăng xuất
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}