import 'package:flutter/material.dart';

// Timer configuration for individual apps within a session
class AppTimer {
  // App identification and display
  final String appName;
  final String appPackage;
  final IconData appIcon;
  
  // Timer settings
  final Duration reminderInterval;
  final bool isEnabled;
  final DateTime? lastReminder;

  // Constructor with default values
  const AppTimer({
    required this.appName,
    required this.appPackage,
    required this.appIcon,
    required this.reminderInterval,
    this.isEnabled = true,
    this.lastReminder,
  });

  // Create copy with modified properties (immutable pattern)
  AppTimer copyWith({
    String? appName,
    String? appPackage,
    IconData? appIcon,
    Duration? reminderInterval,
    bool? isEnabled,
    DateTime? lastReminder,
  }) {
    return AppTimer(
      appName: appName ?? this.appName,
      appPackage: appPackage ?? this.appPackage,
      appIcon: appIcon ?? this.appIcon,
      reminderInterval: reminderInterval ?? this.reminderInterval,
      isEnabled: isEnabled ?? this.isEnabled,
      lastReminder: lastReminder ?? this.lastReminder,
    );
  }

  // Check if reminder is overdue
  bool get isOverdue {
    if (lastReminder == null || !isEnabled) return false;
    final nextReminder = lastReminder!.add(reminderInterval);
    return DateTime.now().isAfter(nextReminder);
  }

  // Calculate when next reminder should be sent
  DateTime? get nextReminderTime {
    if (lastReminder == null || !isEnabled) return null;
    return lastReminder!.add(reminderInterval);
  }

  // Format interval for display (uses static helper)
  String get reminderIntervalDisplay {
    return AppTimer.intervalToDisplay(reminderInterval);
  }

  // Common timer intervals for UI selection
  static List<Duration> get commonIntervals => [
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
    const Duration(hours: 3),
    const Duration(hours: 6),
    const Duration(hours: 12),
  ];

  // Convert duration to user-friendly string (e.g., "2h 30m")
  static String intervalToDisplay(Duration interval) {
    final hours = interval.inHours;
    final minutes = interval.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}