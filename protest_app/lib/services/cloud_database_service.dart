import 'package:cloud_firestore/cloud_firestore.dart';

///A class to push and pull data from the google cloud firestore
class CloudDatabaseService {
  ///The cloud database service
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  /// Add a friend by the uid
  Future<bool> addFriend(String friendUid, String uid) {
    userCollection.document(uid).collection('friends').document(friendUid);
  }

  //TODO: a stream to expose messages from friends

  //TODO: upload the anonymous user to the database

  //TODO: remove an anonymous user from the database
}
