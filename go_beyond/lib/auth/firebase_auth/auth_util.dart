import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthManager {
  Future<Object?> createAccountWithEmail(BuildContext context, String email, String password) async => Object();
  Future<Object?> signInWithEmail(BuildContext context, String email, String password) async => Object();
}

final authManager = AuthManager();

extension GoRouterAuthExtension on GoRouter {
  void prepareAuthEvent() {}
}

extension GoRouterAuthContextExtension on BuildContext {
  void goNamedAuth(String name, bool mounted) {
    if (mounted) {
      goNamed(name);
    }
  }
}
