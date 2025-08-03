import 'package:flutter/material.dart';

// Represents an available app that can be selected for timer configuration
class App {
  // App identification and display properties
  final String name;           // Display name (e.g., "Instagram")
  final String package;        // Unique package identifier (e.g., "com.instagram.android")
  final IconData icon;         // Icon for UI display
  final bool isInstalled;      // Whether app is installed on device

  // Constructor with default installation status
  const App({
    required this.name,
    required this.package,
    required this.icon,
    this.isInstalled = true,
  });

  // Create copy with modified properties (immutable pattern)
  App copyWith({
    String? name,
    String? package,
    IconData? icon,
    bool? isInstalled,
  }) {
    return App(
      name: name ?? this.name,
      package: package ?? this.package,
      icon: icon ?? this.icon,
      isInstalled: isInstalled ?? this.isInstalled,
    );
  }

  // Override equality comparison (apps are equal if they have same package)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is App && other.package == package;
  }

  // Override hash code to match equality implementation
  @override
  int get hashCode => package.hashCode;

  // Mock data for development (in production, get from device app list)
  static List<App> get mockInstalledApps => [
    const App(
      name: 'Instagram',
      package: 'com.instagram.android',
      icon: Icons.camera_alt,
    ),
    const App(
      name: 'TikTok',
      package: 'com.tiktok.android',
      icon: Icons.music_video,
    ),
    const App(
      name: 'YouTube',
      package: 'com.google.android.youtube',
      icon: Icons.play_circle,
    ),
    const App(
      name: 'Facebook',
      package: 'com.facebook.katana',
      icon: Icons.facebook,
    ),
    const App(
      name: 'Twitter',
      package: 'com.twitter.android',
      icon: Icons.alternate_email,
    ),
    const App(
      name: 'Snapchat',
      package: 'com.snapchat.android',
      icon: Icons.camera,
    ),
    const App(
      name: 'WhatsApp',
      package: 'com.whatsapp',
      icon: Icons.message,
    ),
    const App(
      name: 'Telegram',
      package: 'org.telegram.messenger',
      icon: Icons.send,
    ),
    const App(
      name: 'Reddit',
      package: 'com.reddit.frontpage',
      icon: Icons.reddit,
    ),
    const App(
      name: 'Netflix',
      package: 'com.netflix.mediaclient',
      icon: Icons.movie,
    ),
  ];
}