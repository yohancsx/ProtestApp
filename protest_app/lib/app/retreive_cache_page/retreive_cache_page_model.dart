import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';

///model for the settings page
class RetreivePageModel extends ChangeNotifier {
  RetreivePageModel({@required this.context, @required this.session});

  ///The curent build context
  BuildContext context;

  ///The app session
  AppSession session;
}
