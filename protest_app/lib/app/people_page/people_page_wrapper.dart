import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/people_page/people_page.dart';
import 'package:protest_app/app/people_page/people_page_model.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:provider/provider.dart';

///Wrapper for the people page
class PeoplePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);

    final CloudFirestoreService cloud =
        Provider.of<CloudFirestoreService>(context, listen: false);

    return ChangeNotifierProvider<PeoplePageModel>(
      create: (context) =>
          PeoplePageModel(context: context, session: session, cloud: cloud),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<PeoplePageModel>(
            builder: (context, model, child) {
              return PeoplePage(model: model);
            },
          );
        },
      ),
    );
  }
}
