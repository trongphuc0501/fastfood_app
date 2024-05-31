import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  File? _imageFile;
  String? _base64Image;

  void _openImagePicker() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Quality of picked image
    );

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  Future<void> _convertImageToBase64() async {
    if (_imageFile != null) {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      setState(() {
        _base64Image = base64Encode(imageBytes);
      });
    }
  }

  void addProduct() async {
    String name = nameController.text;
    String priceString = priceController.text;
    String quantityString = quantityController.text;
    String typeString = typeController.text;

    // Kiểm tra xem các trường đã được nhập đủ hay không
    if (name.isEmpty ||
        priceString.isEmpty ||
        quantityString.isEmpty ||
        typeString.isEmpty ||
        _imageFile == null) {
      showErrorSnackBar('Vui lòng nhập đủ thông tin và chọn ảnh');
      return;
    }

    // Kiểm tra giá và số lượng không được là số âm
    double price = double.tryParse(priceString) ?? 0;
    int quantity = int.tryParse(quantityString) ?? 0;
    if (price <= 0 || quantity <= 0) {
      showErrorSnackBar('Giá và số lượng phải lớn hơn 0');
      return;
    }

    // Convert image to base64 before sending
    await _convertImageToBase64();

    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'stock': quantity,
      'type':typeString,
      'img': _base64Image, // Add image data to product data
    };

    var url = Uri.parse('http://192.168.52.1:3000/products');
    var headers = {"Content-Type": "application/json"};

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        // Thành công
        showSuccessSnackBar('Thêm sản phẩm thành công');
        nameController.clear();
        priceController.clear();
        quantityController.clear();
        typeController.clear();
      } else {
        // Lỗi
        showErrorSnackBar('Lỗi khi thêm sản phẩm: ${response.statusCode}');
      }
    } catch (e) {
      showErrorSnackBar('Lỗi khi thực hiện yêu cầu: $e');
    }
  }

  void showSuccessSnackBar(String message) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final overlay = Overlay
          .of(context)
          ?.context
          .findRenderObject() as RenderBox?;
      final snackbarHeight = 48.0;
      final topOffset = overlay!.size.height / 2.0 - snackbarHeight / 2.0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: topOffset),
        ),
      );
    });
  }

  void showErrorSnackBar(String message) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final overlay = Overlay
          .of(context)
          ?.context
          .findRenderObject() as RenderBox?;
      final snackbarHeight = 48.0;
      final topOffset = overlay!.size.height / 2.0 - snackbarHeight / 2.0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: topOffset),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Loại'),
            ),
            ElevatedButton(
              onPressed: _openImagePicker,
              child: Text('Chọn ảnh sản phẩm'),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text('Chưa chọn ảnh')
                : Image.file(
              _imageFile!,
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Thêm sản phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}
