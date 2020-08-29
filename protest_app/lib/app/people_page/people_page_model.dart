import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';

class PeoplePageModel extends ChangeNotifier {
  PeoplePageModel({
    @required this.context,
    @required this.session,
  });

  ///The build context of the application
  BuildContext context;

  ///The app session
  AppSession session;
}
