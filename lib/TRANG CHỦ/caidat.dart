import 'dart:convert';
import 'package:fastfood/LOGIN/signin.dart';
import 'chitiet.dart';
import '../LOGIN/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'x-access-token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  void logout() async {
    try {
      await clearSessionData();
      resetAppState();
      await revokeToken();
      setState(() {
        isLoggedIn = false;
      });
    } catch (e) {
      print('Có lỗi xảy ra khi đăng xuất: $e');
    }
  }

  Future<void> clearSessionData() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'x-access-token');
  }

  void resetAppState() {
    // Thực hiện đặt lại trạng thái của ứng dụng (nếu cần)
  }

  Future<void> revokeToken() async {
    // Hủy token đang lưu (nếu cần)
    // Thực hiện các yêu cầu API hoặc các hoạt động cụ thể để hủy token
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInformation()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('Thông tin về chúng tôi'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('FastFood'),
                    content: Text('"KITCHEN 2022" THAM VỌNG TRỞ THÀNH THƯƠNG HIỆU FAST FOOD ĐƯỢC YÊU THÍCH NHẤT VIỆT NAM',
                        textAlign: TextAlign.center),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.discount),
            title: Text('Voucher'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Thông tin'),
                    content: Text('Bạn hiện không có voucher!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent_outlined),
            title: Text('Hỗ trợ'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Thông tin liên hệ'),
                    content: Text('Liên hệ qua số 18006060 để được tư vấn.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Đăng xuất' : 'Đăng nhập'),
            onTap: () {
              if (isLoggedIn) {
                logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                      (route) => false,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
