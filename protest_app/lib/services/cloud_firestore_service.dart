import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protest_app/common/anon_friend.dart';
import 'package:protest_app/common/anon_user.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/media_file.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

///A service to handle the reading and writing of data to the cloud database
class CloudFirestoreService {
  ///The collection reference for user data
  final CollectionReference userProfileCollection =
      Firestore.instance.collection('user_data');

  ///The collection referencce for message data
  final CollectionReference userMessageCollection =
      Firestore.instance.collection('user_messages');

  ///The collection reference for media metadata
  final CollectionReference mediaMetadataCollection =
      Firestore.instance.collection('media_metadata');

  ///A uuid object to get custom uuids
  Uuid uuid = new Uuid();

  ///Function to initialize anonymous user data for a specific user
  Future<bool> createAnonymousUserData(AnonymousUser user) async {
    try {
      await userProfileCollection.document(user.firebaseUser.uid).setData({
        "time_created": DateTime.now().toString(),
        "user_name": user.userName
      });
    } catch (error) {
      print(error.toString());
      return false;
    }
    return true;
  }

  ///Function to add media metadata to the database
  ///Also adds a reference to the media to the user object
  Future<bool> addMedia(AppSession session, MediaFile imageMedia) async {
    //create the media reference in the database
    try {
      await mediaMetadataCollection.document(imageMedia.mediaId).setData({
        "time_added": imageMedia.creationTime.toString(),
        "download_url": imageMedia.fileDownloadURL,
        "original_device": imageMedia.originalDevice,
        "original_location": imageMedia.location.toString(),
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    //add a reference to the media reference to the user profile
    try {
      await userProfileCollection
          .document(session.user.firebaseUser.uid)
          .collection('user_media')
          .document(imageMedia.mediaId)
          .setData({
        "created_by_user": true,
        "media_id": imageMedia.mediaId,
        "download_url": imageMedia.fileDownloadURL
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    return true;
  }

  ///Function to add another user to the friends list by their uid,
  ///Creates all the necessary friend data in the database, as well as
  ///updates the data on the anonymous friend object passed in
  Future<bool> addFriend(AnonymousFriend friend, AppSession session) async {
    //FIRST check if friend exists, if so get the necessary data
    print("looking for friend");
    DocumentSnapshot friendDoc;
    try {
      friendDoc = await userProfileCollection.document(friend.friendId).get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (friendDoc == null) {
      print("failed to find user");
      return false;
    }

    //the name of the friend
    String friendName = friendDoc.data["user_name"];
    print("found friend $friendName");

    //SECOND create the message data collection to be shared between the friends,
    //and send the initial message (create message document)
    print("creating message document");
    String messageDocumentId = uuid.v1();
    try {
      await userMessageCollection
          .document(messageDocumentId)
          .collection('message_data')
          .document("default_message")
          .setData({
        "message_text": "hello!",
        "time_sent": DateTime.now().toString(),
        "sent_by": session.user.firebaseUser.uid,
        "received_by": friend.friendId,
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    //THIRD add the user to the user friend document for this user
    print("Adding friend");
    try {
      await userProfileCollection
          .document(session.user.firebaseUser.uid)
          .collection('user_friends')
          .document(friend.friendId)
          .setData({
        "time_added": DateTime.now().toString(),
        "message_document": messageDocumentId,
        "friend_name": friendName
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    //FOURTH add the user to the user friend document for the friend
    try {
      await userProfileCollection
          .document(friend.friendId)
          .collection('user_friends')
          .document(session.user.firebaseUser.uid)
          .setData({
        "time_added": DateTime.now().toString(),
        "message_document": messageDocumentId,
        "friend_name": session.user.userName
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    //FIFTH update the friend data for the user friend passed in
    print("finishing up");
    friend.messageDocumentID = messageDocumentId;
    friend.friendName = friendName;

    return true;
  }

  ///Determine if we already have a friend, if so return true
  Future<bool> checkFriendExists(
      AnonymousFriend friend, AppSession session) async {
    DocumentSnapshot friendDocument;
    try {
      friendDocument = await userProfileCollection
          .document(session.user.firebaseUser.uid)
          .collection('user_friends')
          .document(friend.friendId)
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (friendDocument == null) {
      return false;
    } else {
      return true;
    }
  }

  ///Function to refresh new user friends in the database, which are not currently
  ///Added to the user friend list in app.
  Future<bool> refreshFriendsList(AppSession session) async {
    //get friends from database
    QuerySnapshot documents;
    try {
      documents = await userProfileCollection
          .document(session.user.firebaseUser.uid)
          .collection('user_friends')
          .getDocuments();
    } catch (error) {
      print(error.toString());
      return false;
    }

    //reference each document against the existing friends in the friends list
    documents.documents.forEach(
      (documentSnapshot) {
        bool friendExists = false;
        session.user.userFriendList.forEach(
          (userFriend) {
            if (userFriend.friendId == documentSnapshot.documentID) {
              friendExists = true;
            }
          },
        );
        //if any friends in database not on list add to friends list
        if (!friendExists) {
          AnonymousFriend newFriend =
              AnonymousFriend(friendId: documentSnapshot.documentID);
          newFriend.friendName = documentSnapshot.data["friend_name"];
          newFriend.messageDocumentID =
              documentSnapshot.data["message_document"];
          session.user.userFriendList.add(newFriend);
        }
      },
    );

    return true;
  }

  ///A function that deletes all user data from the database and updates any fields
  ///That need to be updated
  Future<bool> deleteAllUserData(FirebaseUser user) async {
    //delete all the friend messages
    QuerySnapshot friendDocuments;
    try {
      friendDocuments = await userProfileCollection
          .document(user.uid)
          .collection('user_friends')
          .getDocuments();
    } catch (error) {
      print(error.toString());
      return false;
    }
    //for each friend
    friendDocuments.documents.forEach((friendDocumentSnapshot) async {
      String messageDocumentID =
          friendDocumentSnapshot.data["message_document"];
      //if a user has already been deleted from message document, then delete the document
      DocumentSnapshot messageData =
          await userMessageCollection.document(messageDocumentID).get();
      if (messageData.data.containsKey("user_deleted")) {
        await userMessageCollection.document(messageDocumentID).delete();
      } else {
        // else denote that user has been deleted
        await userMessageCollection
            .document(messageDocumentID)
            .setData({"user_deleted": user.uid});
      }
    });

    //delete all non-cached media
    //TODO: DELETE ALL NON CACHED MEDIA

    //delete the data under "user_data"
    try {
      await userProfileCollection.document(user.uid).delete();
    } catch (error) {
      print(error.toString());
      return false;
    }
    return true;
  }
}
