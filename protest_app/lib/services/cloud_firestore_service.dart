import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/common/anon_friend.dart';
import 'package:protest_app/common/anon_user.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/cache.dart';
import 'package:protest_app/common/media_file.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

///A service to handle the reading and writing of data to the cloud database
class CloudFirestoreService {
  ///The collection reference for user data
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('user_data');

  ///The collection referencce for message data
  final CollectionReference userMessageCollection =
      FirebaseFirestore.instance.collection('user_messages');

  ///The collection reference for media metadata
  final CollectionReference mediaMetadataCollection =
      FirebaseFirestore.instance.collection('media_metadata');

  ///The collection reference for caches
  final CollectionReference cacheCollection =
      FirebaseFirestore.instance.collection('cache_data');

  ///Initialize the geo flutter plugin
  final geo = Geoflutterfire();

  ///A uuid object to get custom uuids
  Uuid uuid = new Uuid();

  //TODO: implement better object serialization
  //TODO: implement end to end encryption?

  ///Function to initialize anonymous user data for a specific user
  Future<bool> createAnonymousUserData(AnonymousUser user) async {
    try {
      await userProfileCollection.doc(user.firebaseUser.uid).set({
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
      await mediaMetadataCollection.doc(imageMedia.mediaId).set({
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
          .doc(session.user.firebaseUser.uid)
          .collection('user_media')
          .doc(imageMedia.mediaId)
          .set({
        "time_added": imageMedia.creationTime.toString(),
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
      friendDoc = await userProfileCollection.doc(friend.friendId).get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (friendDoc == null) {
      print("failed to find user");
      return false;
    }

    //the name of the friend
    String friendName = friendDoc.data()["user_name"];
    print("found friend $friendName");

    //SECOND create the message data collection to be shared between the friends,
    //and send the initial message (create message document)
    print("creating message document");
    String messageDocumentId = uuid.v1();
    try {
      await userMessageCollection
          .doc(messageDocumentId)
          .collection('message_data')
          .doc("default_message")
          .set({
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
          .doc(session.user.firebaseUser.uid)
          .collection('user_friends')
          .doc(friend.friendId)
          .set({
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
          .doc(friend.friendId)
          .collection('user_friends')
          .doc(session.user.firebaseUser.uid)
          .set({
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
    print("checking for friend");
    DocumentSnapshot friendDocument;
    try {
      friendDocument = await userProfileCollection
          .doc(session.user.firebaseUser.uid)
          .collection('user_friends')
          .doc(friend.friendId)
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (friendDocument == null) {
      print("friend not found");
      return false;
    } else {
      print("friend found");
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
          .doc(session.user.firebaseUser.uid)
          .collection('user_friends')
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    //reference each document against the existing friends in the friends list
    documents.docs.forEach(
      (documentSnapshot) {
        bool friendExists = false;
        session.user.userFriendList.forEach(
          (userFriend) {
            if (userFriend.friendId == documentSnapshot.id) {
              friendExists = true;
            }
          },
        );
        //if any friends in database not on list add to friends list
        if (!friendExists) {
          AnonymousFriend newFriend =
              AnonymousFriend(friendId: documentSnapshot.id);
          newFriend.friendName = documentSnapshot.data()["friend_name"];
          newFriend.messageDocumentID =
              documentSnapshot.data()["message_document"];
          session.user.userFriendList.add(newFriend);
        }
      },
    );

    return true;
  }

  ///A function that deletes all user data from the database and updates any fields
  ///That need to be updated
  Future<bool> deleteAllUserData(User user) async {
    //delete all the friend messages
    QuerySnapshot friendDocuments;
    try {
      friendDocuments = await userProfileCollection
          .doc(user.uid)
          .collection('user_friends')
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }
    //for each friend
    friendDocuments.docs.forEach(
      (friendDocumentSnapshot) async {
        String messageDocumentID =
            friendDocumentSnapshot.data()["message_document"];
        //if a user has already been deleted from message document, then delete the document
        DocumentSnapshot messageData =
            await userMessageCollection.doc(messageDocumentID).get();
        if (messageData.data != null) {
          if (messageData.data().containsKey("user_deleted")) {
            await userMessageCollection.doc(messageDocumentID).delete();
          } else {
            // else denote that user has been deleted
            await userMessageCollection.doc(messageDocumentID).set(
              {"user_deleted": user.uid},
            );
          }
        }
      },
    );

    //delete all non-cached media
    //TODO: DELETE ALL NON CACHED MEDIA

    //delete the data under "user_data"
    try {
      await userProfileCollection.doc(user.uid).delete();
    } catch (error) {
      print(error.toString());
      return false;
    }
    return true;
  }

  ///Returns a stream of message data based on the user and the user friend
  ///used to build the messages page
  Stream<QuerySnapshot> getMessageStream(AnonymousFriend friend) {
    return userMessageCollection
        .doc(friend.messageDocumentID)
        .collection('message_data')
        .snapshots();
  }

  ///Send a message to a user friend
  Future<bool> sendMessage(AnonymousFriend friend, ChatMessage message) async {
    try {
      await userMessageCollection
          .doc(friend.messageDocumentID)
          .collection('message_data')
          .doc(message.id)
          .set({
        "message_text": message.text,
        "time_sent": message.createdAt.toString(),
        "sent_by": message.user.uid,
        "received_by": friend.friendId,
      });
    } catch (error) {
      print(error.toString());
      return false;
    }
    return true;
  }

  ///Fetches any media data on the database that is not included in the session
  ///List of media already
  Future<bool> refreshMedia(AppSession session) async {
    ///get all documents in media collection
    QuerySnapshot mediaDocuments;
    try {
      mediaDocuments = await userProfileCollection
          .doc(session.user.firebaseUser.uid)
          .collection('user_media')
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    //if no documents then don't add anything to the session
    if (mediaDocuments.docs.isEmpty) {
      return false;
    }

    //For each, if any are not in the session's media data, then add them
    bool mediaDataExists = false;
    mediaDocuments.docs.forEach(
      (document) {
        session.mediaFiles.forEach(
          (mediaFile) {
            if (document.id == mediaFile.mediaId) {
              mediaDataExists = true;
            }
          },
        );

        //if the data does not exist already, add it
        if (!mediaDataExists) {
          MediaFile newFile = MediaFile(isValid: true);
          newFile.creationTime =
              DateTime.tryParse(document.data()["time_added"]);
          newFile.mediaId = document.id;
          newFile.fileDownloadURL = document.data()["download_url"];
          session.mediaFiles.add(newFile);
        }
      },
    );

    return true;
  }

  ///Fetches a cache from the database, populates the cache object passed in
  ///and put a reference to the cache in the user data, aso populates
  ///all the media data objects in the cache
  Future<bool> fetchCache(AppSession session, Cache cache) async {
    //get the basic cache data
    DocumentSnapshot cacheDocument;
    try {
      cacheDocument = await cacheCollection.doc(cache.cacheID).get();
    } catch (error) {
      print(error.toString());
    }

    if (cacheDocument == null) {
      cache.isValid = false;
      return false;
    }

    //set the basic cache data
    cache.cacheDescription = cacheDocument.data()["cache_description"];
    cache.cacheName = cacheDocument.data()["cache_name"];
    cache.cacheID = cacheDocument.data()["cache_id"];
    cache.cacheLocation = LatLng(cacheDocument.data()["cache_latitude"],
        cacheDocument.data()["cache_longitude"]);
    cache.cacheDescription = cacheDocument.data()["cache_description"];
    cache.originalDeviceID = cacheDocument.data()["cache_device_id"];
    cache.originalUserID = cacheDocument.data()["cache_user"];

    //get the media files from the cache
    QuerySnapshot cacheMediaDocuments;
    try {
      cacheMediaDocuments = await cacheCollection
          .doc(cache.cacheID)
          .collection('cache_media')
          .get();
    } catch (error) {
      print(error.toString());
      return false;
    }

    //if no documents then there is an error
    if (cacheMediaDocuments.docs.isEmpty) {
      cache.isValid = false;
      return false;
    }

    //set the media files in the cache
    cacheMediaDocuments.docs.forEach((mediaDocument) {
      MediaFile cacheFile = MediaFile(isValid: true);
      cacheFile.fileDownloadURL = mediaDocument.data()["download_url"];
      cacheFile.creationTime = mediaDocument.data()["time_added"];
      cacheFile.mediaId = mediaDocument.data()["media_id"];
      cache.cacheFiles.add(cacheFile);
    });

    //set the cache reference in the user data
    try {
      await userProfileCollection
          .doc(session.user.firebaseUser.uid)
          .collection('user_caches')
          .doc(cache.cacheID)
          .set({
        "cache_name": cache.cacheName,
        "cache_id": cache.cacheID,
        "cache_latitude": cache.cacheLocation.latitude,
        "cache_longitude": cache.cacheLocation.longitude,
        "cache_description": cache.cacheDescription,
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    return true;
  }

  ///Uploads a cache to the database, adds to the user caches in the user document
  ///Also updates the cache metadata
  Future<bool> uploadCache(AppSession session, Cache cache) async {
    //set the basic cache data
    try {
      await cacheCollection.doc(cache.cacheID).set({
        "cache_name": cache.cacheName,
        "cache_id": cache.cacheID,
        "cache_latitude": cache.cacheLocation.latitude,
        "cache_longitude": cache.cacheLocation.longitude,
        "cache_description": cache.cacheDescription,
        "cache_user": cache.originalUserID,
        "cache_device_id": cache.originalDeviceID,
      });
    } catch (error) {
      print(error.toString());
    }

    //for all the cache media, set the data in the cache media collection
    cache.cacheFiles.forEach((mediaFile) async {
      try {
        await cacheCollection
            .doc(cache.cacheID)
            .collection('cache_media')
            .doc(mediaFile.mediaId)
            .set({
          "time_added": mediaFile.creationTime.toString(),
          "media_id": mediaFile.mediaId,
          "download_url": mediaFile.fileDownloadURL
        });
      } catch (error) {
        print(error.toString());
        return false;
      }
    });

    //add the cache data to the user document
    try {
      await userProfileCollection
          .doc(session.user.firebaseUser.uid)
          .collection('user_caches')
          .doc(cache.cacheID)
          .set({
        "cache_name": cache.cacheName,
        "cache_id": cache.cacheID,
        "cache_latitude": cache.cacheLocation.latitude,
        "cache_longitude": cache.cacheLocation.longitude,
        "cache_description": cache.cacheDescription,
      });
    } catch (error) {
      print(error.toString());
      return false;
    }

    return true;
  }

  ///Fetches a list of cache ids whiwh are near the given user location
  Future<bool> fetchNearbyCacheIDs(List<String> cacheIDs) async {}
}
