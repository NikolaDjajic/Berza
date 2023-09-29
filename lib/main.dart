import 'package:crypto/View/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? username = "";
double? money = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializePreferences();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IO(),
    );
  }
}

void initializePreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username') ?? "";
  money = prefs.getDouble('money') ?? 0;
}

void updateMoney(double kes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('money', kes);
}

void updateUsername(String name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', name);
}
