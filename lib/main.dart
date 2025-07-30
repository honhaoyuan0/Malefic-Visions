import 'package:flutter/material.dart';
import 'package:malefic_visions/screens/permission_check_screen.dart';
import 'screens/screens.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Malefic Visions',
      theme: AppTheme.indigoTheme,
      home: PermissionCheckScreen(),
    );
  }
}
