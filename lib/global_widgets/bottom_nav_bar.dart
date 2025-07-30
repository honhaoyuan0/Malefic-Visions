import 'package:flutter/material.dart';
export 'bottom_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onDestinationSelected;

  // Constructor to initialize the current index and the callback function
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Colors.indigoAccent,
      selectedIndex: currentIndex,
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
      ]
    );
  }
}
