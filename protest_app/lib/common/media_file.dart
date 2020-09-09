import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///A media file, associated with it is the original user that created it
///The time that it was created, and a link the the actual file
class MediaFile {
  MediaFile({@required this.isValid});

  ///Is this object valid? That is, are all required fields non null
  bool isValid;

  ///The id of the file
  String mediaId;

  ///The location of the file on the phone
  File mediaFile;

  ///The download URL of the file
  String fileDownloadURL;

  ///The id of the original device creator
  String originalDevice;

  ///Where the file was created orginally
  LatLng location;

  ///When the file was created
  DateTime creationTime;
}
