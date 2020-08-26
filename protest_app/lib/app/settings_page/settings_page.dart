import 'package:flutter/material.dart';
import 'package:protest_app/app/settings_page/settings_page_model.dart';
import 'package:protest_app/common/app_session.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({@required this.model, @required this.session});

  ///The application session
  final AppSession session;

  ///The page model
  final SettingsPageModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
