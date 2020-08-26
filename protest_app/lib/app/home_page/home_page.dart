import 'package:flutter/material.dart';
import 'package:protest_app/app/home_page/home_page_model.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/qr_scanner_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.session, @required this.model});

  ///The application session
  final AppSession session;

  ///The page model
  final HomePageModel model;

  @override
  Widget build(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    //QR code service
    final QrScannerService qrService =
        Provider.of<QrScannerService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: Text("ProtestApp")),
        drawer: _buildDrawer(context),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          constraints: BoxConstraints.loose(size),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //padding for the top
              SizedBox(height: size.height * 0.3),

              //center QR code widget
              Container(
                alignment: Alignment.center,
                child:
                    qrService.getQRCode(session.user.firebaseUser.uid, 120.0),
              ),

              //padding between QR code and photo
              SizedBox(height: size.height * 0.05),

              //take video button
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.video_call),
                    iconSize: 70.0,
                    onPressed: () {
                      print("take photo");
                    },
                    color: Colors.red),
              ),

              //padding between take video and
              SizedBox(height: size.height * 0.01),

              //message button
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.message),
                    iconSize: 70.0,
                    onPressed: () {
                      print("message");
                    },
                    color: Colors.blue),
              ),
            ],
          ),
        ));
  }

  //builds the drawer widget
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('ProtestApp'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              //closes drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              //closes drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
