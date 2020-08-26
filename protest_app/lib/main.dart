import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/home_page/home_page_wrapper.dart';
import 'package:protest_app/common/anon_user.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/strings.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';
import 'package:protest_app/services/connection_service.dart';
import 'package:protest_app/services/firebase_auth_service.dart';
import 'package:protest_app/services/maps_service.dart';
import 'package:protest_app/services/qr_scanner_service.dart';
import 'package:protest_app/services/camera_service.dart';
import 'package:protest_app/services/user_data_handler_service.dart';
import 'package:protest_app/common/user_prefs.dart';
import 'package:protest_app/services/id_service.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
        //UUid service
        Provider<IDService>(
          create: (_) => IDService(),
        ),
        //Camera service
        Provider<CameraService>(
          create: (_) => CameraService(),
        ),
        Provider<UserDataHandlerService>(
          create: (_) => UserDataHandlerService(),
        )
      ],
      child: MaterialApp(
        title: 'ProtestApp',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            primaryColorDark: const Color(0XFF990000),
            accentColor: Colors.blue,
            backgroundColor: Colors.white,
            errorColor: Colors.yellow,
          ),
        ),
        //Responsive builder
        builder: (context, widget) => ResponsiveWrapper.builder(
          widget,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
          background: Container(color: Colors.white),
        ),
        home: ProtestAppWrapper(),
      ),
    );
  }
}

///App wrapper
///basically wraps the entire app in some providers and streambuilders
///for convenience
///responsible for initializing the app session and other objects
class ProtestAppWrapper extends StatefulWidget {
  @override
  _ProtestAppWrapperState createState() => _ProtestAppWrapperState();
}

class _ProtestAppWrapperState extends State<ProtestAppWrapper> {
  ///The future to initialize tha application
  Future<AppSession> initApp;

  ///Create the future to initialize the application
  @override
  void initState() {
    super.initState();
    initApp = initializeAppSession(context);
  }

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

    //Connection service
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    //Data handler service
    final UserDataHandlerService dataHandler =
        Provider.of<UserDataHandlerService>(context, listen: false);

    //App ID service
    final IDService idService = Provider.of<IDService>(context, listen: false);

    print("checking connection");
    ConnectivityResult connectionResult = await connect.getConnectionStatus();

    //check connection, if no connection, show error and fail
    if (connectionResult == ConnectivityResult.none) {
      return AppSession(isValid: false);
    }

    print("creating anonymous user");
    FirebaseUser firebaseUser = await auth.createFirebaseUser();
    AnonymousUser user = AnonymousUser(firebaseUser: firebaseUser);

    //get user, if no user show error and fail
    if (firebaseUser == null) {
      return AppSession(isValid: false);
    }

    print("checking location");
    bool locationServiceEnabled = await maps.requestLocationEnabled();
    bool locationPermissionGranted = await maps.requestLocationPermission();

    //get location permissions, if not granted show error and fail
    if (!locationPermissionGranted || !locationServiceEnabled) {
      return AppSession(isValid: false);
    }

    print("getting user preferences");
    UserPrefs userPrefs = await dataHandler.readUserPrefs();

    //if we cannot get the user preferences
    if (!userPrefs.isValid) {
      return AppSession(isValid: false);
    }

    print("finishing up");
    //get the device ID
    String deviceID = await idService.getDeviceId();

    //create app session with all provided services
    return AppSession(
      isValid: true,
      deviceID: deviceID,
      userPrefs: userPrefs,
      user: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    //Connection service
    final ConnectionService connect =
        Provider.of<ConnectionService>(context, listen: false);

    //Check for connection to network, if not return the error page
    //If connected create an app session and then go to main page

    return FutureBuilder<AppSession>(
      future: initApp,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              Strings.initializationFailureString,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        } else {
          //Only provider of the app session, all other widgets will be able to access this session
          return Provider<AppSession>(
            create: (context) => snapshot.data,
            child: Consumer<AppSession>(
              builder: (context, session, child) {
                if (session.isValid) {
                  return HomePageWrapper(session: session);
                }
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    Strings.sessionFailureString,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
