import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fastfood/ADMIN/HOMEADMIN.dart';
import 'package:fastfood/TRANG CHỦ/SanPham.dart';

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
      home: SplashScreen(), // Khởi động app với màn hình SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Đợi 3 giây sau đó chuyển đến màn hình SanPhamne
    Timer(Duration(seconds: 3), () {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SanPhamne()), // Chuyển đến màn hình SanPhamne
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff17b885),
                  Color(0xff153337),
                ]
            )
        ),
        child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200.0),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text('Fast Food',style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              const Text('Lựa chọn tin cây dành cho bạn',textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

              ))
            ]
        ),
      ),

    );
  }
}
