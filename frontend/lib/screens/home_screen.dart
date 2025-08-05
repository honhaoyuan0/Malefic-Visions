import 'package:flutter/material.dart';
import 'reminder_screen.dart';
import 'analysis.dart';
import 'timer_screen.dart';
import '../global_widgets/bottom_nav_bar.dart';


class MyHome extends StatefulWidget {
  const MyHome({
    super.key,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int currentPageIndex = 0;

  // A function that builds the current page based on the index
  // This function is used to switch between different screens in the app
  // It returns a widget instead of an actual screen corresponding to the current page index
  // As replacing a widget is more efficient than replacing the entire screen
  // If the index is out of range, it defaults to HomeBody
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
      // Nav Bar widget that i've extracted as a global widget
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
        body: _buildPage(),
      );
  }
}

