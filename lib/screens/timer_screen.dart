import 'package:flutter/material.dart';
import '../models/models.dart';
import 'session_config_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // User's sessions - starts empty
  List<Session> sessions = [];

  Session? get activeSession => sessions.where((s) => s.isActive).firstOrNull;

  List<Session> get sortedSessions {
    final List<Session> sorted = List.from(sessions);
    sorted.sort((a, b) {
      // Active sessions come first
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      // If both are active or both are inactive, maintain original order
      return 0;
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  children: [
                    // Sessions list
                    Expanded(
                      child: ListView.separated(
                        itemCount: sortedSessions.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildSessionCard(sortedSessions[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAddSessionButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sessions',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.help_outline),
        ),
      ],
    );
  }


  Widget _buildSessionCard(Session session) {
    return GestureDetector(
      onTap: () => _editSession(session),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: session.isActive 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      session.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (session.isActive)
                          Text(
                            'Active',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Switch(
                    value: session.isActive,
                    onChanged: (value) => _toggleSession(session, value),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${session.appCount} Apps',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddSessionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _createNewSession,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 20),
            SizedBox(width: 8),
            Text('Add Session'),
          ],
        ),
      ),
    );
  }

  void _toggleSession(Session session, bool isActive) {
    setState(() {
      // If activating this session, deactivate all others
      if (isActive) {
        for (int i = 0; i < sessions.length; i++) {
          sessions[i] = sessions[i].copyWith(isActive: false);
        }
      }
      
      // Update the selected session
      final index = sessions.indexWhere((s) => s.id == session.id);
      sessions[index] = session.copyWith(isActive: isActive);
    });
  }


  void _createNewSession() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionConfigScreen(
          onSessionSaved: (session) {
            setState(() {
              // If this session is being activated, deactivate others
              if (session.isActive) {
                for (int i = 0; i < sessions.length; i++) {
                  sessions[i] = sessions[i].copyWith(isActive: false);
                }
              }
              sessions.add(session);
            });
          },
        ),
      ),
    );
  }

  void _editSession(Session session) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionConfigScreen(
          session: session,
          onSessionSaved: (updatedSession) {
            setState(() {
              final index = sessions.indexWhere((s) => s.id == session.id);
              if (index != -1) {
                // If this session is being activated, deactivate others
                if (updatedSession.isActive && !session.isActive) {
                  for (int i = 0; i < sessions.length; i++) {
                    if (i != index) {
                      sessions[i] = sessions[i].copyWith(isActive: false);
                    }
                  }
                }
                sessions[index] = updatedSession;
              }
            });
          },
        ),
      ),
    );

    // Handle session deletion
    if (result == 'delete') {
      setState(() {
        sessions.removeWhere((s) => s.id == session.id);
      });
    }
  }
}
