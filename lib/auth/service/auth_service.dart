
import 'package:firebase_auth/firebase_auth.dart';

import '../../users/models/user_models.dart';
import '../../users/service/user_service.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  User? get currentUser => _auth
      .currentUser; //if user is logged in, return the user, else return null

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: _auth.currentUser!.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        userRole: 'user',
        photoUrl: '',
        address: '',
        education: '',
        experience: '',
        jobTitle: '',
        aboutYou: '',
        skills: '',
        interests: '',
        languages: '',
        linkedIn: '',

      );
      await _userService.createUser(newUser);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    if (currentUser != null) {
      return await _userService.getUser(currentUser!.uid);
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}