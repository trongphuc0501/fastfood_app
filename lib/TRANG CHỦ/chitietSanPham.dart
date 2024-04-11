import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;
  final Function(dynamic) addToCart;

  ProductDetailScreen({required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes = product['img'] != null ? base64Decode(product['img']) : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: imageBytes != null ? Image.memory(imageBytes, fit: BoxFit.contain) : Container(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sản phẩm: ' + product['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Giá: ${product['price']} VND',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              addToCart(product); // Thêm sản phẩm vào giỏ hàng
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm vào giỏ hàng'),
                  action: SnackBarAction(
                    label: 'Xem giỏ hàng',
                    onPressed: () {
                      Navigator.pop(context); // Đóng màn hình chi tiết sản phẩm
                      Navigator.pushNamed(context, '/cart'); // Chuyển đến màn hình giỏ hàng
                    },
                  ),
                ),
              );
            },
            child: Text('Thêm vào giỏ hàng'),
          ),
        ],
      ),
    );
  }
}
