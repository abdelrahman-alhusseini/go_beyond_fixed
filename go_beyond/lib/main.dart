import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    GoRoute(
      path: MainPageWidget.routePath,
      name: MainPageWidget.routeName,
      builder: (context, state) => const MainPageWidget(),
    ),
    GoRoute(
      path: CreateChallangeWidget.routePath,
      name: CreateChallangeWidget.routeName,
      builder: (context, state) => const CreateChallangeWidget(),
    ),
    GoRoute(
      path: TrackerWidget.routePath,
      name: TrackerWidget.routeName,
      builder: (context, state) => const TrackerWidget(),
    ),
    GoRoute(
      path: CompletedWidget.routePath,
      name: CompletedWidget.routeName,
      builder: (context, state) => const CompletedWidget(),
    ),
    GoRoute(
      path: EditProfileWidget.routePath,
      name: EditProfileWidget.routeName,
      builder: (context, state) => const EditProfileWidget(),
    ),
  ],
);
