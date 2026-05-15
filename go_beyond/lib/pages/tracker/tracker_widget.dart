import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/utils/guest_session.dart';
import '../create_challange/create_challange_widget.dart';
import '../home/home_widget.dart';
import '../main_page/main_page_widget.dart';

class TrackerWidget extends StatelessWidget {
  const TrackerWidget({super.key});

  static const String routeName = 'Tracker';
  static const String routePath = '/tracker';

  Future<void> logout(BuildContext context) async {
    GuestSession.end();

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }

    if (!context.mounted) return;

    context.goNamed(HomeWidget.routeName);
  }

  Future<void> markCompleted({
    required BuildContext context,
    required String challengeId,
    required double targetValue,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .update({
        'currentValue': targetValue,
        'progress': 1.0,
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

  Future<void> showUpdateProgressDialog({
    required BuildContext context,
    required String challengeId,
    required Map<String, dynamic> data,
  }) async {
    final targetValue = _toDouble(data['targetValue'], fallback: 100);
    final currentValue = _toDouble(data['currentValue'], fallback: 0);
    final unit = data['unit'] as String? ?? 'points';

    final progressController = TextEditingController(
      text: _formatNumber(currentValue),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Progress'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Target: ${_formatNumber(targetValue)} $unit',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Text(
                'Enter your total completed amount so far.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: progressController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Current amount',
                  suffixText: unit,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newValue =
                    double.tryParse(progressController.text.trim());

                if (newValue == null || newValue < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number.'),
                    ),
                  );
                  return;
                }

                final progress = (newValue / targetValue).clamp(0.0, 1.0);
                final status = progress >= 1.0 ? 'completed' : 'active';

                try {
                  await FirebaseFirestore.instance
                      .collection('challenges')
                      .doc(challengeId)
                      .update({
                    'currentValue': newValue,
                    'progress': progress,
                    'status': status,
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  if (!context.mounted) return;

                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        status == 'completed'
                            ? 'Progress saved. Challenge completed!'
                            : 'Progress updated.',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not save progress: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    progressController.dispose();
  }

  static double _toDouble(dynamic value, {required double fallback}) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return fallback;
  }

  static String _formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => context.goNamed(HomeWidget.routeName),
            icon: const Icon(Icons.arrow_back),
          ),
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
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.goNamed(MainPageWidget.routeName),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('My Challenges'),
        actions: [
          IconButton(
            tooltip: 'Create Challenge',
            onPressed: () => context.pushNamed(CreateChallangeWidget.routeName),
            icon: const Icon(Icons.add_rounded),
          ),
          TextButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
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
                      'No active challenges yet.',
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
              final unit = data['unit'] as String? ?? 'points';

              final currentValue = _toDouble(data['currentValue'], fallback: 0);
              final targetValue = _toDouble(data['targetValue'], fallback: 100);

              final progress =
                  _toDouble(data['progress'], fallback: 0).clamp(0.0, 1.0);

              final percent = (progress * 100).round();

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE0D2),
                          child: Icon(
                            Icons.track_changes,
                            color: Color(0xFFCF4A14),
                          ),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('$type • $difficulty'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'update') {
                              showUpdateProgressDialog(
                                context: context,
                                challengeId: doc.id,
                                data: data,
                              );
                            }

                            if (value == 'complete') {
                              markCompleted(
                                context: context,
                                challengeId: doc.id,
                                targetValue: targetValue,
                              );
                            }

                            if (value == 'delete') {
                              deleteChallenge(
                                context: context,
                                challengeId: doc.id,
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'update',
                              child: Text('Update progress'),
                            ),
                            PopupMenuItem(
                              value: 'complete',
                              child: Text('Mark completed'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatNumber(currentValue)} / ${_formatNumber(targetValue)} $unit',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 6),
                      Text('$percent% completed'),
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
