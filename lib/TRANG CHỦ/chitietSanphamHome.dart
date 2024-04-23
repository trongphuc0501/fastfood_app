import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'SanPham.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes =
    widget.product['img'] != null ? base64Decode(widget.product['img']) : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: 'product_image_${widget.product['id']}',
              child: imageBytes != null
                  ? Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              )
                  : Container(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sản phẩm: ' + widget.product['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Giá: ${widget.product['price']} VND',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Số lượng:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    // Text field for quantity input
                    Expanded(
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Button for adding to cart
                    ElevatedButton(
                      onPressed: () {
                        int quantity = int.tryParse(quantityController.text) ?? 1;
                        String userToken = 'your_user_token_here'; // Thay thế bằng token của người đăng nhập thực tế
                        addToCart(widget.product, quantity, userToken);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông Báo'),
                              content: Text('Thêm thành công'),
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SanPhamne()),
                              (route) => false,
                        );
                      },
                      child: Text('Thêm vào giỏ hàng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _getUserInfo() async {
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'x-access-token');

      if (token != null) {
        var response = await http.get(
          Uri.parse('http://192.168.52.1:3000/profile'),
          headers: {'x-access-token': token},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          String? username = data['user']['username'];
          return username;
        } else {
          print('Có lỗi xảy ra khi lấy thông tin người dùng');
          return null;
        }
      } else {
        print('Không tìm thấy token');
        return null;
      }
    } catch (e) {
      print('Có lỗi xảy ra: $e');
      return null;
    }
  }


  void addToCart(Map<String, dynamic> product, int quantity,
      String userToken) async {
    {
      try {
        // Lấy thông tin username của người đăng nhập
        //String? username = await getUsername(userToken);
        String? username = await _getUserInfo();

        if (username != null) {
          // Tạo một đối tượng chứa dữ liệu để gửi đi
          Map<String, dynamic> requestData = {
            'name_user': username,
            'quantity': quantity,
            'price': product['price'],
            'name_product': product['name']

          };

          // Gửi yêu cầu POST để thêm sản phẩm vào giỏ hàng
          final response = await http.post(
            Uri.parse('http://192.168.52.1:3000/cart'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestData),
          );

          // Kiểm tra xem yêu cầu đã thành công hay không
          if (response.statusCode == 200) {
            // Xử lý khi yêu cầu thành công
            print('Sản phẩm đã được thêm vào giỏ hàng.');
            print('Response: ${response.body}');
          } else {
            // Xử lý khi yêu cầu không thành công
            print('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng.');
            print('Error: ${response.body} ');
            print(username);
            print( quantity);
            print(product['price']);
            print(product['name']);
          }
        } else {
          print('Error: Username is null');
        }
      } catch (error) {
        // Xử lý khi có lỗi xảy ra trong quá trình gửi yêu cầu
        print('Có lỗi xảy ra: $error');
      }
    }
  }
}
