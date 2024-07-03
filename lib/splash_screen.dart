import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class SplashScreen extends  StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/loading.png',
        fit: BoxFit.cover,
      ),
      // body: Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     Image.asset(
      //       'assets/loading.png',
      //       fit: BoxFit.cover,
      //     ),
      //     Container(
      //       color: Colors.white.withOpacity(0.15),
      //     ),
      //     Center(
      //       child: Image.asset(
      //         'assets/applogo.png',
      //         width: 200,
      //         height: 200,
      //       )
      //     )
      //   ],
      // ),
    );
  }
}
