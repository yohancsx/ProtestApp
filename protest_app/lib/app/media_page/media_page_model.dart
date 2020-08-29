import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';

///Model for the media page
class MediaPageModel extends ChangeNotifier {
  MediaPageModel({
    @required this.context,
    @required this.session,
  });

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;
}
