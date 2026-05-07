import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/home_widget.dart';

import '../create_challange/create_challange_widget.dart';

class TrackerWidget extends StatelessWidget {
  const TrackerWidget({super.key});

  static const String routeName = 'Tracker';
  static const String routePath = '/tracker';

  @override
  Widget build(BuildContext context) {
    const challenges = [
      ('Daily Steps', 'Fitness', '75%'),
      ('Books to Read', 'Learning', '25%'),
      ('Water Intake', 'Health', '75%'),
      ('Workout Sessions', 'Fitness', '60%'),
      ('Savings Goal', 'Finance', '43%'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Challenges'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(CreateChallangeWidget.routeName),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          final percent = int.parse(challenge.$3.replaceAll('%', '')) / 100;
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        const CircleAvatar(child: Icon(Icons.track_changes)),
                    title: Text(challenge.$1,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(challenge.$2),
                    trailing: Text(challenge.$3,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  LinearProgressIndicator(value: percent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
