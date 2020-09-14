import 'package:flutter/material.dart';
import 'package:protest_app/app/media_page/media_page_model.dart';

///A class to show and display media of the user
class MediaPage extends StatelessWidget {
  MediaPage({@required this.model});

  ///The page model
  final MediaPageModel model;

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
          actions: [
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: IconButton(
                onPressed: () => model.refreshAndLookForMedia(),
                icon: Icon(
                  Icons.refresh,
                  size: 55.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        constraints: BoxConstraints.loose(size),
        child: FutureBuilder(
          future: model.refreshMediaList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //padding from top
                  SizedBox(height: size.height * 0.03),

                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Media",
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  //list view
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: size.height * 0.82,
                      child: ListView(
                        children: model.mediaItems,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
