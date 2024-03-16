import 'package:flutter/material.dart';
import 'package:workout_app/services/exercise_service.dart';

class ExercisesPage extends StatelessWidget {
  ExercisesPage({super.key});

  final ExercisesService _exercisesService = ExercisesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            _exercisesService.addExercise("Squats", "Quads", "Barbell", "None");
          },
          child: const Text("Add Exercise"),
        ),
      ),
    );
  }
}
