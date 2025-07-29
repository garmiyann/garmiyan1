import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Required for Firebase initialization

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/main_home_page.dart';
import 'screens/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GoldenPrizmaApp());
}

class GoldenPrizmaApp extends StatelessWidget {
  const GoldenPrizmaApp({super.key});

  Future<Widget> _getInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenOnboarding') ?? false;

    if (seen) {
      return const LoginPage();
    } else {
      return OnboardingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoldenPrizma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainHomePage(),
      },
    );
  }
}
