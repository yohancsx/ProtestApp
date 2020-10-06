import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/app/cache_builder_page/cache_builder_page.dart';
import 'package:protest_app/app/cache_builder_page/cache_builder_page_model.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:provider/provider.dart';

///Wrapper for the cache builder page
class CacheBuilderPageWrapper extends StatelessWidget {
  CacheBuilderPageWrapper({@required this.position});

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);
    final CloudFirestoreService cloud =
        Provider.of<CloudFirestoreService>(context, listen: false);

    return ChangeNotifierProvider<CacheBuilderPageModel>(
      create: (context) => CacheBuilderPageModel(
          context: context, session: session, cloud: cloud, position: position),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<CacheBuilderPageModel>(
              builder: (context, model, child) {
            return CacheBuilderPage(model: model);
          });
        },
      ),
    );
  }
}
