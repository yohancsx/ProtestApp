import 'package:connectivity/connectivity.dart';

/// A service to check internet connectivity in the application
class ConnectionService {
  //Connectivity object
  final connectivity = Connectivity();

  ///Stream that fires if connectivity state is changed
  ///Returns the connectivity result
  Stream<ConnectivityResult> get onConnectivityChanged {
    return connectivity.onConnectivityChanged;
  }

  ///Get the connection status
  Future<ConnectivityResult> getConnectionStatus() async {
    return await connectivity.checkConnectivity();
  }
}
