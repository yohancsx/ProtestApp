import 'package:flutter/material.dart';

void main() {
  runApp(ProtestApp());
}

class ProtestApp extends StatelessWidget {
  //app root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtestApp',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        color: Colors.white,
        alignment: Alignment.center,
      ),
    );
  }
}

///App wrapper
///basically wraps the wntire app in some providers and streambuilders
///for convenience
///responsible for initializing the app session and other objects
class ProtestAppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement App Wrapper
    return Container();
  }
}
