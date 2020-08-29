import 'package:flutter/material.dart';
import 'package:protest_app/common/anon_user.dart';
import 'package:protest_app/common/user_prefs.dart';

///A data class to hold all the data for a single application session
class AppSession {
  AppSession(
      {@required this.isValid, this.deviceID, this.userPrefs, this.user});

  ///Is this a valid app session, that is, are all required fields non-null?
  bool isValid;

  ///The device ID for this session
  String deviceID;

  ///The user preferences for this session
  UserPrefs userPrefs;

  ///The firebase user for this session
  AnonymousUser user;

  ///The error log for the application, logs the integer of the error (error code) and the
  ///string decsribing the error itself
  Map<int, String> errorLog;

  ///Copies the initial app session data from a previously initialized sessoion
  void copyInitialData(AppSession initializedSession) {
    isValid = initializedSession.isValid;
    deviceID = initializedSession.deviceID;
    userPrefs = initializedSession.userPrefs;
    user = initializedSession.user;
    errorLog = initializedSession.errorLog;
  }
}
