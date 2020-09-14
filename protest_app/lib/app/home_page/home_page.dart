import 'package:flutter/material.dart';
import 'package:protest_app/app/camera_page/camera_page_wrapper.dart';
import 'package:protest_app/app/home_page/bottom_nav_bar.dart';
import 'package:protest_app/app/home_page/home_page_model.dart';
import 'package:protest_app/app/map_page/map_page_wrapper.dart';
import 'package:protest_app/app/media_page/media_page_wrapper.dart';
import 'package:protest_app/app/people_page/people_page_wrapper.dart';
import 'package:protest_app/app/retreive_cache_page/retreive_cache_page_wrapper.dart';
import 'package:protest_app/app/settings_page/settings_page_wrapper.dart';
import 'package:protest_app/services/qr_scanner_service.dart';
import 'package:provider/provider.dart';

///The home page for the application
class HomePage extends StatelessWidget {
  HomePage({@required this.model});

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu,
                size: 55.0,
                color: Colors.white,
              ),
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
      bottomNavigationBar: BottomNavBar(
        button1: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPageWrapper())),
        button2: () => model.deleteUserAndClose(),
        button3: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => PeoplePageWrapper())),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        constraints: BoxConstraints.loose(size),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //padding for the top
            SizedBox(height: size.height * 0.02),

            //Scan text
            Container(
              alignment: Alignment.center,
              child: Text(
                model.session.user.userName,
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            //center QR code widget
            Container(
              alignment: Alignment.center,
              child: qrService.getQRCode(
                model.session.user.firebaseUser.uid,
                size.width * 0.75,
              ),
            ),
            SizedBox(height: size.height * 0.03),

            //scan QR button
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                color: Colors.red,
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: Colors.red,
                  onPressed: () => model.processQrScan(),
                  icon: Icon(
                    Icons.fullscreen,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  label: Text(
                    "SCAN QR",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white, fontSize: 50.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            //camera button
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                color: Colors.blue,
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: Colors.blue,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraPageWrapper())),
                  icon: Icon(
                    Icons.camera,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  label: Text(
                    "CAMERA",
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

  //builds the drawer widget
  Widget _buildDrawer(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //header
          DrawerHeader(
            child: Image.asset(
              "assets/images/ProtestAppLogo.png",
              scale: 0.1,
              width: 50,
              height: 50,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          SizedBox(height: size.height * 0.03),

          //settings
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 50.0,
              color: Colors.blue,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPageWrapper()));
            },
          ),
          SizedBox(height: size.height * 0.03),

          //retreive data
          ListTile(
            leading: Icon(
              Icons.insert_drive_file,
              size: 50.0,
              color: Colors.blue,
            ),
            title: Text(
              'Retreive Cache',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RetreivePageWrapper()));
            },
          ),
          SizedBox(height: size.height * 0.03),

          //show help
          ListTile(
            leading: Icon(
              Icons.flag,
              size: 50.0,
              color: Colors.blue,
            ),
            title: Text(
              'Tutorial',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
            ),
            onTap: () {
              //closes drawer
              Navigator.pop(context);
            },
          ),

          SizedBox(height: size.height * 0.45),

          ListTile(
            leading: Icon(
              Icons.help,
              size: 30.0,
              color: Colors.grey,
            ),
            title: Text(
              'About ProtestApp',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
            ),
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
