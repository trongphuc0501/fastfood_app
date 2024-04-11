import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

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
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Sản phẩm tương tự:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                final similarProduct = similarProducts[index];
                Uint8List? similarImageBytes =
                similarProduct['img'] != null ? base64Decode(similarProduct['img']) : null;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: similarProduct,
                          similarProducts: [],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(similarProduct['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giá: ${similarProduct['price']} VND'),
                        Text('Số lượng: ${similarProduct['stock']}'),
                      ],
                    ),
                    leading: Hero(
                      tag: 'product_image_${similarProduct['id']}',
                      child: similarImageBytes != null
                          ? Image.memory(
                        similarImageBytes,
                        width: 50,
                        height: 50,
                      )
                          : Container(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
