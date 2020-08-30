import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/camera_page/camera_page_model.dart';
import 'package:protest_app/app/media_page/media_page_wrapper.dart';

class CameraPage extends StatelessWidget {
  CameraPage({@required this.model});

  ///The page model
  final CameraPageModel model;

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
              padding: EdgeInsets.only(right: 20.0, top: 5.0),
              child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MediaPageWrapper())),
                icon: Icon(
                  Icons.perm_media,
                  size: 45.0,
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
        child: FutureBuilder<void>(
          future: model.camera.initializeCameraService(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(model.camera.cameraController),

                  //take photo button
                  Positioned(
                    bottom: size.height * 0.02,
                    left: size.height * 0.04,
                    child: IconButton(
                      iconSize: 100.0,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.red,
                        size: 100.0,
                      ),
                      onPressed: () => print("taking picture"),
                    ),
                  ),

                  //take video button
                  Positioned(
                    bottom: size.height * 0.01,
                    right: size.height * 0.04,
                    child: IconButton(
                      iconSize: 120.0,
                      icon: Icon(
                        Icons.videocam,
                        color: Colors.blue,
                        size: 120.0,
                      ),
                      onPressed: () => print("taking video"),
                    ),
                  ),

                  //settings
                  Positioned(
                    top: size.height * 0.01,
                    right: size.height * 0.0,
                    child: IconButton(
                      iconSize: 70.0,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 70.0,
                      ),
                      onPressed: () => print("camera settings"),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
