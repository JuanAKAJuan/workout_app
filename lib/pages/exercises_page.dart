import 'package:flutter/material.dart';
import 'package:workout_app/services/exercise_service.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
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
    String? selectedMuscleGroup;
    String? selectedIntensityTechnique;
    final List<String> muscleGroups = [
      "Chest",
      "Back",
      "Quads",
      "Hamstrings",
      "Abs",
      "Traps",
      "Triceps",
      "Forearms",
      "Calves",
      "Front Delts",
      "Glutes",
      "Biceps",
      "Side Delts",
      "Rear Delts"
    ];
    final List<String> intensityTechniques = [
      "Myoreps",
      "Myorep Match",
      "Drop sets",
      "None"
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Add New Exercise',
          ),
          titleTextStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          actionsAlignment: MainAxisAlignment.center,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Theme.of(context).colorScheme.background,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: 'Exercise name',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedMuscleGroup,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Theme.of(context).colorScheme.background,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: 'Muscle Group',
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMuscleGroup = newValue;
                    });
                  },
                  items: muscleGroups.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedIntensityTechnique,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Theme.of(context).colorScheme.background,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: 'Intensity Technique',
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 15,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIntensityTechnique = newValue;
                    });
                  },
                  items: intensityTechniques.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  _exercisesService.addExercise(
                    nameController.text,
                    selectedMuscleGroup,
                    selectedIntensityTechnique,
                  );
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
            fontSize: 16,
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
                    const Size.fromWidth(200),
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
                    const Size.fromWidth(200),
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
