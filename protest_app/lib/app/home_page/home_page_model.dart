import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protest_app/common/anon_friend.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/cloud_firestore_service.dart';
import 'package:protest_app/services/firebase_auth_service.dart';
import 'package:protest_app/services/qr_scanner_service.dart';

///The model for the home page of the app
class HomePageModel extends ChangeNotifier {
  HomePageModel(
      {@required this.context,
      @required this.session,
      @required this.qr,
      @required this.auth,
      @required this.cloud});

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The qr scanner service
  QrScannerService qr;

  ///The firebase auth service
  FirebaseAuthService auth;

  ///The cloud firestore service
  CloudFirestoreService cloud;

  ///Processes a QR code scan, attempts to add the user as a friend by the uid scanned
  void processQrScan() async {
    String scanResult;
    try {
      scanResult = await qr.scanQRcode();
    } catch (error) {
      print(error.toString());
      return null;
    }
    print(scanResult);

    //if the user chose not to scan, cancel the operation
    if (scanResult == null) {
      print("scan canceled");
      return;
    }

    //show loading icon
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Adding User....",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red, fontSize: 20),
                ),
              ),
              SizedBox(height: 40.0),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

    //create a friend
    AnonymousFriend friend = AnonymousFriend(friendId: scanResult);

    //if we added the friend
    bool friendAdded = false;

    //Check if we already have the friend
    bool friendExists = await cloud.checkFriendExists(friend, session);

    if (friendExists) {
      //fetch try and add the user to the added users list in the database and
      //create all the necsessary databse documents
      friendAdded = await cloud.addFriend(friend, session);
    }
    Navigator.of(context).pop();

    //then add to the list of friends on the app
    //then show dialouge for a few seconds
    if (friendAdded) {
      session.user.userFriendList.add(friend);
      print("success! friend added");
      _showSuccessDialouge(friend);
    } else {
      _showFailureDialouge();
    }
  }

  ///Delete the user and close the app, with warning dialogue
  void deleteUserAndClose() async {
    bool result = false;
    print("quitting");
    try {
      result = await auth.deleteFirebaseUser();
      //TODO: delete the firebase storage data depending on the setting
      result = await cloud.deleteAllUserData(session.user.firebaseUser);
    } catch (error) {
      print(error.toString());
    }
    if (result == true) {
      //CLOSE THE APP
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      //return a failure dialouge for a few seconds
      //CLOSE THE APP
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  ///Shows the success dialouge for adding a friend
  void _showSuccessDialouge(AnonymousFriend friend) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User Added!"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("You have added the user " + friend.friendName + "."),
                Text("You can now message and share data with this user."),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///Shows the failure dialouge for adding a friend
  void _showFailureDialouge() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Unable to add user! Perhaps you already added them?"),
                Text("If not, check your connection and try scanning again."),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
