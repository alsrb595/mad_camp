import 'package:flutter/material.dart';
import 'main.dart';

void main(){
  runApp(MyApp());
}

class PhoneTab extends StatelessWidget {
  const PhoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Phone Number???"),
          ),
        )
    );
  }
}