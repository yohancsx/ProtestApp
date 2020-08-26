import 'dart:core';
import 'package:flutter/material.dart';

///creates a user preferences, this persists through the app session
///these are also reread from the disk upon each session
class UserPrefs {
  UserPrefs({@required this.isValid});

  ///Is this object valid?
  bool isValid;

  ///Is the user new? Set to false after user preferences is saved
  bool isNew = false;

  ///Does the user want to share location on map by default?
  bool shareLocation = false;

  ///Does the user want to share videos and images by default with contacts?
  bool shareMedia = false;

  ///Does the user enable location-dropping of media by default?
  bool enableLocationDropping = false;

  ///Does the user enable chain sharing of media?
  bool enableChainSharing = false;
}
