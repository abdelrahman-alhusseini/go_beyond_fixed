import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/utils/guest_session.dart';
import '../home/home_widget.dart';
import '../main_page/main_page_widget.dart';

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
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (GuestSession.isGuest) {
      loadGuestProfile();
    } else {
      loadProfileFromFirebase();
    }
  }

  void loadGuestProfile() {
    nameController.text = 'Guest User';
    emailController.text = 'guest@gobeyond.app';
    cityController.text = '';
    bioController.text = 'Guest mode does not save profile information.';

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadProfileFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      GuestSession.end();
      context.goNamed(HomeWidget.routeName);
      return;
    }

    try {
      emailController.text = user.email ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        nameController.text = data?['name'] ?? user.displayName ?? '';
        cityController.text = data?['city'] ?? '';
        bioController.text = data?['bio'] ?? '';
      } else {
        nameController.text = user.displayName ?? '';

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'city': '',
          'bio': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      showMessage('Could not load profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveProfile() async {
    if (GuestSession.isGuest) {
      showMessage('Guest profile cannot be saved. Please create an account.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('You must be logged in to save your profile.');
      return;
    }

    final name = nameController.text.trim();
    final city = cityController.text.trim();
    final bio = bioController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter your name.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await user.updateDisplayName(name);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': user.email ?? emailController.text.trim(),
        'city': city,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      showMessage('Profile saved successfully.');
      context.pop();
    } catch (e) {
      showMessage('Could not save profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> logout() async {
    GuestSession.end();

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }

    if (!mounted) return;

    context.goNamed(HomeWidget.routeName);
  }

  void goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(MainPageWidget.routeName);
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    bioController.dispose();
    super.dispose();
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

    final isGuest = GuestSession.isGuest;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: isSaving ? null : goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            onPressed: isSaving ? null : logout,
            icon: const Icon(Icons.logout),
            label: Text(isGuest ? 'Exit Guest' : 'Log Out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFFFE0D2),
            child: Icon(
              Icons.person,
              size: 58,
              color: Color(0xFFCF4A14),
            ),
          ),
          const SizedBox(height: 16),
          if (isGuest)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCC99)),
              ),
              child: const Text(
                'You are using Guest Mode. You can view this page, but profile changes will not be saved.',
                textAlign: TextAlign.center,
              ),
            ),
          TextField(
            controller: nameController,
            enabled: !isSaving && !isGuest,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            enabled: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              helperText: 'Email is linked to your login account.',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cityController,
            enabled: !isSaving && !isGuest,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your City',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bioController,
            enabled: !isSaving && !isGuest,
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
              onPressed: isSaving ? null : saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCF4A14),
                foregroundColor: Colors.white,
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isGuest ? 'Create Account to Save' : 'Save Changes'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isSaving ? null : logout,
            icon: const Icon(Icons.logout),
            label: Text(isGuest ? 'Exit Guest Mode' : 'Log Out'),
          ),
        ],
      ),
    );
  }
}
