import 'package:flutter/material.dart';
import 'package:protest_app/app/map_page/map_page_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

///The page to display the map which the user can interact with
class MapPage extends StatelessWidget {
  MapPage({this.model});

  ///The page model
  final MapPageModel model;

  @override
  Widget build(BuildContext context) {
    //initialize the map first
    model.initializeMap();

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
                onPressed: () => model.refreshMap(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              print("marker adding enabled");
              model.markerAddingEnabled = true;
              Fluttertoast.showToast(
                  msg: "Tap on the map to create a cache",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            child: Icon(Icons.location_pin, size: 35.0),
            backgroundColor: Colors.red,
          ),
        ),
      ),
      body: FutureBuilder(
        future: model.initializeMap(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: model.map,
            );
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
    );
  }
}
