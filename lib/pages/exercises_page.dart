import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: _buildExercisesList(),
    );
  }

  Widget _buildExercisesList() {
    return StreamBuilder(
      stream: _exercisesService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildExerciseItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildExerciseItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ListTile(
      title: Text(
        data['name'],
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: data['intensityTechnique'] == 'None'
          ? Text(
              'Muscle Group: ${data['muscleGroup']}',
              style: const TextStyle(color: Colors.grey),
            )
          : Text(
              'Muscle Group: ${data['muscleGroup']}\nIntensity Technique: ${data['intensityTechnique']}',
              style: const TextStyle(color: Colors.grey),
            ),
    );
  }
}
