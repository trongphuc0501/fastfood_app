import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final double price;
  final int stock;
  final Uint8List? imageBytes;

  const ProductDetailScreen({
    required this.name,
    required this.price,
    required this.stock,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageBytes != null
                ? Image.memory(
              imageBytes!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : SizedBox(), // Hiển thị hình ảnh nếu có
            SizedBox(height: 16),
            Text(
              'Tên sản phẩm: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Giá: $price'),
            SizedBox(height: 8),
            Text('Số lượng: $stock'),
          ],
        ),
      ),
    );
  }
}
