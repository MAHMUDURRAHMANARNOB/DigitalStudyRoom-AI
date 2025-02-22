class Tutor {
  final int id;
  final String tutorName;
  final String? tutorType;
  final String tutorSubjects;
  final String? subjectID;
  final String? tutorImage;
  final String isActive;

  Tutor({
    required this.id,
    required this.tutorName,
    this.tutorType,
    required this.tutorSubjects,
    this.subjectID,
    this.tutorImage,
    required this.isActive,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] ?? 0,
      tutorName: json['TutorName'] ?? '',
      tutorType: json['TutorType'],
      tutorSubjects: json['TutorSubjects'] ?? '',
      subjectID: json['subjectID'].toString(),
      tutorImage: json['TutorImage'],
      isActive: json['isActive'] ?? 'N',
    );
  }
}

class TutorResponse {
  final int errorCode;
  final String message;
  final List<Tutor> tutors;

  TutorResponse({
    required this.errorCode,
    required this.message,
    required this.tutors,
  });

  factory TutorResponse.fromJson(Map<String, dynamic> json) {
    return TutorResponse(
      errorCode: json['errorcode'] ?? 400,
      message: json['message'] ?? 'Unknown Error',
      tutors: (json['tutors'] as List).map((tutor) => Tutor.fromJson(tutor)).toList(),
    );
  }
}