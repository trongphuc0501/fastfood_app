// order.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteCartItems(BuildContext context, String nameUser) async {
  try {
    // Gửi yêu cầu xóa các sản phẩm trong giỏ hàng dựa trên name_user
    final response = await http.delete(
      Uri.parse('http://192.168.52.1:3000/cart/$nameUser'), // Thay đổi URL API tương ứng
    );

    if (response.statusCode == 200) {
      print('Xóa sản phẩm trong giỏ hàng thành công');

      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông Báo'),
            content: Text('Bạn đã thanh toán thành công'),
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
    } else {
      print('Có lỗi xảy ra khi xóa sản phẩm trong giỏ hàng');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi gửi yêu cầu xóa sản phẩm trong giỏ hàng: $e');
  }
}
Future<void> placeOrder(BuildContext context, List<Map<String, dynamic>> cart, int total, Future<String?> Function() getUserInfo) async {
  try {
    // Lấy thông tin người dùng hiện tại
    String? nameUser = await getUserInfo();

    if (nameUser != null) {
      // Gửi yêu cầu tạo đơn đặt hàng
      await createOrder(context, nameUser, cart, total);
    } else {
      print('Không thể lấy thông tin người dùng');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi thực hiện thanh toán: $e');
  }
}

Future<void> createOrder(BuildContext context, String nameUser, List<Map<String, dynamic>> cart, int total) async {
  try {
    final orderData = {
      'name_user': nameUser,
      'cart': cart,
      'total': total,
    };

    final response = await http.post(
      Uri.parse('http://192.168.52.1:3000/order'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
      // Hiển thị thông báo thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông Báo'),
            content: Text('Bạn đã thanh toán thành công'),
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
      // Xóa các sản phẩm trong giỏ hàng
      await deleteCartItems(context, nameUser);
    } else {
      print('Có lỗi xảy ra khi tạo đơn đặt hàng');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi gửi yêu cầu tạo đơn đặt hàng: $e');
  }
}



