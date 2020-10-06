import 'package:cloud_firestore/cloud_firestore.dart';

///A simple class to hold the basic cache positions and assocated data
///for display on the map page
class CachePosition {
  ///The geopoint of this cache
  GeoPoint point;

  ///The cache id of this cache
  String cacheID;

  ///The description of this cache
  String cacheDescription;

  ///The name of this cache
  String cacheName;
}
