import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';

///Model for the media page
class MediaPageModel extends ChangeNotifier {
  MediaPageModel(
      {@required this.context, @required this.session, @required this.cloud});

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The list of widgets of media items
  List<Widget> mediaItems = [];

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///Refreshes the media items
  Future<bool> refreshMediaList() async {
    //add missing media references to the session
    bool mediaRefreshed = await cloud.refreshMedia(session);

    //if we failed at refreshing the media data
    if (!mediaRefreshed) {
      return false;
    }

    //create the image widget and use the url to show the image, recreate the list
    List<Widget> itemsList = [];

    itemsList.add(SizedBox(height: 30.0));
    itemsList.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Media",
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.blue, fontSize: 50),
        )));
    itemsList.add(SizedBox(height: 30.0));

    session.mediaFiles.forEach((mediaFile) {
      itemsList.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          color: Colors.red,
          child: Stack(
            children: [
              Image.network(mediaFile.fileDownloadURL),
              Text(mediaFile.creationTime.toString())
            ],
          ),
        ),
      );
      itemsList.add(SizedBox(height: 20.0));
    });
    itemsList.add(SizedBox(height: 30.0));
    itemsList.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Add media to see it here!",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.red, fontSize: 20),
        )));

    mediaItems = itemsList;

    return true;
  }

  ///Refreshes the media items and also refreshes the page
  void refreshAndLookForMedia() async {
    await refreshMediaList();
    notifyListeners();
  }
}
