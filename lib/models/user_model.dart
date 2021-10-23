class UserModel {
  String? id;
  String? email;
  String? password;
  DateTime? dateAdded;
  DateTime? lastLogin;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.dateAdded,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      dateAdded: DateTime.tryParse(json['dateAdded'] as String),
      lastLogin: DateTime.tryParse(json['lastLogin'] as String),
    );
  }
}
