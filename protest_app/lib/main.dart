import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/widgets/connection_error_page.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:protest_app/services/firebase_auth_service.dart';
import 'package:protest_app/services/maps_service.dart';
import 'package:protest_app/services/qr_scanner_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ProtestApp());
}

class ProtestApp extends StatelessWidget {
  //app root
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //Maps service
          Provider<MapsService>(
            create: (_) => MapsService(),
          ),
          //QR scanner service
          Provider<QrScannerService>(
            create: (_) => QrScannerService(),
          ),
          //Firebase auth service
          Provider<FirebaseAuthService>(
            create: (_) => FirebaseAuthService(),
          ),
          //Connection service
          Provider<ConnectionService>(
            create: (_) => ConnectionService(),
          ),
          //additional services below
        ],
        child: MaterialApp(
          title: 'ProtestApp',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Container(
            color: Colors.red,
            alignment: Alignment.center,
          ),
        ));
  }
}

///App wrapper
///basically wraps the wntire app in some providers and streambuilders
///for convenience
///responsible for initializing the app session and other objects
class ProtestAppWrapper extends StatelessWidget {
  ///Completes multiple futures in order to setup the app.
  ///Will display a corrosponding error if any of the futures fail.
  ///1. Checks connection
  ///2. Create anonymous user
  ///3. Initialize Map service
  ///4. Initialize QR scanner service
  ///5. Initialize the app session
  ///Only after all futures have completed properly will the future return a valid
  ///App session object.
  Future<AppSession> initializeAppSession(BuildContext context) async {
    //Firebase auth service
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);

    //Maps service
    final MapsService maps = Provider.of<MapsService>(context, listen: false);

    //QR scanner service
    final QrScannerService qr =
        Provider.of<QrScannerService>(context, listen: false);

    //Connection service
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    ConnectivityResult connectionResult = await connect.getConnectionStatus();

    if (connectionResult == ConnectivityResult.none) {
      //display alert dialogue to ask user to connect to network
      return AppSession(isValid: false);
    }

    FirebaseUser user = await auth.createFirebaseUser();

    if (user == null) {
      return AppSession(isValid: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Connection service
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    //Check for connection to network, if not return the error page
    //If connected create an app session and then go to main page
    return StreamBuilder(
      stream: connect.onConnectivityChanged,
      builder: (context, connectionStatus) {
        if (connectionStatus.data == ConnectivityResult.none) {
          return ConnectionErrorPage();
        }
        return FutureBuilder(
          future: initializeAppSession(context),
          builder: (context, sessionData) {
            return null;
          },
        );
      },
    );
  }
}
