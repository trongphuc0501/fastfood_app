// import 'package:fastfood/ADMIN/add.dart';
import 'package:fastfood/LOGIN/signin.dart';
import 'package:fastfood/TRANG%20CH%E1%BB%A6/hienthi.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'giohang.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;
  final List<dynamic> similarProducts;

  ProductDetailScreen({required this.product, required this.similarProducts});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes =
    product['img'] != null ? base64Decode(product['img']) : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: 'product_image_${product['id']}',
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
                  'Sản phẩm: ' + product['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Giá: ${product['price']} VND',
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
                        initialValue: '1',
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo'),
                              content: Text('Sản phẩm đã được thêm vào giỏ hàng.'),
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
                      child: Text('Thêm vào giỏ hàng'),
                    ),
                    ElevatedButton(
                      onPressed:  () {
                        // Thực hiện các hoạt động để đăng xuất tại đây
                        // Ví dụ: xóa dữ liệu phiên đăng nhập, đặt lại trạng thái, vv.

                        // Điều hướng đến màn hình đăng nhập (ThongTinScreen) sau khi đăng xuất
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ProductScreen()),
                              (route) => false,
                        );
                      }, child: Text('Giỏ hàng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //
          // SizedBox(height: 16.0),
          // Text(
          //   'Sản phẩm tương tự:',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 8),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: similarProducts.length,
          //     itemBuilder: (context, index) {
          //       final similarProduct = similarProducts[index];
          //       Uint8List? similarImageBytes =
          //       similarProduct['img'] != null ? base64Decode(similarProduct['img']) : null;
          //       return GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ProductDetailScreen(
          //                 product: similarProduct,
          //                 similarProducts: [],
          //               ),
          //             ),
          //           );
          //         },
          //         child: ListTile(
          //           title: Text(similarProduct['name']),
          //           subtitle: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('Giá: ${similarProduct['price']} VND'),
          //               Text('Số lượng: ${similarProduct['stock']}'),
          //             ],
          //           ),
          //           leading: Hero(
          //             tag: 'product_image_${similarProduct['id']}',
          //             child: similarImageBytes != null
          //                 ? Image.memory(
          //               similarImageBytes,
          //               width: 50,
          //               height: 50,
          //             )
          //                 : Container(),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
