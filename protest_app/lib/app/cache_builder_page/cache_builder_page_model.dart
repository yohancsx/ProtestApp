import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/cache.dart';
import 'package:protest_app/common/widgets/alert_dialouges/single_button_alert.dart';
import 'package:protest_app/common/widgets/selectors/checkmark_selector.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:uuid/uuid.dart';

class CacheBuilderPageModel extends ChangeNotifier {
  CacheBuilderPageModel(
      {@required this.context,
      @required this.session,
      @required this.cloud,
      @required this.position}) {
    setCacheId();
    createMediaSelectableWidgets();
  }

  ///The current build context
  BuildContext context;

  ///Position of the cache
  LatLng position;

  ///The app session
  AppSession session;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///The cache that this page is going to create
  ///we set all this data
  Cache cache;

  ///The uuid service
  Uuid uuid = new Uuid();

  ///The media widgets that allow we can select
  List<Widget> mediaSelectableWidgets = [];

  ///The list of bools, whether the media files should be added to the cache
  List<bool> addToCache = [];

  ///uploads the cache after it is created, also checks if the data is correct
  Future<void> checkAndUploadCache() async {
    //set the device id and user id for the cache
    cache.originalDeviceID = session.deviceID;
    cache.originalUserID = session.user.firebaseUser.uid;
    cache.cacheLocation = position;

    //if no description, then shrow an error
    if (cache.cacheDescription == null) {
      showCacheCreationError("Please set a decsription for this cache");
      return false;
    }

    //if no media selected, shrow an error
    if (!addToCache.contains(true)) {
      showCacheCreationError(
          "please select one or more media files for the cache");
      return false;
    }

    //add all selected media files to cache
    int index = 0;
    session.mediaFiles.forEach((mediaFile) {
      if (addToCache[index]) {
        cache.cacheFiles.add(mediaFile);
      }
      index = index + 1;
    });

    //upload the cache
    bool cacheUploaded = await cloud.uploadCache(session, cache);

    //show a success
    if (cacheUploaded) {
      showCacheCreationError("Cache created and uploaded");
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return SingleButtonAlert(
            title: "Cache Creation Error",
            bodyText:
                "Error in cache Creation, pleasecheck your connection and try again",
            onSubmit: () => Navigator.of(context).pop(),
          );
        },
      );
    }

    Navigator.of(context).pop();
  }

  ///Create and set the cache and cache id
  void setCacheId() {
    cache = Cache();
    cache.cacheID = uuid.v1();
    cache.cacheName =
        WordPair.random().toString() + WordPair.random().toString();
  }

  ///Show a cache creation error message
  void showCacheCreationError(String errorMessage) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  ///Set this media file to be added to the cache
  void setMediaFile(int fileNumber, bool value) {
    addToCache[fileNumber] = value;
  }

  ///Create the media selectable widgets
  void createMediaSelectableWidgets() {
    int fileNumber = -1;

    session.mediaFiles.forEach(
      (mediaFile) {
        //add value if we are adding file to cache
        addToCache.add(false);

        //add the widget to select the file
        mediaSelectableWidgets.add(
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.network(mediaFile.fileDownloadURL),
                CheckmarkSelector(
                    onChanged: (value) => setMediaFile(fileNumber, value)),
              ],
            ),
          ),
        );

        fileNumber = fileNumber + 1;
      },
    );
  }
}
