import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:protest_app/common/anon_person.dart';

///create an anonymous user
///this user persists over the duration of the application
///destroyed when the application session ends
class AnonymousUser {
  AnonymousUser({@required this.firebaseUser});

  ///The associated firebase user
  final FirebaseUser firebaseUser;

  ///The map of user friends, uids in firebase, and the associated friend objects
  Map<String, AnonymousPerson> userFriendList;

  ///The username (initialized randomly)
  String userName = generateUserName();

  ///Generates a unique username from a list of nouns
  static String generateUserName() {
    Random r = Random();
    return WordPair.random(maxSyllables: 3).toString() +
        "-" +
        (r.nextInt(99) + 1).toString();
  }
}
