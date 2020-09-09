import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';

///model for the settings page
class MessagePageModel extends ChangeNotifier {
  MessagePageModel({@required this.context, @required this.session});

  ///The curent build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///PLACEHOLDER FOR FRIEND NAME
  String friendName = "largefarmer-42";

  ///create a chat user

}
