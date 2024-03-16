import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/models/exercise.dart';

class ExercisesService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addExercise(
      String name, muscleGroup, typeOfExercise, intensityTechnique) {
    final String currentUserID = _auth.currentUser!.uid;

    Exercise newExercise = Exercise(
      name: name,
      muscleGroup: muscleGroup,
      typeOfExercise: typeOfExercise,
      intensityTechnique: intensityTechnique,
    );

    return FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserID)
        .collection("exercises")
        .add(newExercise.toMap());
  }
}
