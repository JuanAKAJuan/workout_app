import 'package:flutter/material.dart';
import 'package:workout_app/data/exercise_data.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        ExerciseData(
          exercise: Exercise(
            name: "Barbell Bench Press",
            muscleGroup: "Chest",
            intensityTechnique: "None",
          ),
          sets: "4",
          reps: "10",
          weight: "135",
        ),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        ExerciseData(
          exercise: Exercise(
            name: "Squats",
            muscleGroup: "Quads",
            intensityTechnique: "None",
          ),
          sets: "4",
          reps: "5",
          weight: "225",
        ),
      ],
    ),
  ];

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  void addExerciseData(String workoutName, Exercise exercise, String sets,
      String reps, String weight) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      ExerciseData(
        exercise: exercise,
        sets: sets,
        reps: reps,
        weight: weight,
      ),
    );

    notifyListeners();
  }

  void checkOffExerciseData(String workoutName, String exerciseName) {
    ExerciseData relevantExercise =
        getRelevantExerciseData(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  ExerciseData getRelevantExerciseData(
      String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    ExerciseData relevantExerciseData = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.exercise.name == exerciseName);

    return relevantExerciseData;
  }
}
