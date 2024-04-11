import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<dynamic> cartItems;
  final Function(dynamic) removeFromCart;

  CartScreen({Key? key, required this.cartItems, required this.removeFromCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo một Map để lưu trữ số lượng của từng sản phẩm dựa trên tên sản phẩm
    Map<String, int> itemCounts = {};

    // Tính tổng giá trị giỏ hàng
    double total = 0;

    for (var item in cartItems) {
      String productName = item['name'];
      double productPrice = item['price'];

      // Nếu sản phẩm đã tồn tại trong giỏ hàng, tăng số lượng lên 1
      if (itemCounts.containsKey(productName)) {
        itemCounts[productName] = itemCounts[productName]! + 1;
      } else {
        itemCounts[productName] = 1;
      }

      // Cập nhật tổng giá trị giỏ hàng
      total += productPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: ListView.builder(
        itemCount: itemCounts.length,
        itemBuilder: (context, index) {
          String productName = itemCounts.keys.elementAt(index);
          int quantity = itemCounts.values.elementAt(index);

          return ListTile(
            title: Text(productName),
            subtitle: Text('Quantity: $quantity'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                // Gọi hàm removeFromCart với sản phẩm cần xóa
                var productToRemove = cartItems.firstWhere((item) => item['name'] == productName);
                removeFromCart(productToRemove);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total: $total',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
