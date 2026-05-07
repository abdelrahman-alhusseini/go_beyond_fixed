import 'package:flutter/material.dart';
import '../home/home_widget.dart';

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  static const String routeName = 'completed';
  static const String routePath = '/completed';

  @override
  Widget build(BuildContext context) {
    const completed = [
      ('30-Day Run Streak', 'Fitness • Completed Mar 12', '+350 pts'),
      ('Meditation Master', 'Mindfulness • Completed Feb 28', '+280 pts'),
      ('Read 10 Books', 'Learning • Completed Jan 15', '+500 pts'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        foregroundColor: Colors.white,
        title: const Text('My Achievements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Completed',
                        style: TextStyle(color: Color(0xFFB0B0C8))),
                    SizedBox(height: 4),
                    Text('24 Challenges',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Icon(Icons.emoji_events_rounded,
                    color: Color(0xFFB388FF), size: 44),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final item in completed)
            Card(
              color: const Color(0xFF1E1E2E),
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFB388FF),
                  child: Icon(Icons.workspace_premium_rounded,
                      color: Colors.white),
                ),
                title: Text(item.$1,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(item.$2,
                    style: const TextStyle(color: Color(0xFFB0B0C8))),
                trailing: Text(item.$3,
                    style: const TextStyle(
                        color: Color(0xFFFFCC02), fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
