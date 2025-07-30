import 'package:flutter/material.dart';
import 'screen_utils.dart';

class ScreenTimeBreakdown extends StatefulWidget {
  const ScreenTimeBreakdown({super.key});

  @override
  State<ScreenTimeBreakdown> createState() => _ScreenTimeBreakdownState();
}

class _ScreenTimeBreakdownState extends State<ScreenTimeBreakdown> {
  // Mock data for screen time breakdown
  final List<Map<String, dynamic>> apps = [
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'time': '1h 20m'},
    {'name': 'TikTok', 'icon': Icons.music_video, 'time': '45m'},
    {'name': 'YouTube', 'icon': Icons.play_circle, 'time': '2h 15m'},
    {'name': 'Facebook', 'icon': Icons.facebook, 'time': '50m'},
    {'name': 'Twitter', 'icon': Icons.alternate_email, 'time': '30m'},
    {'name': 'Snapchat', 'icon': Icons.camera, 'time': '20m'},
    {'name': 'WhatsApp', 'icon': Icons.message, 'time': '1h'},
    {'name': 'Telegram', 'icon': Icons.send, 'time': '25m'},
    {'name': 'Reddit', 'icon': Icons.reddit, 'time': '35m'},
    {'name': 'Netflix', 'icon': Icons.movie, 'time': '1h 10m'},
  ];

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    return Scaffold(
      // App Bar - with back button and Title
      appBar: AppBar(
        title: Text(
          'Breakdown',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // Main Body - screen time breakdown for each app
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screen.topPadding * 0.25,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screen.width * 0.04,
                      vertical: screen.height * 0.017,
                    ),

                    //Box deco with gradient - to match with the app theme
                    decoration: BoxDecoration(
                     gradient: LinearGradient(
                      colors: [
                            Color(0xFF303F9F), //Darker indigo
                            Color(0xFF5C6BC0), // Lighter indigo
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                      
                     ),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    //Information within the box - app icon, app name and screen time
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Left side - App icon and name
                            Icon(
                              app['icon'],
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              app['name'],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        // Right side - Mock Screen Time
                        Text(
                          app['time'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
