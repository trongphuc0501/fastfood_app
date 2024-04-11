import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProductScreen extends StatefulWidget {
  final dynamic product;

  UpdateProductScreen({required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController gtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product['name'];
    priceController.text = widget.product['price'].toString();
    stockController.text = widget.product['stock'].toString();
    gtController.text = widget.product['gt'];
  }

  void updateProduct() async {
    // Code xử lý cập nhật sản phẩm
  }

  void deleteProduct() async {
    var url = Uri.parse('http://192.168.66.1:3000/products/${widget.product['id']}');

    try {
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        // Xóa thành công
        Navigator.pop(context, true); // Trở về màn hình trước và thông báo xóa thành công
      } else {
        // Xóa thất bại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Có lỗi xảy ra khi xóa sản phẩm: ${response.statusCode}'),
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
      }
    } catch (e) {
      // Lỗi khi thực hiện yêu cầu
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Có lỗi xảy ra khi thực hiện yêu cầu: $e'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật sản phẩm'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gtController,
              decoration: InputDecoration(labelText: 'Giới tính'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProduct,
              child: Text('Cập nhật sản phẩm'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteProduct,
              child: Text('Xóa sản phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}