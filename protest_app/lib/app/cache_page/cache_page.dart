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
        child: FutureBuilder<bool>(
          future: model.fetchCache(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: ListView(
                  children: model.cacheWidgets,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
