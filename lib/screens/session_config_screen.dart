import 'package:flutter/material.dart';
import '../models/models.dart';
import 'session_app_config_screen.dart';

class SessionConfigScreen extends StatefulWidget {
  final Session? session; // null for new session, existing session for editing
  final Function(Session) onSessionSaved;

  const SessionConfigScreen({
    super.key,
    this.session,
    required this.onSessionSaved,
  });

  @override
  State<SessionConfigScreen> createState() => _SessionConfigScreenState();
}

class _SessionConfigScreenState extends State<SessionConfigScreen> {
  late TextEditingController _nameController;
  late IconData _selectedIcon;
  late List<AppTimer> _appTimers;
  late bool _isActive;

  final List<IconData> _availableIcons = [
    Icons.group,
    Icons.work,
    Icons.bedtime,
    Icons.school,
    Icons.home,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.movie,
    Icons.music_note,
    Icons.games,
    Icons.flight,
    Icons.shopping_cart,
    Icons.library_books,
    Icons.code,
    Icons.camera_alt,
  ];

  @override
  void initState() {
    super.initState();
    
    if (widget.session != null) {
      // Editing existing session
      _nameController = TextEditingController(text: widget.session!.name);
      _selectedIcon = widget.session!.icon;
      _appTimers = List.from(widget.session!.appTimers);
      _isActive = widget.session!.isActive;
    } else {
      // Creating new session
      _nameController = TextEditingController();
      _selectedIcon = Icons.group;
      _appTimers = [];
      _isActive = false; // Always create new sessions as inactive
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session != null ? 'Edit Session' : 'New Session'),
        actions: [
          TextButton(
            onPressed: _saveSession,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40, // Account for padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSessionNameSection(),
                      const SizedBox(height: 24),
                      _buildIconSelectionSection(),
                      const SizedBox(height: 24),
                      _buildAppsSection(),
                      const Spacer(),
                      if (widget.session != null) ...[
                        _buildDeleteButton(),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Name',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'e.g., Going out with friends',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Icon',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableIcons.map((icon) {
            final isSelected = icon == _selectedIcon;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apps',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.apps,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text('Configure Apps'),
            subtitle: Text('${_appTimers.length} apps configured'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _configureApps,
          ),
        ),
      ],
    );
  }


  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _deleteSession,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text('Delete Session'),
      ),
    );
  }

  void _configureApps() async {
    await Navigator.push<List<AppTimer>>(
      context,
      MaterialPageRoute(
        builder: (context) => SessionAppConfigScreen(
          existingAppTimers: _appTimers,
          onAppTimersConfigured: (appTimers) {
            setState(() {
              _appTimers = appTimers;
            });
          },
        ),
      ),
    );
    
  }

  void _saveSession() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a session name')),
      );
      return;
    }

    final session = Session(
      id: widget.session?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      isActive: _isActive,
      appTimers: _appTimers,
      lastUsed: widget.session?.lastUsed,
      streakDays: widget.session?.streakDays ?? 0,
    );

    widget.onSessionSaved(session);
    Navigator.pop(context);
  }

  void _deleteSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: Text('Are you sure you want to delete "${widget.session!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, 'delete'); // Return to previous screen with delete signal
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}