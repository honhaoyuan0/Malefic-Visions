import 'package:flutter/material.dart';
import 'app_timer.dart';

// Represents a session context (e.g., "Work", "Sleep", "Going out with friends")
// Contains multiple app timers with different reminder intervals
class Session {
  // Session identification and display
  final String id;                    // Unique identifier
  final String name;                  // Display name (e.g., "Work time")
  final IconData icon;                // Icon for UI display
  
  // Session state and configuration
  final bool isActive;                // Whether this session is currently active
  final List<AppTimer> appTimers;     // List of apps with their timer settings
  
  // Usage tracking
  final DateTime? lastUsed;           // When session was last activated
  final int streakDays;               // Consecutive days using this session

  // Constructor with default values
  const Session({
    required this.id,
    required this.name,
    required this.icon,
    required this.isActive,
    required this.appTimers,
    this.lastUsed,
    this.streakDays = 0,
  });

  // Create copy with modified properties (immutable pattern)
  Session copyWith({
    String? id,
    String? name,
    IconData? icon,
    bool? isActive,
    List<AppTimer>? appTimers,
    DateTime? lastUsed,
    int? streakDays,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      appTimers: appTimers ?? this.appTimers,
      lastUsed: lastUsed ?? this.lastUsed,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  // Get total number of configured apps in this session
  int get appCount => appTimers.length;

  // Check if any app timers are enabled in this session
  bool get hasActiveApps => appTimers.any((timer) => timer.isEnabled);

  // Calculate time until next reminder for this session
  Duration? get nextReminderIn {
    if (!isActive || !hasActiveApps) return null;
    
    final now = DateTime.now();
    Duration? shortest;
    
    // Find the shortest time until next reminder across all enabled app timers
    for (final timer in appTimers) {
      if (timer.isEnabled && timer.lastReminder != null) {
        final nextReminder = timer.lastReminder!.add(timer.reminderInterval);
        final timeUntil = nextReminder.difference(now);
        
        if (timeUntil.isNegative) continue; // Skip overdue reminders
        
        if (shortest == null || timeUntil < shortest) {
          shortest = timeUntil;
        }
      }
    }
    
    return shortest;
  }
}