import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:protest_app/services/maps_service.dart';
import 'package:provider/provider.dart';

import 'map_page.dart';
import 'map_page_model.dart';

///The wrapper for the map page
class MapPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    final AppSession session = Provider.of<AppSession>(context, listen: false);

    final MapsService maps = Provider.of<MapsService>(context, listen: false);

    return ChangeNotifierProvider<MapPageModel>(
      create: (context) => MapPageModel(context: context, maps: maps),
      child: StreamBuilder<ConnectivityResult>(
        stream: connect.onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          //return connectivity error page if not connected
          if (snapshot.data == ConnectivityResult.none) {
            return ConnectionErrorPage();
          }
          return Consumer<MapPageModel>(
            builder: (context, model, child) {
              return MapPage(model: model, session: session);
            },
          );
        },
      ),
    );
  }
}