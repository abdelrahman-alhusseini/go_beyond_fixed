import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/utils/daily_motivation.dart';
import '/utils/validators.dart';
import '../home/home_widget.dart';
import '../login1/login1_widget.dart';
import '../main_page/main_page_widget.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({super.key});

  static const String routeName = 'CreateAccount';
  static const String routePath = '/createAccount';

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter your name.');
      return;
    }

    if (!isValidEmail(email)) {
      showMessage('Please enter a valid email address.');
      return;
    }

    if (!isStrongPassword(password)) {
      showMessage(
        'Password must be at least 8 characters and include uppercase, number, and special character.',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Firebase did not return a user account.',
        );
      }

      await user.updateDisplayName(name);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'city': '',
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await DailyMotivation.chooseNewForSignIn();

      if (!mounted) return;

      showMessage('Account created successfully.');
      context.goNamed(MainPageWidget.routeName);
    } on FirebaseAuthException catch (e) {
      showMessage(
        'Firebase Auth Error: ${e.code}${e.message == null ? '' : ' - ${e.message}'}',
      );
    } on FirebaseException catch (e) {
      showMessage(
        'Firebase Error: ${e.code}${e.message == null ? '' : ' - ${e.message}'}',
      );
    } catch (e) {
      showMessage('Unexpected Error: $e');
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
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create an account',
      subtitle: 'Let’s get started by filling out the form below.',
      children: [
        TextField(
          controller: nameController,
          enabled: !isLoading,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          enabled: !isLoading,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          enabled: !isLoading,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          enabled: !isLoading,
          obscureText: obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading ? null : createAccount,
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
                : const Text('Create Account'),
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: isLoading
              ? null
              : () => context.pushNamed(Login1Widget.routeName),
          child: const Text('Already have an account? Sign In here'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed:
              isLoading ? null : () => context.goNamed(HomeWidget.routeName),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}
