class ToolsData {
  final int errorCode;
  final String message;
  final List<Subject> subjectList;
  final List<ClassInfo> classList;
  final ToolsDetails toolsDetails;

  ToolsData({
    required this.errorCode,
    required this.message,
    required this.subjectList,
    required this.classList,
    required this.toolsDetails,
  });

  factory ToolsData.fromJson(Map<String, dynamic> json) {
    return ToolsData(
      errorCode: json['errorcode'],
      message: json['message'],
      subjectList: (json['Subject'] as List)
          .map((subjectJson) => Subject.fromJson(subjectJson))
          .toList(),
      classList: (json['classList'] as List)
          .map((classJson) => ClassInfo.fromJson(classJson))
          .toList(),
      toolsDetails: ToolsDetails.fromJson(json['Toolsdetails']),
    );
  }
}

class Subject {
  final int subID;
  final String toolsCode;
  final String subjectName;
  final String seqNo;

  Subject({
    required this.subID,
    required this.toolsCode,
    required this.subjectName,
    required this.seqNo,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subID: json['subID'],
      toolsCode: json['toolscode'],
      subjectName: json['SubjectName'],
      seqNo: json['seqNo'],
    );
  }
}

class ClassInfo {
  final int classId;
  final String className;

  ClassInfo({
    required this.classId,
    required this.className,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classId: json['classid'],
      className: json['className'],
    );
  }
}

class ToolsDetails {
  final int toolID;
  final String name;
  final String descriptions;
  final String classAvailability;
  final String subjectAvailability;
  final String maxWordAvailability;
  final String question2Availability;
  final String mathKeyboardAvailability;
  final String chaptersAvailability;
  final String toolsCode;

  ToolsDetails({
    required this.toolID,
    required this.name,
    required this.descriptions,
    required this.classAvailability,
    required this.subjectAvailability,
    required this.maxWordAvailability,
    required this.question2Availability,
    required this.mathKeyboardAvailability,
    required this.chaptersAvailability,
    required this.toolsCode,
  });

  factory ToolsDetails.fromJson(Map<String, dynamic> json) {
    return ToolsDetails(
      toolID: json['ToolID'],
      name: json['name'],
      descriptions: json['descriptions'],
      classAvailability: json['class'],
      subjectAvailability: json['subject'],
      maxWordAvailability: json['maxword'],
      question2Availability: json['question2'],
      mathKeyboardAvailability: json['mathkeyboard'],
      chaptersAvailability: json['chapters'],
      toolsCode: json['toolsCode'],
    );
  }
}
