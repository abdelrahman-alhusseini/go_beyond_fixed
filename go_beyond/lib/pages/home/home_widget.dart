import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../create_account/create_account_widget.dart';
import '../login1/login1_widget.dart';
import '../main_page/main_page_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  static const String routeName = 'Home';
  static const String routePath = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 210,
                    height: 210,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF8800),
                          Color(0xFFFF4400),
                          Color(0xFFCC1100),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x88FF6600),
                          blurRadius: 45,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.white,
                      size: 110,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'GoBeyond',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFDD00),
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ignite Your Potential. Rise Beyond Limits.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFF9933),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 46),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => context.pushNamed(CreateAccountWidget.routeName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8800),
                        foregroundColor: const Color(0xFF1A0A00),
                      ),
                      child: const Text('Sign Up — Start Your Journey'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => context.pushNamed(Login1Widget.routeName),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF8800),
                        side: const BorderSide(color: Color(0xFFFF8800), width: 2),
                      ),
                      child: const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.goNamed(MainPageWidget.routeName),
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Color(0xFFFFCC66)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.help_outline_rounded, color: Color(0x66FF9933), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Need help? Visit our Support Center',
                        style: TextStyle(color: Color(0x66FF9933), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
