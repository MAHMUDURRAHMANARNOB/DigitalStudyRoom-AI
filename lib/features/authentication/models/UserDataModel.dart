class User {
  final int id;
  final String userId;
  final String username;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String userType;
  final int? classId;

  User({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.userType,
    this.classId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['UserID'],
      username: json['username'],
      name: json['Name'],
      email: json['Email'],
      mobile: json['Mobile'],
      password: json['Password'],
      userType: json['userType'],
      classId: json['classid'],
    );
  }
}
