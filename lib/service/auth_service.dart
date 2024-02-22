class User {
  final String username;
  final String role;

  User({
    required this.username,
    required this.role,
  });
}

class AuthService {
  static User? currentUser;

  static bool isAuthenticated() {
    return currentUser != null;
  }

  static bool isAdmin() {
    return isAuthenticated() && currentUser!.role == 'admin';
  }
}
