import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProductKH extends StatefulWidget {
  final dynamic cart;

  UpdateProductKH({required this.cart});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductKH> {
  //TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //nameController.text = widget.product['name'];
    priceController.text = widget.cart['price'].toString();
    quantityController.text = widget.cart['quantity'].toString();
  }

  void updateProduct() async {
    var url = Uri.parse('http://192.168.52.1:3000/carts/${widget.cart['name_product']}');

    // Tạo một đối tượng Map chứa dữ liệu cần cập nhật
    Map<String, dynamic> data = {
      //'name': nameController.text,
      'price': double.parse(priceController.text),
      'quantity': int.parse(quantityController.text),
    };

    try {
      // Gửi yêu cầu cập nhật đến API bằng phương thức PUT
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Cập nhật thành công
        Navigator.pop(context, true); // Trở về màn hình trước và thông báo cập nhật thành công
      } else {
        // Cập nhật thất bại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Có lỗi xảy ra khi cập nhật sản phẩm: ${response.statusCode}'),
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


  void deleteProduct() async {
    //var encodedName = Uri.encodeComponent(widget.product['name']);
    //var url = Uri.parse('http://192.168.52.1:3000/products/$encodedName');

    var url = Uri.parse('http://192.168.52.1:3000/products/${widget.cart['name_product']}');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        // Xóa thành công
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ko Lỗi'),
              content: Text('Xóa thành công: ${widget.cart['name']}'),
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
        Navigator.pop(context, true); // Trở về màn hình trước và thông báo xóa thành công
      } else {
        // Xóa thất bại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Có lỗi xảy ra khi xóa sản phẩm: ${widget.cart['name']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
            // return AlertDialog(
            //   title: Text('Lỗi'),
            //   content: Text('Có lỗi xảy ra khi xóa sản phẩm: ${response.statusCode}'),
            //   actions: <Widget>[
            //     TextButton(
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //       child: Text('OK'),
            //     ),
            //   ],
            // );
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
              controller: priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
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
