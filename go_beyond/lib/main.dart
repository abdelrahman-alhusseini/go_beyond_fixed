import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'utils/guest_session.dart';
import 'firebase_options.dart';
import 'pages/completed/completed_widget.dart';
import 'pages/create_account/create_account_widget.dart';
import 'pages/create_challange/create_challange_widget.dart';
import 'pages/edit_profile/edit_profile_widget.dart';
import 'pages/home/home_widget.dart';
import 'pages/login1/login1_widget.dart';
import 'pages/main_page/main_page_widget.dart';
import 'pages/tracker/tracker_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GoBeyondApp());
}

class GoBeyondApp extends StatelessWidget {
  const GoBeyondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoBeyond',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCF4A14),
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: HomeWidget.routePath,
  routes: [
    GoRoute(
      path: HomeWidget.routePath,
      name: HomeWidget.routeName,
      builder: (context, state) => const HomeWidget(),
    ),
    GoRoute(
      path: Login1Widget.routePath,
      name: Login1Widget.routeName,
      builder: (context, state) => const Login1Widget(),
    ),
    GoRoute(
      path: CreateAccountWidget.routePath,
      name: CreateAccountWidget.routeName,
      builder: (context, state) => const CreateAccountWidget(),
    ),

    // Protected pages
    GoRoute(
      path: MainPageWidget.routePath,
      name: MainPageWidget.routeName,
      builder: (context, state) => const RequireAuth(
        child: MainPageWidget(),
      ),
    ),
    GoRoute(
      path: CreateChallangeWidget.routePath,
      name: CreateChallangeWidget.routeName,
      builder: (context, state) => const RequireAuth(
        child: CreateChallangeWidget(),
      ),
    ),
    GoRoute(
      path: TrackerWidget.routePath,
      name: TrackerWidget.routeName,
      builder: (context, state) => const RequireAuth(
        child: TrackerWidget(),
      ),
    ),
    GoRoute(
      path: CompletedWidget.routePath,
      name: CompletedWidget.routeName,
      builder: (context, state) => const RequireAuth(
        child: CompletedWidget(),
      ),
    ),
    GoRoute(
      path: EditProfileWidget.routePath,
      name: EditProfileWidget.routeName,
      builder: (context, state) => const RequireAuth(
        child: EditProfileWidget(),
      ),
    ),
  ],
);

class RequireAuth extends StatelessWidget {
  const RequireAuth({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (GuestSession.isGuest) {
      return child;
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final isWaiting = snapshot.connectionState == ConnectionState.waiting;
        final user = snapshot.data;

        if (isWaiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.goNamed(HomeWidget.routeName);
            }
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return child;
      },
    );
  }
}
