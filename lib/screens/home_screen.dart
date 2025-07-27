import 'package:flutter/material.dart';
import 'reminder_screen.dart';
import 'analysis.dart';
import 'timer_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    super.key,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int currentPageIndex = 0;

  Widget _buildPage() {
    switch (currentPageIndex) {
      case 0:
        return TimerScreen();
      case 1:
        return ScreenTimeAnalysis();
      case 2:
        return Reminder();
      default:
        return TimerScreen(); // Default to TimerScreen if index is out of range
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nav Bar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.indigoAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_outlined),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics_outlined),
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_outlined),
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
        ],
      ),
        body: _buildPage(),
      );
  }
}

