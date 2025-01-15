import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity1 = 0.0;
  double _opacity2 = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _opacity1 = 1.0;
      });
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity2 = 1.0;
      });
    });
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity1,
              duration: Duration(seconds: 1),
              child: Image.asset('images/logo_splash.png'),
            ),
            SizedBox(height: 3),
            AnimatedOpacity(
              opacity: _opacity2,
              duration: Duration(seconds: 2),
              child: Image.asset('images/slogan.png'),
            ),
          ],
        ),
      ),
    );
  }
}
