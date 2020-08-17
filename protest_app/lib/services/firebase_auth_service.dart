import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  ///Firebase authentication instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///Create a Firebase user, which will persist while the app is active
  ///Returns null and prints error if failure
  Future<FirebaseUser> createFirebaseUser() async {
    try {
      AuthResult result = await auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
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

  ///Delete the user session data, to be done when the session ends
  ///Returns true upon deletion, false if failure
  Future<bool> deleteUserData(FirebaseUser user) async {}
}
