import 'package:flutter/material.dart';
import 'package:protest_app/services/qr_scanner_service.dart';

class HomePageModel extends ChangeNotifier {
  HomePageModel({@required this.context, @required this.qr});

  ///The current build context
  BuildContext context;

  ///The qr scanner service
  QrScannerService qr;

  void processQrScan() async {
    String scanResult = await qr.scanQRcode();
    print(scanResult);
  }
}
