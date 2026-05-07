import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/home_widget.dart';
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
  String type = 'Health';
  String difficulty = 'Easy';
  DateTime startDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
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
      setState(() => startDate = selected);
    }
  }

  void createChallenge() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a challenge name.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge created: $name')),
    );
    context.goNamed(TrackerWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Challenge')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: nameController,
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
                labelText: 'Challenge Type', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Health', child: Text('Health')),
              DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
              DropdownMenuItem(
                  value: 'Mental Wellness', child: Text('Mental Wellness')),
              DropdownMenuItem(
                  value: 'Productivity', child: Text('Productivity')),
              DropdownMenuItem(value: 'Learning', child: Text('Learning')),
            ],
            onChanged: (value) => setState(() => type = value ?? 'Health'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: difficulty,
            decoration: const InputDecoration(
                labelText: 'Difficulty', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
            ],
            onChanged: (value) => setState(() => difficulty = value ?? 'Easy'),
          ),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(4),
            ),
            title: const Text('Start Date'),
            subtitle: Text(
                '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.calendar_month),
            onTap: pickStartDate,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: createChallenge,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCF4A14),
                  foregroundColor: Colors.white),
              child: const Text('Let’s Go!'),
            ),
          ),
        ],
      ),
    );
  }
}
