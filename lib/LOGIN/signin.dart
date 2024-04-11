import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fastfood/ADMIN/TRANGCHUADMIN.dart';
import 'package:fastfood/TRANG CHỦ/caidat.dart';
import 'package:fastfood/TRANG CHỦ/SanPham.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  final storage = FlutterSecureStorage();

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        var response = await http.post(
          Uri.parse('http://192.168.52.1:3000/signin'),

          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var token = data['token'];

          // Kiểm tra giá trị của email và điều hướng dựa trên kết quả
          if (_emailController.text == 'b' && _passwordController.text == 'b') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ADMIN()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SanPhamne()),
            );
          }
        } else if (response.statusCode == 401) {
          print('Sai thông tin đăng nhập');
        } else {
          print('Có lỗi xảy ra khi đăng nhập');
        }
      } catch (e) {
        print('Có lỗi xảy ra: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading ? null : _signIn,
                child: isLoading
                    ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.0,
                  ),
                )
                    : Text('Đăng nhập'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SignUpPage()), // Thay SignUpScreen() bằng màn hình đăng ký thực tế của bạn
                  );
                },
                child: Text("Bạn chưa có tài khoản? Đăng ký qua Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
