import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        actions: <Widget>[
          IconButton(
            onPressed: () => _showAddExerciseWindow(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _buildExercisesList(),
    );
  }

  /// Creates a list of both default exercises and custom exercises that is
  /// displayed on the exercises page.
  Widget _buildExercisesList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _exercisesService.getCombinedExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = snapshot.data![index];
              return ListTile(
                title: Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: item['intensityTechnique'] == 'None'
                    ? Text(
                        'Muscle Group: ${item['muscleGroup']}',
                        style: const TextStyle(color: Colors.grey),
                      )
                    : Text(
                        'Muscle Group: ${item['muscleGroup']}\nIntensity Technique: ${item['intensityTechnique']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                onLongPress: () => _exercisesService.deleteExercise(item),
              );
            },
          );
        }
        return const Center(child: Text("No Data"));
      },
    );
  }

  /// Pops up a window allowing the user to input custom exercise information.
  void _showAddExerciseWindow(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController muscleGroupController = TextEditingController();
    TextEditingController intensityTechniqueController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Exercise'),
          actionsAlignment: MainAxisAlignment.center,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter exercise name',
                  ),
                ),
                TextField(
                  controller: muscleGroupController,
                  decoration: const InputDecoration(
                    hintText: 'Enter muscle group',
                  ),
                ),
                TextField(
                  controller: intensityTechniqueController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText:
                        'Enter intensity technique\n(leave empty if there isn\'t one)',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (intensityTechniqueController.text == "") {
                    intensityTechniqueController.text = "None";
                  }
                  _exercisesService.addExercise(
                      nameController.text,
                      muscleGroupController.text,
                      intensityTechniqueController.text);
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsWindow() {}
}
