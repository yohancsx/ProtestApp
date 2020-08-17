import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

///create an anonymous user
///this user persists over the duration of the application
///destroyed when the application session ends
class AnonymousUser {
  AnonymousUser({@required this.firebaseUser});

  ///The associated firebase user
  final FirebaseUser firebaseUser;

  ///The username (initialized randomly)
  String userName = generateUserName();

  ///Generates a unique username from a list of nouns
  static String generateUserName() {
    return WordPair.random(maxSyllables: 3).toString();
  }
}
