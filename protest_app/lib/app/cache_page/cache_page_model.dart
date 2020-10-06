import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/cache_page/cache_page.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/cache.dart';
import 'package:protest_app/common/widgets/selectors/checkmark_selector.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';

class CachePageModel extends ChangeNotifier {
  CachePageModel(
      {@required this.context,
      @required this.session,
      @required this.cloud,
      @required this.cacheID});

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///The cache id of the cache to fetch
  String cacheID;

  ///The cache that this page is referring to
  Cache cache = new Cache();

  ///The media selectable widgets for the cache viewing page
  List<Widget> mediaSelectableWidgets = [];

  ///The list of bools, whether the media files can be downloaded
  List<bool> addToMedia = [];

  ///fetches the cache and creates the cache widgets
  Future<bool> fetchCache() async {
    cache.cacheID = cacheID;
    return await cloud.fetchCache(session, cache);
  }

  ///Checks the cache password and if it is correct, the cache
  ///page will be pushed
  void checkCachePass(
      BuildContext context, CachePageModel model, String pass) async {
    if (pass == cache.cachePassword ||
        cache.cachePassword == "1i2g41hv1v8d7f13hbdb1gd91") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CachePage(model: model)));
    }
  }

  ///Create the media selectable widgets
  void createMediaSelectableWidgets() {
    int fileNumber = 0;

    cache.cacheFiles.forEach(
      (mediaFile) {
        //add value if we are adding file to cache
        addToMedia.add(false);

        //add the widget to select the file
        mediaSelectableWidgets.add(
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.network(mediaFile.fileDownloadURL),
                CheckmarkSelector(
                  onChanged: (value) => setMediaFile(fileNumber, value),
                ),
              ],
            ),
          ),
        );

        fileNumber = fileNumber + 1;
      },
    );
  }

  ///Set this caceh file to be added to the media
  void setMediaFile(int fileNumber, bool value) {
    addToMedia[fileNumber] = value;
  }

  ///Download the cache media, and add it to the user profile
  ///also add the references of it in the database
  Future<void> downloadCacheMedia() async {}
}
