import 'package:flutter/material.dart';
import 'package:malefic_visions/screens/home_screen.dart';
import 'package:malefic_visions/services/overlay_service.dart';

class PermissionCheckScreen extends StatefulWidget {
  const PermissionCheckScreen({super.key});

  @override
  State<PermissionCheckScreen> createState() => _PermissionCheckScreenState();
}

class _PermissionCheckScreenState extends State<PermissionCheckScreen> {
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionOnStartup();
  }

  Future<void> _checkPermissionOnStartup() async {
    final hasPermission = await OverlayService.hasOverlayPermission();

    setState(() {
      _hasPermission = hasPermission;
      _isLoading = false;
    });

    // Auto-navigate if permission is already granted
    if (hasPermission) {
      await Future.delayed(Duration(milliseconds: 500)); // Brief delay for UX
      _navigateToHome();
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    final granted = await OverlayService.requestOverlayPermission();
    
    setState(() {
      _hasPermission = granted;
      _isLoading = false;
    });

    if (granted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHome()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Icon(
                Icons.security,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Permission Required',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Malefic Visions needs permission to display over other apps to remind you when it\'s time to take a break.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Loading or Permission Status
              if (_isLoading)
                const CircularProgressIndicator()
              else if (!_hasPermission)
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _requestPermission,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Grant Permission'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextButton(
                      onPressed: () {
                        // Skip for now (optional)
                        _navigateToHome();
                      },
                      child: const Text('Skip for now'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Permission Granted!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


