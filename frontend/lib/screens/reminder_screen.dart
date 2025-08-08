import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:malefic_visions/services/overlay_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReminderOverlay extends StatefulWidget {
  const ReminderOverlay({super.key});

  @override
  State<ReminderOverlay> createState() => _ReminderOverlayState();
}

class _ReminderOverlayState extends State<ReminderOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  // State variables for API response
  String _reminderMessage = "Your attention is precious 💎\nLet's invest it wisely";
  bool _isLoading = true;
  int timerInSeconds = 180;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
    
    // Make POST request when screen loads
    _fetchReminderMessage();
  }

  // Method to fetch reminder message from backend
  Future<void> _fetchReminderMessage() async {
    print("🔥 _fetchReminderMessage called!"); // Debug print
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // print("🌐 Making POST request to backend..."); // Debug print
      
      // Make POST request to backend with timer in seconds
      final response = await http.post(
        Uri.parse('http://10.249.62.113:5001/reminder'), // Changed from 5001 to 5000
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'timer': timerInSeconds, // Send timer value in seconds
        }),
      );

      // print("📡 Response received: ${response.statusCode}"); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("✅ Success: $data"); // Debug print
        setState(() {
          _reminderMessage = data['message'] ?? _reminderMessage;
          _isLoading = false;
        });
      } else {
        // Handle error response
        // print("❌ Error: ${response.statusCode} - ${response.body}"); // Debug print
        setState(() {
          _isLoading = true;
        });
      }
    } catch (e) {
      // Handle network error (e.g., backend not running)
      print("💥 Exception: $e"); // Debug print
      setState(() {
        _isLoading = false;
      });
      // Keep the default message if backend is not available
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8), // Semi-transparent backdrop
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A237E),
                        const Color(0xFF3949AB),
                        const Color(0xFF5C6BC0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Attention-grabbing icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.access_time_filled,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Main heading
                      Text(
                        "⏰ Time's Up!",
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Motivational message
                      _isLoading 
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                          )
                        : Text(
                            _reminderMessage,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      
                      const SizedBox(height: 32),
                      
                      // Action buttons
                      Row(
                        children: [
                          // Snooze button (less prominent)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Snooze functionality
                                // Navigator.of(context).pop();
                                // Do nothing for now
                              },
                              icon: const Icon(Icons.snooze),
                              label: const Text('5 min'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Primary action button (more prominent)
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Take break functionality
                                // Navigator.of(context).pop();
                                // Do nothing for now
                              },
                              icon: const Icon(Icons.nature_people),
                              label: const Text('Take Break'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1A237E),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Dismiss option (subtle)
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // Continue back to screen
                        },
                        child: Text(
                          'Continue anyway',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Keep the original Reminder class for navigation compatibility
class Reminder extends StatelessWidget {
  const Reminder({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReminderOverlay();
  }
}