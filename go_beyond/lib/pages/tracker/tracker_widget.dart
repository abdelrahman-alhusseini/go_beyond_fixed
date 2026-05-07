import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../create_challange/create_challange_widget.dart';
import '../home/home_widget.dart';

class TrackerWidget extends StatelessWidget {
  const TrackerWidget({super.key});

  static const String routeName = 'Tracker';
  static const String routePath = '/tracker';

  Future<void> markCompleted({
    required BuildContext context,
    required String challengeId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .update({
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge marked as completed.')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update challenge: $e')),
      );
    }
  }

  Future<void> deleteChallenge({
    required BuildContext context,
    required String challengeId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge deleted.')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete challenge: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Challenges'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 56),
                const SizedBox(height: 16),
                const Text(
                  'You must be logged in to view your challenges.',
                  textAlign: TextAlign.center,
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

    final challengesQuery = FirebaseFirestore.instance
        .collection('challenges')
        .where('userId', isEqualTo: user.uid);

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: challengesQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load challenges:\n${snapshot.error}',
                  textAlign: TextAlign.center,
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

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.track_changes, size: 56),
                    const SizedBox(height: 16),
                    const Text(
                      'No challenges yet.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your first challenge to start tracking progress.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.pushNamed(CreateChallangeWidget.routeName),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Challenge'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final title = data['title'] as String? ?? 'Untitled Challenge';
              final type = data['type'] as String? ?? 'General';
              final difficulty = data['difficulty'] as String? ?? 'Easy';
              final status = data['status'] as String? ?? 'active';

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: status == 'completed'
                              ? Colors.green.shade100
                              : const Color(0xFFFFE0D2),
                          child: Icon(
                            status == 'completed'
                                ? Icons.check_rounded
                                : Icons.track_changes,
                            color: status == 'completed'
                                ? Colors.green
                                : const Color(0xFFCF4A14),
                          ),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('$type • $difficulty • $status'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'complete') {
                              markCompleted(
                                context: context,
                                challengeId: doc.id,
                              );
                            }

                            if (value == 'delete') {
                              deleteChallenge(
                                context: context,
                                challengeId: doc.id,
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            if (status != 'completed')
                              const PopupMenuItem(
                                value: 'complete',
                                child: Text('Mark completed'),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: status == 'completed' ? 1 : 0.25,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
