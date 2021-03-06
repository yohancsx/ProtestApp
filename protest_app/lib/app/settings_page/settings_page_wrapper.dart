import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/settings_page/settings_page.dart';
import 'package:protest_app/app/settings_page/settings_page_model.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:protest_app/services/user_data_handler_service.dart';
import 'package:provider/provider.dart';

class SettingsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final UserDataHandlerService userDataHandler =
        Provider.of<UserDataHandlerService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);

    return ChangeNotifierProvider<SettingsPageModel>(
      create: (context) => SettingsPageModel(
          context: context, session: session, userDataHandler: userDataHandler),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<SettingsPageModel>(builder: (context, model, child) {
            return SettingsPage(model: model);
          });
        },
      ),
    );
  }
}
