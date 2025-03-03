class ClassModel {
  final int id;
  final String className;

  ClassModel({required this.id, required this.className});

  // Factory constructor to parse JSON
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      className: json['className'],
    );
  }
}
