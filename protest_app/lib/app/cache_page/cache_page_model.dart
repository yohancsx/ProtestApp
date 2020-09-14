import 'package:flutter/cupertino.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/cache.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';

class CachePageModel extends ChangeNotifier {
  CachePageModel(
      {@required this.context, @required this.session, @required this.cloud});

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///The cache id of the cache to fetch
  String cacheID;

  ///The cache that this page is referring to
  Cache cache;

  ///The cache widgets to display
  List<Widget> cacheWidgets = [];

  ///fetches the cache and creates the cache widgets
  Future<bool> fetchCache() async {
    return await cloud.fetchCache(session, cache);
  }
}
