import 'package:flutter/material.dart';
import 'reminder_screen.dart';
import 'analysis.dart';

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
        return HomeBody();
      case 1:
        return ScreenTimeAnalysis();
      case 2:
        return Reminder();
      default:
        return HomeBody(); // Default to HomeBody if index is out of range
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

// Home Page Body
class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to the Home Screen!',
            style: TextStyle(fontSize: 24),
          ),
          const Text("Commi get to work bij")
        ],
      ),
    );
  }
}