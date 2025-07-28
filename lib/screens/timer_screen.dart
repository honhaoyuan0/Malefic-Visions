import 'package:flutter/material.dart';
import 'app_selection_screen.dart';

// =============================================================================
// TIMER SCREEN - Main screen for setting up timer and selecting apps
// =============================================================================

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

// =============================================================================
// STATE CLASS - Manages timer values and selected apps
// =============================================================================

class _TimerScreenState extends State<TimerScreen> {
  // =============================================================================
  // STATE VARIABLES - Store current timer settings and selected apps
  // =============================================================================

  // Timer duration values (user can scroll to change these)
  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  // List of apps user wants reminders for (updated from app selection screen)
  List<String> selectedApps = [];

  // =============================================================================
  // UI BUILD METHOD - Creates the visual interface
  // =============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // =============================================================================
              // SCREEN TITLE - "Remind me every" heading
              // =============================================================================
              const Text(
                'Remind me every',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              // =============================================================================
              // TIME PICKER SECTION - Three scrollable wheels (HH : MM : SS)
              // =============================================================================
              _buildTimePicker(),
              const SizedBox(height: 60),
              // =============================================================================
              // APP SELECTION SECTION - Button to choose apps for reminders
              // =============================================================================
              _buildAppSelectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // TIME PICKER BUILDER - Creates three wheel pickers with colons (00 : 00 : 00)
  // =============================================================================
  Widget _buildTimePicker() {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // =============================================================================
          // HOURS WHEEL - Scrollable picker for hours (0-23)
          // =============================================================================
          Expanded(child: _buildLoopingWheelPicker(
            maxValue: 24,
            selectedValue: selectedHours,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedHours = value;
              });
            },
          )),
          // Colon separator between hours and minutes
          const Text(
            ':',
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          // =============================================================================
          // MINUTES WHEEL - Scrollable picker for minutes (0-59)
          // =============================================================================
          Expanded(child: _buildLoopingWheelPicker(
            maxValue: 60,
            selectedValue: selectedMinutes,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedMinutes = value;
              });
            },
          )),
          // Colon separator between minutes and seconds
          const Text(
            ':',
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          // =============================================================================
          // SECONDS WHEEL - Scrollable picker for seconds (0-59)
          // =============================================================================
          Expanded(child: _buildLoopingWheelPicker(
            maxValue: 60,
            selectedValue: selectedSeconds,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedSeconds = value;
              });
            },
          )),
        ],
      ),
    );
  }

  // =============================================================================
  // INDIVIDUAL WHEEL PICKER - Creates a single scrollable wheel with looping
  // =============================================================================
  Widget _buildLoopingWheelPicker({
    required int maxValue,
    required int selectedValue,
    required Function(int) onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 60,                              // Height of each number
      perspective: 0.01,                           // 3D curve effect
      diameterRatio: 1.5,                          // How curved the wheel looks
      physics: const FixedExtentScrollPhysics(),   // Snaps to each number
      onSelectedItemChanged: (index) {
        // Handle looping: when scrolling past max, wrap to 0
        // When scrolling below 0, wrap to max-1
        final actualValue = ((index % maxValue) + maxValue) % maxValue;
        onSelectedItemChanged(actualValue);
      },
      // Use Flutter's built-in looping delegate for infinite scroll
      childDelegate: ListWheelChildLoopingListDelegate(
        children: List.generate(maxValue, (index) {
          final isSelected = index == selectedValue;
          return Center(
            child: Text(
              index.toString().padLeft(2, '0'),    // Format as "01", "02", etc.
              style: TextStyle(
                fontSize: isSelected ? 36 : 24,    // Selected number is larger
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
                color: isSelected ? Colors.white : Colors.grey,  // Selected is white
              ),
            ),
          );
        }),
      ),
    );
  }

  // =============================================================================
  // APP SELECTION SECTION - Clickable area to choose apps for reminders
  // =============================================================================
  Widget _buildAppSelectionSection() {
    return GestureDetector(
      onTap: _navigateToAppSelection,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dynamic text showing selection status
            Expanded(
              child: Text(
                selectedApps.isEmpty
                  ? 'Select apps...'                    // No apps selected
                  : '${selectedApps.length} app${selectedApps.length == 1 ? '' : 's'} selected',  // Show count
                style: TextStyle(
                  fontSize: 16,
                  color: selectedApps.isEmpty ? Colors.grey : Colors.white,  // Grey if empty, white if selected
                ),
              ),
            ),
            // Arrow icon indicating this is clickable
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================================
  // NAVIGATION METHOD - Opens app selection screen and handles results
  // =============================================================================
  void _navigateToAppSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppSelectionScreen(
          selectedApps: selectedApps,           // Send current selections
          onAppsSelected: (apps) {              // Callback for when user is done
            setState(() {
              selectedApps = apps;              // Update our list with new selections
            });
          },
        ),
      ),
    );
  }
}
