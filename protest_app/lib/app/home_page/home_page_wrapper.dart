import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:protest_app/services/firebase_auth_service.dart';
import 'package:protest_app/services/qr_scanner_service.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'home_page_model.dart';

class HomePageWrapper extends StatelessWidget {
  HomePageWrapper({this.session});

  ///The application session
  final AppSession session;

  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final QrScannerService qr =
        Provider.of<QrScannerService>(context, listen: false);

    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);

    final CloudFirestoreService cloud =
        Provider.of<CloudFirestoreService>(context, listen: false);

    return ChangeNotifierProvider<HomePageModel>(
      create: (context) => HomePageModel(
          context: context, session: session, qr: qr, auth: auth, cloud: cloud),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<HomePageModel>(builder: (context, model, child) {
            return HomePage(model: model);
          });
        },
      ),
    );
  }
}
