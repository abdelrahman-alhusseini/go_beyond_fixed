import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/utils/validators.dart';
import '../create_account/create_account_widget.dart';
import '../home/home_widget.dart';
import '../main_page/main_page_widget.dart';

class Login1Widget extends StatefulWidget {
  const Login1Widget({super.key});

  static const String routeName = 'Login1';
  static const String routePath = '/login1';

  @override
  State<Login1Widget> createState() => _Login1WidgetState();
}

class _Login1WidgetState extends State<Login1Widget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password.'),
        ),
      );
      return;
    }

    context.goNamed(MainPageWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome Back',
      subtitle: 'Login to continue your journey.',
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              labelText: 'Email', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: signIn,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCF4A14),
                foregroundColor: Colors.white),
            child: const Text('Sign In'),
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => context.pushNamed(CreateAccountWidget.routeName),
          child: const Text('Don’t have an account? Sign Up here'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.goNamed(HomeWidget.routeName),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.children});

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('GoBeyond')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(subtitle),
                const SizedBox(height: 28),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
