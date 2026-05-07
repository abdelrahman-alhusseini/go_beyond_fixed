import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/services/profile_storage.dart';
import '../home/home_widget.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  static const String routeName = 'EditProfile';
  static const String routePath = '/editProfile';

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final bioController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSavedProfile();
  }

  Future<void> loadSavedProfile() async {
    final profile = await ProfileStorage.loadProfile();

    nameController.text = profile['name'] ?? '';
    emailController.text = profile['email'] ?? '';
    cityController.text = profile['city'] ?? '';
    bioController.text = profile['bio'] ?? '';

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final city = cityController.text.trim();
    final bio = bioController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name.')),
      );
      return;
    }

    await ProfileStorage.saveProfile(
      name: name,
      email: email,
      city: city,
      bio: bio,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const CircleAvatar(
            radius: 48,
            child: Icon(Icons.person, size: 58),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cityController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your City',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bioController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Your Bio',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCF4A14),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.goNamed(HomeWidget.routeName),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
