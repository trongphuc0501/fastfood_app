import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _DiaChiController = TextEditingController();


  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await http.post(
          Uri.parse('http://192.168.52.1:3000/signup'),
          body: {
            'username': _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'diachi': _DiaChiController.text,
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var token = data['token'];
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đăng ký thành công'),
              ),
          );
          print('Đăng ký thành công');
        } else {
          print('emai da ton tai');
          _emailController.clear();
        }
      } catch (e) {
        print('Có lỗi xảy ra: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người dùng';
                  }
                  return null;
                },

              ),


              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
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
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  } else if (value.length < 1) {
                    return 'Mật khẩu cần ít nhất ';
                  }
                  return null;
                },
              ),


              SizedBox(height: 16.0),
              TextFormField(
                controller: _DiaChiController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _signUp,
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}