import 'dart:convert';
import 'package:fastfood/LOGIN/signin.dart';
import 'chitiet.dart';
import '../LOGIN/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              logout(); // Gọi hàm logout()
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
  void logout() async {
    try {
      // Thực hiện xóa dữ liệu phiên đăng nhập
      await clearSessionData();

      // Đặt lại trạng thái (nếu cần)
      resetAppState();

      // Hủy token đang lưu (nếu cần)
      await revokeToken();
    } catch (e) {
      print('Có lỗi xảy ra khi đăng xuất: $e');
    }
  }
  Future<void> clearSessionData() async {
    // Xóa dữ liệu phiên đăng nhập
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'x-access-token');
    // Hoặc xóa các dữ liệu phiên đăng nhập khác cần thiết
  }

  void resetAppState() {
    // Thực hiện đặt lại trạng thái của ứng dụng (nếu cần)
  }

  Future<void> revokeToken() async {
    // Hủy token đang lưu (nếu cần)
    // Thực hiện các yêu cầu API hoặc các hoạt động cụ thể để hủy token
  }
}