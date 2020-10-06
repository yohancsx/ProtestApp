import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/common/anon_friend.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/media_file.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:uuid/uuid.dart';

///model for the settings page
class MessagePageModel extends ChangeNotifier {
  MessagePageModel(
      {@required this.context,
      @required this.session,
      @required this.cloud,
      @required this.friend}) {
    initializeChatData();
  }

  ///The curent build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///The anonymous friend we are messaging
  AnonymousFriend friend;

  ///The list of chat messages to display
  List<ChatMessage> messages = [];

  ///The chat user (the app user)
  ChatUser user;

  ///The chat user's friend
  ChatUser userFriend;

  ///UUid service
  Uuid uuid = Uuid();

  ///Scroll view
  ScrollController scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  ///initialize the chat users and other data
  void initializeChatData() {
    //set the chat users
    user = ChatUser(
        uid: session.user.firebaseUser.uid,
        name: session.user.userName,
        containerColor: Colors.red[200],
        color: Colors.black);
    userFriend = ChatUser(
        uid: friend.friendId,
        name: friend.friendName,
        containerColor: Colors.blue[200],
        color: Colors.black);
  }

  ///Send a message
  Future<void> sendMessage(ChatMessage message) async {
    //and set message data
    message.id = uuid.v1();
    message.user = user;
    message.createdAt = DateTime.now();

    //send message to database
    try {
      await cloud.sendMessage(friend, message, session);
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
  }

  ///Send a message or messages with media
  void sendMediaMessages(List<MediaFile> messageFiles) async {
    messageFiles.forEach((mediaFile) async {
      //send the message
      ChatMessage message = ChatMessage(text: "new media", user: user);
      message.id = uuid.v1();
      message.createdAt = DateTime.now();
      message.image = mediaFile.fileDownloadURL;
      message.customProperties.addAll({"media_id": mediaFile.mediaId});
      try {
        await cloud.sendMessage(friend, message, session);
      } catch (error) {
        print(error.toString());
      }
    });

    notifyListeners();
  }

  ///Update the messages based on the stream output
  void updateMessages(QuerySnapshot snapshot) {
    //get all the documents
    List<DocumentSnapshot> messageDocuments = snapshot.docs;

    //for each document see if there exists a message for it
    //if not add a message to the list
    messageDocuments.forEach(
      (DocumentSnapshot document) {
        bool documentHasMessage = false;
        messages.forEach(
          (message) {
            if (document.id == message.id) {
              documentHasMessage = true;
            }
          },
        );
        if (documentHasMessage == false) {
          String uidoFSender = document.data()["sent_by"];
          String messageText = document.data()["message_text"];
          String timeCreated = document.data()["time_sent"];
          String imageURL;
          if (document.data().containsKey("download_url")) {
            imageURL = document.data()["download_url"];
          }
          messages.add(ChatMessage(
              id: document.id,
              createdAt: DateTime.tryParse(timeCreated),
              text: messageText,
              user: uidoFSender == user.uid ? user : userFriend,
              image: imageURL));
        }
      },
    );
  }
}
