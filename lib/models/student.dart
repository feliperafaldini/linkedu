class Student {
  final String name;
  final String course;
  final String semester;
  final int ra;

  const Student({
    required this.name,
    required this.course,
    required this.semester,
    required this.ra,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'course': course,
      'semester': semester,
      'ra': ra,
    };
  }
}
