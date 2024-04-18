import 'package:fastfood/LOGIN/signup.dart';
import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff17b885),
                  Color(0xff153337),
                ]
            )
        ),
        child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200.0),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text('FastFood App',style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 30,),
            ]
        ),
      ),

    );
  }
}
