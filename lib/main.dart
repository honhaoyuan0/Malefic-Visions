import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHome(),
    );
  }
}