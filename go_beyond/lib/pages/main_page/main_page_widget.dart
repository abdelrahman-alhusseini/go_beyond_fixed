import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/home_widget.dart';
import '../completed/completed_widget.dart';
import '../create_challange/create_challange_widget.dart';
import '../edit_profile/edit_profile_widget.dart';
import '../tracker/tracker_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  static const String routeName = 'MainPage';
  static const String routePath = '/mainPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      appBar: AppBar(
        title: const Text('GoBeyond Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(EditProfileWidget.routeName),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFCF4A14), Color(0xFFFFD200)]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Text('DAILY MOTIVATION',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  'The secret of getting ahead is getting started. Push your limits and become unstoppable.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('What would you like to do?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const DashboardCard(
            icon: Icons.add_circle_outline,
            title: 'Create a Challenge',
            subtitle: 'Set a new goal and start your journey',
            routeName: CreateChallangeWidget.routeName,
          ),
          const DashboardCard(
            icon: Icons.track_changes,
            title: 'Track Progress',
            subtitle: 'Monitor your active challenges',
            routeName: TrackerWidget.routeName,
          ),
          const DashboardCard(
            icon: Icons.emoji_events,
            title: 'Completed Challenges',
            subtitle: 'Celebrate your victories',
            routeName: CompletedWidget.routeName,
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.routeName});

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0x22CF4A14),
          child: Icon(icon, color: const Color(0xFFCF4A14)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: () => context.pushNamed(routeName),
      ),
    );
  }
}
