
class User {
  String username;
  String email;
  String password;
  String profileImage;

  User({
    required this.password,
    required this.email,
    required this.username,
    this.profileImage="lib/images/user.png",
  });
}
