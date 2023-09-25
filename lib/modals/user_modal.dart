import 'dart:developer';

class UserModal {
  int id;
  String email;
  String pass;
  String? name;
  String? imagePath;
  String? contact;

  UserModal(
      {required this.id,
      required this.email,
      required this.pass,
      this.name,
      this.imagePath,
      this.contact});

  factory UserModal.fromMap(Map userModal) {
    log(userModal.toString());
    UserModal um = UserModal(
        id: userModal['id'],
        email: userModal['email'],
        pass: userModal['pass'],
        name: userModal['name'],
        imagePath: userModal['imagePath'],
        contact: userModal['contact']);
    return um;
  }

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
        id: json["id"],
        email: json["email"],
        pass: json["pass"],
        name: json["name"],
        imagePath: json["imagePath"],
        contact: json["contact"],
      );
}
