import 'dart:convert';
import 'package:fastfood/TRANG%20CH%E1%BB%A6/SanPham.dart';
import 'package:fastfood/TRANG%20CH%E1%BB%A6/update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'order.dart'; // Import file orderService.dart

class ProductScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductScreen> {
  List<Map<String, dynamic>> cart = []; // Khai báo cart ở đây

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCart(); // Gọi fetchCart từ initState
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

  Future<void> fetchCart() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.52.1:3000/cart'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Map<String, dynamic>> updatedCart = [];

        String? username = await _getUserInfo();

        // Duyệt qua danh sách sản phẩm từ phản hồi
        for (var item in data) {
          // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng hay chưa
          bool existingProduct = false;
          if (item['name_user'] == username) { // Kiểm tra nếu sản phẩm trùng với username
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
        }

        setState(() {
          cart = updatedCart;
        });
      } else {
        print('Error calling cart API');
      }
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  int calculateTotalPrice() {
    int total = 0;
    for (int i = 0; i < cart.length; i++) {
      int price = int.tryParse(cart[i]['price'].toString()) ?? 0;
      int quantity = int.tryParse(cart[i]['quantity'].toString()) ?? 0;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    int total = calculateTotalPrice(); // Tính tổng giá tiền từ danh sách sản phẩm trong giỏ hàng

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart), // Icon giỏ hàng
            onPressed: () {
              // Thực hiện hành động khi người dùng nhấn vào icon giỏ hàng
              // Ví dụ: Navigator.push để điều hướng đến trang giỏ hàng
            },
          ),
        ],
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giá: ${item['price']}'),
                      Text('Số lượng: ${item['quantity']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProductScreen(product: item, onDelete: () {  },),
                        ),
                      ).then((value) {
                        if (value == true) {
                          // Nếu có thay đổi trên trang cập nhật sản phẩm, cập nhật lại giỏ hàng
                          fetchCart();
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Hiển thị tổng giá tiền
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              'Tổng giá tiền: $total VND',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Đặt bán kính cong ở đây
                color: Colors.brown, // Màu nền của nút
              ),
              child: TextButton(
                onPressed: () async {
                  await placeOrder(context, cart, total, _getUserInfo);
                },
                child: Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Màu chữ của nút
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
