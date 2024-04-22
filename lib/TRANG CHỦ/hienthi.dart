import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductScreen> {
  List<dynamic> cart = []; // Khai báo cart ở đây

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCart(); // Gọi fetchCart từ initState
  }

  // Future<void> fetchCart() async {
  //   final response = await http.get(Uri.parse('http://192.168.52.1:3000/cart'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     setState(() {
  //       cart = data;
  //     });
  //   } else {
  //     print('Error calling cart API');
  //   }
  // }
  Future<void> fetchCart() async {
    final response = await http.get(Uri.parse('http://192.168.52.1:3000/cart'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Tạo một danh sách tạm thời để lưu trữ sản phẩm trong giỏ hàng với quantity đã được cập nhật
      List<Map<String, dynamic>> updatedCart = [];

      // Duyệt qua danh sách sản phẩm từ phản hồi
      for (var item in data) {
        // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng hay chưa
        bool existingProduct = false;
        for (var existingItem in updatedCart) {
          if (existingItem['name_product'] == item['name_product']) {
            // Nếu sản phẩm đã tồn tại, cộng lại quantity
            existingItem['quantity'] += item['quantity'];
            existingProduct = true;
            break;
          }
        }
        // Nếu sản phẩm chưa tồn tại, thêm vào giỏ hàng
        if (!existingProduct) {
          updatedCart.add(item);
        }
      }

      // Cập nhật giỏ hàng với danh sách sản phẩm đã được cập nhật quantity
      setState(() {
        cart = updatedCart;
      });
    } else {
      print('Error calling cart API');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng nè'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text("Tên sản phẩm: ${item['name_product']}"),
                  subtitle: Text("Số lượng: ${item['quantity'].toString()}"),
                  // Hiển thị các thông tin khác của mỗi mục trong giỏ hàng nếu cần
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
