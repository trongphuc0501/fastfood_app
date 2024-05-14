import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function() onDelete; // Thêm trường onDelete để lưu trữ hàm callback

  UpdateProductScreen({required this.product, required this.onDelete});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product['name_product'];
    priceController.text = widget.product['price'].toString();
    quantityController.text = widget.product['quantity'].toString();
  }
  void deleteProduct() async {
    var url = Uri.parse('http://192.168.52.1:3000/carts/${widget.product['name_user']}/${widget.product['_id']}');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        // Xóa thành công
        //widget.onDelete(); // Gọi hàm callback để thông báo về việc xóa sản phẩm
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Xóa thành công!'),
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
        Navigator.pop(context, true); // Quay lại trang trước đó và cập nhật danh sách sản phẩm
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Xóa thất bại: ${widget.product['name_product']}/${widget.product['_id']}'),
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

  void updateProduct() async {
    var url = Uri.parse('http://192.168.52.1:3000/carts/${widget.product['name_user']}/${widget.product['_id']}');

    // Tạo một đối tượng Map chứa dữ liệu cần cập nhật
    Map<String, dynamic> data = {
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
              content: Text('Có lỗi xảy ra khi cập nhật số lượng sản phẩm'),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
              enabled: false,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              enabled: false,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // // Gửi yêu cầu cập nhật sản phẩm đến API
                // String productId = widget.product['_id'];
                // String name = nameController.text;
                // String price = priceController.text;
                // String quantity = quantityController.text;
                //
                // var response = await http.put(
                //   Uri.parse('http://192.168.52.1:3000/products/$productId'),
                //   body: {
                //     'name_product': name,
                //     'price': price,
                //     'quantity': quantity,
                //   },
                // );
                //
                // if (response.statusCode == 200) {
                //   // Cập nhật thành công
                //   Navigator.pop(context, true); // Quay lại trang trước đó và cập nhật danh sách sản phẩm
                // } else {
                //   // Có lỗi xảy ra
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau')),
                //   );
                // }
                updateProduct();
              },
              child: Text('Lưu thay đổi'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                deleteProduct(); // Gọi hàm xóa sản phẩm khi người dùng nhấn nút
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('Xóa sản phẩm'),
            ),


          ],
        ),
      ),
    );
  }
}
