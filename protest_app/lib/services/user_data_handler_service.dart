import 'package:protest_app/common/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

///A service to read and write user data from the device
class UserDataHandlerService {
  ///Instance of the shared preferences to use
  SharedPreferences prefs;

  ///Initializes an instance of the shared preferences
  ///Returns true upon success
  Future<bool> initializePreferences() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  ///Writes all the user preferences to the disk
  Future<bool> writeUserPrefs(UserPrefs userPrefs) async {
    if (prefs == null) {
      bool prefsInitialized = await initializePreferences();
      if (!prefsInitialized) {
        return false;
      }
    }

    //Add more preferences here
    await prefs.setBool("isNew", userPrefs.isNew);
    await prefs.setBool("shareLocation", userPrefs.shareLocation);
    await prefs.setBool("shareMedia", userPrefs.shareMedia);
    await prefs.setBool(
        "enableLocationDropping", userPrefs.enableLocationDropping);
    await prefs.setBool("enableChainSharing", userPrefs.enableChainSharing);

    return true;
  }

  ///Read all the user preferences from disk
  Future<UserPrefs> readUserPrefs() async {
    UserPrefs userPrefs = UserPrefs(isValid: false);

    if (prefs == null) {
      bool prefsInitialized = await initializePreferences();
      if (!prefsInitialized) {
        return userPrefs;
      }
    }

    if (!prefs.containsKey("isNew")) {
      userPrefs.isNew = true;
      userPrefs.isValid = true;
      return userPrefs;
    }

    userPrefs.isNew = prefs.getBool("isNew");
    userPrefs.shareLocation = prefs.getBool("shareLocation");
    userPrefs.shareMedia = prefs.getBool("shareMedia");
    userPrefs.enableLocationDropping = prefs.getBool("enableLocationDropping");
    userPrefs.enableChainSharing = prefs.getBool("enableChainSharing");
    userPrefs.isValid = true;

    return userPrefs;
  }
}
