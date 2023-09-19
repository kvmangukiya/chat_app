class UserModal {
  String email;
  String pass;
  String? name;
  String? imagePath;
  String contact;
  int id = 0;

  UserModal(
      this.email, this.pass, this.name, this.imagePath, this.contact, this.id);

  factory UserModal.fromMap(Map userModal) {
    return UserModal(userModal['email'], userModal['pass'], userModal['name'],
        userModal['imagePath'], userModal['contact'], userModal['id']);
  }
}
