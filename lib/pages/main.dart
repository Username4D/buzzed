import 'package:flutter/material.dart';
import '../home.dart' as home;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget current_window = home.HomeScreen();

  Widget build(BuildContext context) {
    return MaterialApp(
      home: current_window
    );
  }
}