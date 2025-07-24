import 'package:flutter/material.dart';
import 'analysis/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF243347),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF243347),
          centerTitle: true,
      ),
    ),
    color: const Color(0xFF243347),
      debugShowCheckedModeBanner: false,
      title: 'Malefic Visions',
      home: ScreenTimeAnalysis(),
    );
  }
}

