import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/media_file.dart';
import 'package:protest_app/services/camera_service.dart';
import 'package:protest_app/services/cloud_database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';

///model for the settings page
class CameraPageModel extends ChangeNotifier {
  CameraPageModel(
      {@required this.context,
      @required this.session,
      @required this.camera,
      @required this.database,
      @required this.cloud});

  ///The curent build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The camera service
  CameraService camera;

  ///The database service, for storing images
  CloudDatabaseService database;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///The Uuid generator
  Uuid uuid = Uuid();

  ///Take a picture, store, and upload to the database
  ///Then add to taken images in the session
  Future<bool> takeAndStoreImage() async {
    String imageID = uuid.v1();
    String filePath;

    //take the image
    try {
      filePath = await camera.takeImage(imageID);
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (filePath == null) {
      return false;
    }

    //create an image media object
    MediaFile imageMedia = MediaFile(isValid: false);
    //set the id
    imageMedia.mediaId = imageID;
    //set the file on phone
    imageMedia.mediaFile = File(filePath);

    //if we have a file, store it on the database
    bool fileStored;
    try {
      fileStored = await database.storeImage(imageMedia, session);
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (!fileStored) {
      return false;
    }

    //link the file to the metadata under the user in the database
    bool mediaAdded;
    try {
      mediaAdded = await cloud.addMedia(session, imageMedia);
    } catch (error) {
      print(error.toString());
      return false;
    }

    if (!mediaAdded) {
      return false;
    }

    //add the media file to the list if media files in the session
    imageMedia.isValid = true;
    session.mediaFiles.add(imageMedia);

    //show a small toast that we have taken and uploaded the image
    Fluttertoast.showToast(
        msg: "Taken and Uploaded Image!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    return true;
  }
}
