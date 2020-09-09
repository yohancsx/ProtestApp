import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';

class PeoplePageModel extends ChangeNotifier {
  PeoplePageModel({
    @required this.context,
    @required this.session,
    @required this.cloud,
  });

  ///The build context of the application
  BuildContext context;

  ///The app session
  AppSession session;

  ///The Cloud firestore service
  CloudFirestoreService cloud;

  ///Number of refreshes
  int numRefreshes = 0;

  ///A function that simply rebuilds, thus refreshes the page
  void refreshPage() {
    numRefreshes++;
    notifyListeners();
  }
}
