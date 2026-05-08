import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tracker/tracker_widget.dart';

class CreateChallangeWidget extends StatefulWidget {
  const CreateChallangeWidget({super.key});

  static const String routeName = 'CreateChallange';
  static const String routePath = '/createChallange';

  @override
  State<CreateChallangeWidget> createState() => _CreateChallangeWidgetState();
}

class _CreateChallangeWidgetState extends State<CreateChallangeWidget> {
  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final unitController = TextEditingController();

  String type = 'Health';
  String difficulty = 'Easy';
  DateTime startDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    targetController.text = '100';
    unitController.text = 'points';
  }

  @override
  void dispose() {
    nameController.dispose();
    targetController.dispose();
    unitController.dispose();
    super.dispose();
  }

  Future<void> pickStartDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() {
        startDate = selected;
      });
    }
  }

  void goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(TrackerWidget.routeName);
    }
  }

  Future<void> createChallenge() async {
    final user = FirebaseAuth.instance.currentUser;
    final name = nameController.text.trim();
    final target = double.tryParse(targetController.text.trim());
    final unit = unitController.text.trim();

    if (user == null) {
      showMessage('You must be logged in to create a challenge.');
      return;
    }

    if (name.isEmpty) {
      showMessage('Please enter a challenge name.');
      return;
    }

    if (target == null || target <= 0) {
      showMessage('Please enter a valid target number.');
      return;
    }

    if (unit.isEmpty) {
      showMessage('Please enter a unit, like steps, pages, days, or sessions.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('challenges').add({
        'title': name,
        'type': type,
        'difficulty': difficulty,
        'startDate': Timestamp.fromDate(startDate),
        'status': 'active',
        'userId': user.uid,

        // Tracking fields
        'targetValue': target,
        'currentValue': 0.0,
        'unit': unit,
        'progress': 0.0,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage('Challenge created successfully.');
      context.goNamed(TrackerWidget.routeName);
    } catch (e) {
      showMessage('Could not create challenge: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String get formattedStartDate {
    final year = startDate.year;
    final month = startDate.month.toString().padLeft(2, '0');
    final day = startDate.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Challenge'),
        leading: IconButton(
          onPressed: isLoading ? null : goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: nameController,
            enabled: !isLoading,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Challenge name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(
              labelText: 'Challenge Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Health', child: Text('Health')),
              DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
              DropdownMenuItem(
                  value: 'Mental Wellness', child: Text('Mental Wellness')),
              DropdownMenuItem(
                  value: 'Productivity', child: Text('Productivity')),
              DropdownMenuItem(value: 'Learning', child: Text('Learning')),
              DropdownMenuItem(value: 'Finance', child: Text('Finance')),
            ],
            onChanged: isLoading
                ? null
                : (value) {
                    setState(() {
                      type = value ?? 'Health';
                    });
                  },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: difficulty,
            decoration: const InputDecoration(
              labelText: 'Difficulty',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
            ],
            onChanged: isLoading
                ? null
                : (value) {
                    setState(() {
                      difficulty = value ?? 'Easy';
                    });
                  },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: targetController,
            enabled: !isLoading,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Number',
              hintText: 'Example: 10000',
              helperText: 'The total goal you want to reach.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: unitController,
            enabled: !isLoading,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Unit',
              hintText: 'Example: steps',
              helperText: 'Examples: steps, pages, days, sessions.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(4),
            ),
            title: const Text('Start Date'),
            subtitle: Text(formattedStartDate),
            trailing: const Icon(Icons.calendar_month),
            onTap: isLoading ? null : pickStartDate,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : createChallenge,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCF4A14),
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Challenge'),
            ),
          ),
        ],
      ),
    );
  }
}
