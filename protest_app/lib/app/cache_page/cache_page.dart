import 'package:flutter/material.dart';
import 'package:protest_app/app/cache_page/cache_page_model.dart';

class CachePage extends StatelessWidget {
  CachePage({@required this.model});

  ///The cache page model
  final CachePageModel model;

  @override
  Widget build(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 55.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ListView(
          children: [
            //cache name
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Cache name: " + model.cache.cacheName,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.blue),
              ),
            ),

            //cache description
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                model.cache.cacheDescription,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.black),
              ),
            ),

            //cache media
            SizedBox(height: 60.0),
            _buildMediaData(context),

            //download media button
            SizedBox(height: 60.0),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                color: Colors.blue,
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: Colors.blue,
                  onPressed: () => model.downloadCacheMedia(),
                  icon: Icon(
                    Icons.download_sharp,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Get Media",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white, fontSize: 50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Builds the list of media to be selected
  Widget _buildMediaData(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: model.mediaSelectableWidgets,
      ),
    );
  }
}
