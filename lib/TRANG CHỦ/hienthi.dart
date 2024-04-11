import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chitietSanPham.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductScreen> {
  List<dynamic> products = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://192.168.52.1:3000/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data;
      });
    } else {
      print('Error calling API');
    }
  }

  void addToCart(dynamic product) {
    // Hàm thêm sp ào giỏ hàng
    print('Sản phẩm đã được thêm vào giỏ hàng: ${product['name']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {

              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ], // Loại bỏ dấu ) này
      ),
    );
  }

}
