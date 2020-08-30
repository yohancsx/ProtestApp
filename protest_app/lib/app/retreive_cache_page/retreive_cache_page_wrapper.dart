import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/retreive_cache_page/retreive_cache_page.dart';
import 'package:protest_app/app/retreive_cache_page/retreive_cache_page_model.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:provider/provider.dart';

class RetreivePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);

    return ChangeNotifierProvider<RetreivePageModel>(
      create: (context) =>
          RetreivePageModel(context: context, session: session),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<RetreivePageModel>(builder: (context, model, child) {
            return RetreivePage(model: model);
          });
        },
      ),
    );
  }
}
