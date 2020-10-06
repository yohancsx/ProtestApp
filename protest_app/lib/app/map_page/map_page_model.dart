import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/app/cache_builder_page/cache_builder_page_wrapper.dart';
import 'package:protest_app/app/cache_page/cache_page_wrapper.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/cache_position.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/maps_service.dart';
import 'package:uuid/uuid.dart';

///The page model for the map page
class MapPageModel extends ChangeNotifier {
  MapPageModel(
      {@required this.context,
      @required this.session,
      @required this.maps,
      @required this.cloud});

  ///The build context of the application
  BuildContext context;

  ///The app session
  AppSession session;

  ///The maps service
  MapsService maps;

  ///The cloud firebase service
  CloudFirestoreService cloud;

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
  void refreshMap() async {
    //update the current location
    await maps.updateCurrentLocation();
    initializeUserMarker(
        LatLng(maps.currentLocation.latitude, maps.currentLocation.longitude));

    //based on this location, get more markers and add to the list
    await fetchNearbyCaches();
    notifyListeners();
  }

  ///Initialize the google map
  Future<bool> initializeMap() async {
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

    //fetch the caches nearby
    await fetchNearbyCaches();

    //create the map
    map = GoogleMap(
      mapType: MapType.hybrid,
      markers: markers,
      initialCameraPosition: initialCameraPosition,
      onTap: (latLng) => addMarker(latLng),
    );

    return true;
  }

  ///A function to fetch all the nearby cache positions from the database, then
  ///create markers for the cache and add them to the markers list
  Future<void> fetchNearbyCaches() async {
    List<CachePosition> caches = [];
    //current location
    LatLng currentLocation =
        LatLng(maps.currentLocation.latitude, maps.currentLocation.longitude);

    bool fetchSuccess =
        await cloud.fetchNearbyCacheIDs(caches, currentLocation, 2.0);

    if (!fetchSuccess) {
      return false;
    }

    caches.forEach((cachePos) {
      //add markers to the map
      markers.add(
        Marker(
          markerId: MarkerId(uuid.v1().toString()),
          position: LatLng(cachePos.point.latitude, cachePos.point.longitude),
          infoWindow: InfoWindow(
            title: "User Cache: " + cachePos.cacheName + ". Tap to access",
            snippet: cachePos.cacheDescription,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CachePageWrapper(cacheID: cachePos.cacheID))),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  ///Adds a marker to the map at the position, which represents a user created cache
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CacheBuilderPageWrapper(position: position))),
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
