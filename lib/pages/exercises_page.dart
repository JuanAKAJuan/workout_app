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
            onPressed: () async {
              await _exercisesService.addExercise(
                  "Stair Calf Raises", "Calves", "None");
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _buildExercisesList(),
    );
  }

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
              );
            },
          );
        }
        return const Center(child: Text("No Data"));
      },
    );
  }
}
