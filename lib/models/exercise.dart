class Exercise {
  final String name;
  final String muscleGroup;
  final String intensityTechnique;

  Exercise({
    required this.name,
    required this.muscleGroup,
    required this.intensityTechnique,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'muscleGroup': muscleGroup,
      'intensityTechnique': intensityTechnique,
    };
  }
}
