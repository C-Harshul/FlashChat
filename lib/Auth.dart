import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  static Stream<FirebaseUser> get user {
    return FirebaseAuth.instance.onAuthStateChanged;
  }
}