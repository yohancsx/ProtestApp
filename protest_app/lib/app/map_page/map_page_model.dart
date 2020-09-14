import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/app/cache_page/cache_page_wrapper.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/maps_service.dart';
import 'package:uuid/uuid.dart';

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

  ///The map to use for display
  GoogleMap map;

  ///The markers on the map
  Set<Marker> markers = {};

  ///The uuid service
  Uuid uuid = Uuid();

  ///A bool to say if we can add markers
  bool markerAddingEnabled = false;

  ///Refreshes the map page, by updating the user location and
  ///adding any nearby caches
  void refreshMap() {
    //update the current location
    maps.updateCurrentLocation();
    initializeUserMarker(
        LatLng(maps.currentLocation.latitude, maps.currentLocation.longitude));

    //TODO: based on this location, get more markers and add to the list

    notifyListeners();
  }

  ///Initialize the google map
  void initializeMap() {
    //set the initial position found by user location
    CameraPosition initialCameraPosition = CameraPosition(
      target:
          LatLng(maps.currentLocation.latitude, maps.currentLocation.longitude),
      zoom: 18.0,
    );

    //initialize the user marker
    maps.updateCurrentLocation();
    initializeUserMarker(
        LatLng(maps.currentLocation.latitude, maps.currentLocation.longitude));

    //create the map
    map = GoogleMap(
      mapType: MapType.hybrid,
      markers: markers,
      initialCameraPosition: initialCameraPosition,
      onTap: (latLng) => addMarker(latLng),
    );
  }

  ///TODO: A function to fetch all the nearby cache positions from the database, then
  ///create markers for the cache and add them to the map
  ///

  ///Adds a marker to the map at the position
  void addMarker(LatLng position) {
    if (markerAddingEnabled) {
      markers.add(
        Marker(
          markerId: MarkerId(uuid.v1().toString()),
          position: position,
          infoWindow: InfoWindow(
            title: "New Cache",
            snippet: "Click to set the cache data",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CachePageWrapper())),
        ),
      );
    }
    markerAddingEnabled = false;
    notifyListeners();
  }

  ///Initialize the initial map markers
  void initializeUserMarker(LatLng location) {
    markers.add(Marker(
      markerId: MarkerId(session.user.userName),
      position: location,
      infoWindow: InfoWindow(
        title: session.user.userName,
        snippet: "Your position.",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ));
  }
}
