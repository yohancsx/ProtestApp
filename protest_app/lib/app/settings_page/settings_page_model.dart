import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/user_data_handler_service.dart';

///model for the settings page
class SettingsPageModel extends ChangeNotifier {
  SettingsPageModel(
      {@required this.context,
      @required this.session,
      @required this.userDataHandler});

  ///The curent build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The user data handler service
  UserDataHandlerService userDataHandler;

  ///save all the data in the appsession to the disk
  void onSave() async {
    userDataHandler.writeUserPrefs(session.userPrefs);
  }
}
