import 'package:firebase_auth/firebase_auth.dart';
import 'package:joby/state/auth/models/auth_result.dart';
import 'package:joby/typedef/user_id.dart';


class Authenticator {

  const Authenticator();

  // function
  // bool isAlreadyLoggedIn() {
  //   return FirebaseAuth.instance.currentUser != null;
  // }

  // getter
  bool get isAlreadyLoggedIn => userId != null;

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> logOut() async {
    print('logOut');
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthResult> loginWithEmailAndPassword(String email, String password) async  {
    print ('Logging in with email and password');

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthResult.success;
    }
    catch (e){
      print("Error logging with email and password! $e");
      return AuthResult.failure;
    }
  }

  Future<AuthResult> registerWithEmailAndPassword(String email, String password) async  {
    print ('Register in with email and password');

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return AuthResult.userAlreadyExists;
        case 'too-many-requests':
          return AuthResult.tooManyRequests;
        default:
          return AuthResult.failure;
      }
    }
    catch (e){
      print("Error register with email and password! $e");
      return AuthResult.failure;
    }
  }
}