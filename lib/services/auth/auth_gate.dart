import 'package:workout_app/pages/starting_page.dart';
import 'package:workout_app/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            return const StartingPage();
          } else {
            // User is NOT logged in
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
