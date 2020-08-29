import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///The basic splash page of the application
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.red[900],
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Image.asset(
                "assets/images/ProtestAppLogo.png",
                scale: 0.1,
                width: 200,
                height: 200,
              ),
            ],
          )),
    );
  }
}
