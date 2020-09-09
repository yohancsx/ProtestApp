import 'package:flutter/cupertino.dart';

///A class to hold the anonymous person, or friend that the user will add
class AnonymousFriend {
  AnonymousFriend({@required this.friendId});

  ///The firebase friend ID of the friend
  String friendId;

  ///If the friend is blocked or not
  bool isBlocked = false;

  ///The name of the friend
  String friendName;

  ///The message document id for the friend, to retreive messages in the database
  String messageDocumentID;
}
