import 'package:flutter/material.dart';

// =============================================================================
// APP SELECTION SCREEN - Allows users to select apps for timer reminders
// =============================================================================

class AppSelectionScreen extends StatefulWidget {
  // Data received from timer screen
  final List<String> selectedApps;        // Apps already selected by user
  final Function(List<String>) onAppsSelected;  // Callback to send results back

  const AppSelectionScreen({
    super.key,
    required this.selectedApps,
    required this.onAppsSelected,
  });

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

// =============================================================================
// STATE CLASS - Manages the screen's data and user interactions
// =============================================================================

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  // Working copy of selected apps (modified as user checks/unchecks)
  late List<String> currentSelectedApps;

  // =============================================================================
  // MOCK DATA - List of available apps (in real app, get from device)
  // =============================================================================
  final List<Map<String, dynamic>> installedApps = [
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'package': 'com.instagram.android'},
    {'name': 'TikTok', 'icon': Icons.music_video, 'package': 'com.tiktok.android'},
    {'name': 'YouTube', 'icon': Icons.play_circle, 'package': 'com.google.android.youtube'},
    {'name': 'Facebook', 'icon': Icons.facebook, 'package': 'com.facebook.katana'},
    {'name': 'Twitter', 'icon': Icons.alternate_email, 'package': 'com.twitter.android'},
    {'name': 'Snapchat', 'icon': Icons.camera, 'package': 'com.snapchat.android'},
    {'name': 'WhatsApp', 'icon': Icons.message, 'package': 'com.whatsapp'},
    {'name': 'Telegram', 'icon': Icons.send, 'package': 'org.telegram.messenger'},
    {'name': 'Reddit', 'icon': Icons.reddit, 'package': 'com.reddit.frontpage'},
    {'name': 'Netflix', 'icon': Icons.movie, 'package': 'com.netflix.mediaclient'},
  ];

  // =============================================================================
  // INITIALIZATION - Set up the screen when it first loads
  // =============================================================================
  @override
  void initState() {
    super.initState();
    // Create working copy of selected apps so we can modify without affecting original
    currentSelectedApps = List.from(widget.selectedApps);
  }

  // =============================================================================
  // UI BUILD METHOD - Creates the visual interface
  // =============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =============================================================================
      // APP BAR - Top section with title, back button, and Done button
      // =============================================================================
      appBar: AppBar(
        title: const Text(
          'Select Apps',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Done button - saves selections and returns to timer screen
          TextButton(
            onPressed: () {
              // Send final selections back to timer screen
              widget.onAppsSelected(currentSelectedApps);
              // Close this screen and return to previous screen
              Navigator.pop(context);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      // =============================================================================
      // MAIN BODY - Contains instruction text and scrollable app list
      // =============================================================================
      body: SafeArea(
        child: Column(
          children: [
            // =============================================================================
            // INSTRUCTION HEADER - Tells user what to do
            // =============================================================================
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Select apps to receive reminders for:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
            ),
            // =============================================================================
            // SCROLLABLE APP LIST - Shows all available apps with checkboxes
            // =============================================================================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: installedApps.length,
                itemBuilder: (context, index) {
                  // Get app data for this list position
                  final app = installedApps[index];
                  // Check if this app is currently selected
                  final isSelected = currentSelectedApps.contains(app['name']);

                  // =============================================================================
                  // INDIVIDUAL APP ROW - Container with app info and checkbox
                  // =============================================================================
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                          ? Colors.deepPurple 
                          : Colors.white.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    // =============================================================================
                    // LIST TILE - Contains app icon, name, and checkbox
                    // =============================================================================
                    child: ListTile(
                      // App icon with purple background
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          app['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      // App name display
                      title: Text(
                        app['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Checkbox for selection state
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              // Add app to selected list
                              currentSelectedApps.add(app['name']);
                            } else {
                              // Remove app from selected list
                              currentSelectedApps.remove(app['name']);
                            }
                          });
                        },
                        activeColor: Colors.deepPurple,
                        checkColor: Colors.white,
                      ),
                      // Allow tapping anywhere on row to toggle selection
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            currentSelectedApps.remove(app['name']);
                          } else {
                            currentSelectedApps.add(app['name']);
                          }
                        });
                      },
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
