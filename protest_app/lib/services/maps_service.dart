import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Maps service rsponsible for handling and displaying map and location data
class MapsService {
  ///Instance of location service
  Location location = new Location();

  ///Instance of the google maps object
  Completer<GoogleMapController> mapController = Completer();

  ///Is the location service enabled
  bool serviceEnabled;

  ///Is the location permission granted
  PermissionStatus permissionGranted;

  ///The current location
  LocationData currentLocation;

  ///If we have location enabled, return true
  ///otherwise request location services and return the result
  Future<bool> requestLocationEnabled() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  ///If we have location permission, return true
  ///Otherwise request location services and return the result
  Future<bool> requestLocationPermission() async {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  ///Update the current location so that we can read it
  ///Returns true if we are able to update the location properly
  ///Returns false if permission or locations service is not enabled
  Future<bool> updateCurrentLocation() async {
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
      return true;
    } else {
      return false;
    }
  }
}
