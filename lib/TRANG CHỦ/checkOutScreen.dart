import 'package:flutter/material.dart';
import 'SanPham.dart';
import 'order.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final int total;
  final Future<String?> Function() getUserInfo;

  CheckoutScreen({required this.cart, required this.total, required this.getUserInfo});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController voucherController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phone_numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: voucherController,
              decoration: InputDecoration(
                labelText: 'Nhập mã voucher',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Nhập địa chỉ',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phone_numberController,
              decoration: InputDecoration(
                labelText: 'Nhập số điện thoại',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tổng giá tiền: ${widget.total} VND',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await placeOrder(context, widget.cart, widget.total, widget.getUserInfo, addressController.text,phone_numberController.text);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SanPhamne()),
                      (route) => false,
                );
              },
              child: Text('Xác nhận thanh toán'),
            ),
          ],
        ),
      ),
    );
  }
}
