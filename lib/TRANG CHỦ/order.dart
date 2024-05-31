import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteCartItems(BuildContext context, String nameUser) async {
  try {
    final response = await http.delete(
      Uri.parse('http://192.168.52.1:3000/cart/$nameUser'),
    );

    if (response.statusCode == 200) {
      print('Xóa sản phẩm trong giỏ hàng thành công');
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

Future<void> placeOrder(BuildContext context, List<Map<String, dynamic>> cart, int total, Future<String?> Function() getUserInfo, String address,String phone_number) async {
  try {
    String? nameUser = await getUserInfo();

    if (nameUser != null) {
      await createOrder(context, nameUser, cart, total, address,phone_number);
    } else {
      print('Không thể lấy thông tin người dùng');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi thực hiện thanh toán: $e');
  }
}

Future<void> createOrder(BuildContext context, String nameUser, List<Map<String, dynamic>> cart, int total, String address, String phone_number) async {
  try {
    final orderData = {
      'name_user': nameUser,
      'cart': cart,
      'total': total,
      'phone_number':phone_number,
      'address': address, // Thêm địa chỉ vào dữ liệu đơn đặt hàng
    };

    final response = await http.post(
      Uri.parse('http://192.168.52.1:3000/order'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
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
      await deleteCartItems(context, nameUser);
    } else {
      print('Có lỗi xảy ra khi tạo đơn đặt hàng');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi gửi yêu cầu tạo đơn đặt hàng: $e');
  }
}
