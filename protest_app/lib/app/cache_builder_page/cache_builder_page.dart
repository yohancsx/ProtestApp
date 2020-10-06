import 'package:flutter/material.dart';
import 'package:protest_app/app/cache_builder_page/cache_builder_page_model.dart';

class CacheBuilderPage extends StatelessWidget {
  CacheBuilderPage({@required this.model});

  ///The cache page model
  final CacheBuilderPageModel model;

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
            //title
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Set Cache Data",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.blue),
              ),
            ),
            //cache name
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Cache name: " + model.cache.cacheName,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.black),
              ),
            ),

            //set description
            SizedBox(height: 30.0),
            TextField(
              cursorColor: Colors.blue,
              cursorHeight: 40.0,
              cursorWidth: 3.0,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Cache Description'),
              onChanged: (text) {
                model.cache.cacheDescription = text;
              },
            ),

            //set password
            SizedBox(height: 30.0),
            TextField(
              cursorColor: Colors.blue,
              cursorHeight: 40.0,
              cursorWidth: 3.0,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Cache Password (optional)'),
              onChanged: (text) {
                model.cache.cachePassword = text;
              },
            ),

            //the media to be selected
            SizedBox(height: 30.0),
            _buildMediaData(context),

            //submit button
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                color: Colors.red,
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: Colors.red,
                  onPressed: () async => model.checkAndUploadCache(),
                  icon: Icon(
                    Icons.upload_file,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Upload Cache",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white, fontSize: 50.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
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
