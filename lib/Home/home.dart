import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   final String email;
  const HomePage({super.key,required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text("Welcome Back $email!!",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),],),
      ),
    );

  }
  }