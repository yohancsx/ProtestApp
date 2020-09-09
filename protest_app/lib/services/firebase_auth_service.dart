import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  ///Firebase authentication instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///Create a Firebase user, which will persist while the app is active
  ///Returns null and prints error if failure
  Future<AuthResult> createFirebaseUser() async {
    try {
      AuthResult result = await auth.signInAnonymously();
      return result;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  ///Signs out the current user, generally not to be used
  Future<bool> signOutUser() async {
    try {
      await auth.signOut();
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  ///Delete the anonymous user, to be done when app session ends
  ///WARNING: this does not delete user firestore data, for that use deleteUserData
  ///Returns true upon succesful deletion, and false if failure
  Future<bool> deleteFirebaseUser() async {
    try {
      FirebaseUser user = await auth.currentUser();
      await user.delete();
      return true;
    } on AuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        AuthResult result = await auth.signInAnonymously();
        FirebaseUser user = result.user;
        await user.delete();
        return true;
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
    return false;
  }
}
