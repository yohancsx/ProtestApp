import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/camera_page/camera_page.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/camera_service.dart';
import 'package:protest_app/services/cloud_database_service.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:provider/provider.dart';
import 'camera_page_model.dart';

class CameraPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);

    final CameraService camera =
        Provider.of<CameraService>(context, listen: false);

    final CloudFirestoreService cloud =
        Provider.of<CloudFirestoreService>(context, listen: false);

    final CloudDatabaseService database =
        Provider.of<CloudDatabaseService>(context, listen: false);

    return ChangeNotifierProvider<CameraPageModel>(
      create: (context) => CameraPageModel(
          context: context,
          session: session,
          camera: camera,
          database: database,
          cloud: cloud),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<CameraPageModel>(builder: (context, model, child) {
            return CameraPage(model: model);
          });
        },
      ),
    );
  }
}
