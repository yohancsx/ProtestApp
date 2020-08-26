import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';

///A service which is used for providing IDs
///Unique UUids as well as the device ID are provided
class IDService {
  ///The device info plugin
  DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();

  ///The Uuid generator
  Uuid uuid = Uuid();

  ///Returns a Unique Device ID for identifying the current device
  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }

    return null;
  }

  ///Returns a unique ID, which can be used for signing objects
  String getUniqueId() {
    return uuid.v1();
  }
}
