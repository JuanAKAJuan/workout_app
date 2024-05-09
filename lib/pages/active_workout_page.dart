import 'package:flutter/material.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final String workoutName;
  const ActiveWorkoutPage({super.key, required this.workoutName});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workoutName,
        ),
      ),
    );
  }
}
