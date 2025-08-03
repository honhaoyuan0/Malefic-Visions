import 'package:flutter/material.dart';
import '../models/models.dart';

class SessionAppConfigScreen extends StatefulWidget {
  final List<AppTimer> existingAppTimers;
  final Function(List<AppTimer>) onAppTimersConfigured;

  const SessionAppConfigScreen({
    super.key,
    required this.existingAppTimers,
    required this.onAppTimersConfigured,
  });

  @override
  State<SessionAppConfigScreen> createState() => _SessionAppConfigScreenState();
}

class _SessionAppConfigScreenState extends State<SessionAppConfigScreen> {
  bool _isSelectingApps = true; // Phase 1: App selection, Phase 2: Timer configuration
  final List<App> _selectedApps = [];
  final Map<String, Duration> _appTimerSettings = {};
  late List<App> _availableApps;

  @override
  void initState() {
    super.initState();
    _availableApps = App.mockInstalledApps;
    
    // Pre-populate with existing app timers
    for (final timer in widget.existingAppTimers) {
      final app = _availableApps.firstWhere(
        (a) => a.package == timer.appPackage,
        orElse: () => App(
          name: timer.appName,
          package: timer.appPackage,
          icon: timer.appIcon,
        ),
      );
      _selectedApps.add(app);
      _appTimerSettings[app.package] = timer.reminderInterval;
    }
    
    // If we have existing timers, go directly to timer configuration
    if (widget.existingAppTimers.isNotEmpty) {
      _isSelectingApps = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectingApps ? 'Select Apps' : 'Configure Timers'),
        actions: [
          if (_isSelectingApps)
            TextButton(
              onPressed: _selectedApps.isEmpty ? null : _proceedToTimerConfig,
              child: const Text('Next'),
            )
          else
            TextButton(
              onPressed: _saveConfiguration,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isSelectingApps ? _buildAppSelectionPhase() : _buildTimerConfigPhase(),
    );
  }

  Widget _buildAppSelectionPhase() {
    return SafeArea(
      child: Column(
        children: [
          // Instruction header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select apps for this session:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedApps.length} apps selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          // App list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _availableApps.length,
              itemBuilder: (context, index) {
                final app = _availableApps[index];
                final isSelected = _selectedApps.any((a) => a.package == app.package);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        app.icon,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(app.name),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) => _toggleAppSelection(app, value ?? false),
                    ),
                    onTap: () => _toggleAppSelection(app, !isSelected),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerConfigPhase() {
    return SafeArea(
      child: Column(
        children: [
          // Instruction header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set reminder intervals:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Configure how often you want to be reminded about each app',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Back button to app selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _isSelectingApps = true),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to App Selection'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Timer configuration list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _selectedApps.length,
              itemBuilder: (context, index) {
                final app = _selectedApps[index];
                final currentInterval = _appTimerSettings[app.package] ?? const Duration(minutes: 30);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                app.icon,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                app.name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Remind every:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownButton<Duration>(
                              value: currentInterval,
                              items: AppTimer.commonIntervals.map((interval) {
                                return DropdownMenuItem<Duration>(
                                  value: interval,
                                  child: Text(AppTimer.intervalToDisplay(interval)),
                                );
                              }).toList(),
                              onChanged: (newInterval) {
                                if (newInterval != null) {
                                  setState(() {
                                    _appTimerSettings[app.package] = newInterval;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAppSelection(App app, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedApps.any((a) => a.package == app.package)) {
          _selectedApps.add(app);
          // Set default timer interval
          _appTimerSettings[app.package] = const Duration(minutes: 30);
        }
      } else {
        _selectedApps.removeWhere((a) => a.package == app.package);
        _appTimerSettings.remove(app.package);
      }
    });
  }

  void _proceedToTimerConfig() {
    if (_selectedApps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one app')),
      );
      return;
    }
    
    setState(() {
      _isSelectingApps = false;
    });
  }

  void _saveConfiguration() {
    final appTimers = _selectedApps.map((app) {
      final interval = _appTimerSettings[app.package] ?? const Duration(minutes: 30);
      return AppTimer(
        appName: app.name,
        appPackage: app.package,
        appIcon: app.icon,
        reminderInterval: interval,
      );
    }).toList();

    widget.onAppTimersConfigured(appTimers);
    Navigator.pop(context);
  }
}