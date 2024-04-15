import 'package:fastfood/ADMIN/HOMEADMIN.dart';
import 'package:flutter/material.dart';
//import 'LOGIN/signup.dart';
//import 'LOGIN/signin.dart';
import 'LOGIN/welcome.dart';
import 'TRANG CHỦ/SanPham.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng ký ứng dụng',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Màu sắc chủ đạo tối giản
        fontFamily: 'Arial', // Phông chữ cao cấp
      ),
      debugShowCheckedModeBanner: false,
      home: SanPhamne(),
    );
  }
}

