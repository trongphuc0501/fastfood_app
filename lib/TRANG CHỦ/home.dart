import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chitietSanphamHome.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum ProductCategory { burger, drink, sandwich, spicyNoodle }

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  bool isAscending = true;
  bool sortByPriceAscending = true;
  ProductCategory selectedCategory = ProductCategory.burger; // Mặc định là burger
  String selectedType = ''; // Loại sản phẩm được chọn

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
        filteredProducts = data;
      });
    } else {
      print('Error calling API');
    }
  }

  void filterTypeProducts(String type) {
    setState(() {
      filteredProducts = products.where((product) {
        final String productType = product['type'].toString().toLowerCase();
        return productType == type.toLowerCase();
      }).toList();
      selectedType = type; // Cập nhật loại sản phẩm được chọn
    });
  }

  void filterProducts(String keyword) {
    setState(() {
      filteredProducts = products.where((product) {
        final String productName = product['name'].toString().toLowerCase();
        return productName.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  void sortProducts() {
    setState(() {
      if (isAscending) {
        filteredProducts.sort((a, b) => a['name'].compareTo(b['name']));
      } else {
        filteredProducts.sort((a, b) => b['name'].compareTo(a['name']));
      }
      isAscending = !isAscending;
    });
  }

  void sortProductsByPrice() {
    setState(() {
      if (sortByPriceAscending) {
        filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
      } else {
        filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
      }
      sortByPriceAscending = !sortByPriceAscending;
    });
  }

  void filterByCategory(ProductCategory category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = products
          .where((product) => product['category'] == category.toString().split('.').last)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitchen 20023'),
        actions: [
          IconButton(
            icon: Icon(isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined),
            onPressed: sortProducts,
          ),
          IconButton(
            icon: Icon(sortByPriceAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: sortProductsByPrice,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Radio<String>(
                      value: 'nước',
                      groupValue: selectedType,
                      onChanged: (String? value) {
                        filterTypeProducts(value!);
                      },
                    ),
                    Text('Nước'),
                  ],
                ),
                Column(
                  children: [
                    Radio<String>(
                      value: 'mỳ cay',
                      groupValue: selectedType,
                      onChanged: (String? value) {
                        filterTypeProducts(value!);
                      },
                    ),
                    Text('Mỳ cay'),
                  ],
                ),
                Column(
                  children: [
                    Radio<String>(
                      value: 'bánh mỳ',
                      groupValue: selectedType,
                      onChanged: (String? value) {
                        filterTypeProducts(value!);
                      },
                    ),
                    Text('Bánh mỳ'),
                  ],
                ),
                Column(
                  children: [
                    Radio<String>(
                      value: 'burger',
                      groupValue: selectedType,
                      onChanged: (String? value) {
                        filterTypeProducts(value!);
                      },
                    ),
                    Text('Burger'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                Uint8List? imageBytes =
                product['img'] != null ? base64Decode(product['img']) : null;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giá: ${product['price']}'),
                        Text('Kho: ${product['stock']}'),
                      ],
                    ),
                    leading: imageBytes != null
                        ? Image.memory(
                      imageBytes,
                      width: 50,
                      height: 50,
                    )
                        : Container(),
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
