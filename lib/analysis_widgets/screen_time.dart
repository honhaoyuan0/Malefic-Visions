import'package:flutter/material.dart';
import'package:malefic_visions/screens/screen_utils.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

class ScreenTime extends StatefulWidget {
  const ScreenTime({super.key});

  @override
  _ScreenTimeState createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  String totalScreenTime = '0h 0m'; // Placeholder for total screen time
  bool isLoading = true; // Loading state
  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
    return Container(
      padding: EdgeInsets.all(screen.width * 0.05),
      decoration : BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(26, 85, 81, 81)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: TextStyle(
              color: const Color.fromARGB(179, 250, 250, 250),
              fontSize: screen.width * 0.05,
            ),
          ),
        ],
      ),
    ); 
  }
}

// ============================================================
// Screen Time Manager - Handles both IOS and Android
// ============================================================
class ScreenTimeManager {
  static const String _keyScreenTime = 'screen_time';
  static const String _totalTimeKey = 'total_screen_time';
  static const String _lastUpdatedKey = 'last_date';
  static const String _platformKey = 'platform';

  static Timer? _sessionTimer;
  static DateTime? _sessionStart;

// ============================================================
// Main Methods
// ============================================================

//Get the total screen time for the current day
  static Future<Duration> getTotalScreenTime() async {
    if(Platform.isAndroid){
    return await _getAndroidScreenTime();
    } else if(Platform.isIOS){
      return await _getIOSScreenTime();
    }
  return Duration.zero;
}

//Setup tracking for screen time
static Future<void> initialize() async {
  if (Platform.isAndroid) {
    await _setupAndroidTracking();
  } else if (Platform.isIOS) {
    await _setupIOSTracking();
  }
}

// ============================================================
// IOS IMPLEMENTATION - Start and Stop Session Tracking manually
// ============================================================

//Start session tracking
static void startSession() async{
  if (Platform.isIOS) {
    await _startIOSSession();
  }
}

//Stop session tracking
static void stopSession() async {
  if (Platform.isIOS) {
    await _stopIOSSession();
  }
}

// ============================================================
// Android Implementation - Uses system usage stats
// ============================================================

static Future<void> _initializeAndroid() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_platformKey, 'android');
  }

static Future<Duration> _getAndroidScreenTimer() async {
// Mock data for demonstration purposes
return Duration(hours: 2, minutes: 30);
}

//============================================================
// IOS Implementation - Uses manual session tracking
// ============================================================

static Future<void> _initializeIOS() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_platformKey, 'ios');
}

static Future<void> _startIOSSession() async {
  _sessionStart = DateTime.now();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_sessionStartKey, _sessionStart!.millisecondsSinceEpoch);