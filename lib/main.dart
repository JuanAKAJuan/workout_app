import 'package:firebase_core/firebase_core.dart';
import 'package:workout_app/data/workout_data.dart';
import 'package:workout_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/services/auth/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider (
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '1 Ton',
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
