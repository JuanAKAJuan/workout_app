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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                subtitle: item['intensityTechnique'] == 'None'
                    ? Text(
                        'Muscle Group: ${item['muscleGroup']}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    : Text(
                        'Muscle Group: ${item['muscleGroup']}\nIntensity Technique: ${item['intensityTechnique']}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                onLongPress: () => _showDeleteExerciseWindow(context, item),
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
          title: const Text(
            textAlign: TextAlign.center,
            'Add New Exercise',
          ),
          titleTextStyle: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          actionsAlignment: MainAxisAlignment.center,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: 'Enter exercise name',
                  ),
                ),
                TextField(
                  controller: muscleGroupController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: 'Enter muscle group',
                  ),
                ),
                TextField(
                  controller: intensityTechniqueController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
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

  void _showDeleteExerciseWindow(
      BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          titlePadding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
          contentPadding: const EdgeInsets.only(bottom: 10),
          title: Text(
            textAlign: TextAlign.center,
            "Delete \"${item['name']}\"?",
          ),
          titleTextStyle: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          actionsAlignment: MainAxisAlignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.inversePrimary),
                  fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(200),
                  ),
                ),
                child: const Text('Delete Exercise'),
                onPressed: () {
                  _exercisesService.deleteExercise(item);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.background),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.inversePrimary),
                  fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(200),
                  ),
                ),
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
