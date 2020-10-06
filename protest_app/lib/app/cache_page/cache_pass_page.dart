import 'package:flutter/material.dart';
import 'package:protest_app/app/cache_page/cache_page.dart';
import 'package:protest_app/app/cache_page/cache_page_model.dart';
import 'package:provider/provider.dart';

class CachePassPage extends StatelessWidget {
  CachePassPage({@required this.model});

  final CachePageModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        //fetch the cache
        child: FutureBuilder<bool>(
          future: model.fetchCache(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              //create the widgets to show the media of the cache
              model.createMediaSelectableWidgets();

              //if we have no password, return the cache page
              if (model.cache.cachePassword == "1i2g41hv1v8d7f13hbdb1gd91") {
                return ChangeNotifierProvider<CachePageModel>(
                  create: (context) => model,
                  child: Consumer<CachePageModel>(
                    builder: (context, model, child) {
                      return CachePage(model: model);
                    },
                  ),
                );
              } else {
                //if we have a password, request password then check
                return TextField(
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
                      hintText: 'Enter Cache Password To Access'),
                  onChanged: (text) {
                    model.checkCachePass(context, model, text);
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
