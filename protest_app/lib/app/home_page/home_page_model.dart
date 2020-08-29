import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/services/qr_scanner_service.dart';

class HomePageModel extends ChangeNotifier {
  HomePageModel(
      {@required this.context, @required this.qr, @required this.session});

  ///The current build context
  BuildContext context;

  ///The app session
  AppSession session;

  ///The qr scanner service
  QrScannerService qr;

  void processQrScan() async {
    String scanResult = await qr.scanQRcode();
    print(scanResult);
  }
}
