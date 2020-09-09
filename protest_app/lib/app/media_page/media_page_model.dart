import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';

///Model for the media page
///TODO: add function to get all media on database and show it on this page
class MediaPageModel extends ChangeNotifier {
  MediaPageModel({
    @required this.context,
    @required this.session,
  });

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  Future<bool> refreshMedia() {}
}
