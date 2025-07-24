import 'package:flutter/material.dart';
import 'reminder_screen.dart';

class MyHome extends StatelessWidget {
  const MyHome({
    super.key,
  });

// Home Page i guess
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Timer Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Reminder()),
              );
            },
            child: const Text('Check out reminder page'),
          ),
        ),
      );
  }
}