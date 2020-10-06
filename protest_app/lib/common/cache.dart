import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/common/media_file.dart';

class Cache {
  ///is theis object valid
  bool isValid;

  ///The cache id
  String cacheID;

  ///The cache name
  String cacheName;

  ///Original device where the cache was created
  String originalDeviceID;

  ///Original user who created the cache
  String originalUserID;

  ///The location of the cache
  LatLng cacheLocation;

  ///The description of the cache
  String cacheDescription;

  ///The cache password (if it exists)
  String cachePassword = "1i2g41hv1v8d7f13hbdb1gd91";

  ///Media files associated with the cache
  List<MediaFile> cacheFiles = [];
}
