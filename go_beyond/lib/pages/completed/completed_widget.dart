import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/home_widget.dart';

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  static const String routeName = 'completed';
  static const String routePath = '/completed';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F0F1A),
          foregroundColor: Colors.white,
          title: const Text('My Achievements'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 56,
                ),
                const SizedBox(height: 16),
                const Text(
                  'You must be logged in to view completed challenges.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.goNamed(HomeWidget.routeName),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final completedQuery = FirebaseFirestore.instance
        .collection('challenges')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'completed');

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        foregroundColor: Colors.white,
        title: const Text('My Achievements'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: completedQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load completed challenges:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Completed',
                          style: TextStyle(color: Color(0xFFB0B0C8)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${docs.length} Challenges',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFFB388FF),
                      size: 44,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (docs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.workspace_premium_outlined,
                        color: Color(0xFFB388FF),
                        size: 56,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No completed challenges yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Complete a challenge from the tracker page and it will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFB0B0C8)),
                      ),
                    ],
                  ),
                )
              else
                for (final doc in docs)
                  _CompletedChallengeCard(
                    data: doc.data(),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  const _CompletedChallengeCard({
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Untitled Challenge';
    final type = data['type'] as String? ?? 'General';
    final difficulty = data['difficulty'] as String? ?? 'Easy';

    String completedText = 'Completed';

    final updatedAt = data['updatedAt'];
    if (updatedAt is Timestamp) {
      final date = updatedAt.toDate();
      completedText =
          'Completed ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return Card(
      color: const Color(0xFF1E1E2E),
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFB388FF),
          child: Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$type • $difficulty • $completedText',
          style: const TextStyle(color: Color(0xFFB0B0C8)),
        ),
        trailing: const Text(
          '+100 pts',
          style: TextStyle(
            color: Color(0xFFFFCC02),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
