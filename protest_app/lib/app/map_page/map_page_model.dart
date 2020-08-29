import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/maps_service.dart';

///The page model for the map page
class MapPageModel extends ChangeNotifier {
  MapPageModel(
      {@required this.context, @required this.session, @required this.maps});

  ///The build context of the application
  BuildContext context;

  ///The app session
  AppSession session;

  ///The maps service
  MapsService maps;

  ///Initial camera position
  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  ///The map to use for display
  GoogleMap map;

  ///Initialize the google map
  void initializeMap() {
    map = GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {},
    );
  }
}
