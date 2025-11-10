import 'package:asset_management_app/layout/mian_layout.dart';
import 'package:asset_management_app/screens/auth/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  home: Login()
      home: MianLayout(),
    );
  }
}
