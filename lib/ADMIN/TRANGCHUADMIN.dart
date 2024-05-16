import 'package:flutter/material.dart';
import '../LOGIN/signin.dart';
import 'add.dart';
import 'HOMEADMIN.dart';
import 'setting.dart';

class ADMIN extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ADMIN> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    ProductScreen(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_suggest),
              label: 'Tác vụ',
            ),
          ],
        ),
      ),
    );
  }
}