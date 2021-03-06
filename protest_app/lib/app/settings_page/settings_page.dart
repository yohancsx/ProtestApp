import 'package:flutter/material.dart';
import 'package:protest_app/app/settings_page/settings_page_model.dart';

///The settings page for the application
class SettingsPage extends StatelessWidget {
  SettingsPage({@required this.model});

  ///The page model
  final SettingsPageModel model;

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
              padding: EdgeInsets.only(top: 15.0),
              child: FlatButton(
                onPressed: () => print("saved"),
                child: Text(
                  "Save",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white, fontSize: 30.0),
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
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //padding for the top
            SizedBox(height: size.height * 0.02),

            //title
            Container(
              alignment: Alignment.center,
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: size.height * 0.06),

            //camera settings
            Container(
              alignment: Alignment.center,
              child: ExpansionTile(
                maintainState: true,
                leading: Icon(
                  Icons.camera_alt,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  "Camera Settings",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 30.0),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),

            //Media Sharing settings
            Container(
              alignment: Alignment.center,
              child: ExpansionTile(
                maintainState: true,
                leading: Icon(
                  Icons.photo_album,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  "Media sharing settings",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 30.0),
                ),
                children: [
                  ExpansionTile(
                    title: Text(
                      "Enable Chain Sharing",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 20.0),
                    ),
                    trailing: Checkbox(value: false, onChanged: null),
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                        child: Text(
                          "When enabled, other users can send images you share with them to their friends.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 15.0),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Auto Cache On Delete",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 20.0),
                    ),
                    trailing: Checkbox(value: false, onChanged: null),
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                        child: Text(
                          "When enabled, automatically creates a cache with all your media when you delete your profile. The password is your current username.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 15.0),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.04),

            //location settings
            Container(
              alignment: Alignment.center,
              child: ExpansionTile(
                maintainState: true,
                leading: Icon(
                  Icons.location_pin,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  "Location settings",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 30.0),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),

            //messages and friend settings
            Container(
              alignment: Alignment.center,
              child: ExpansionTile(
                maintainState: true,
                leading: Icon(
                  Icons.people,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  "Messaging and Friend settings",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 30.0),
                ),
                children: [
                  ExpansionTile(
                    title: Text(
                      "Allow Added User Media Messages",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 20.0),
                    ),
                    trailing: Checkbox(value: false, onChanged: null),
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                        child: Text(
                          "When enabled, other users can send you images and videos.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 15.0),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
