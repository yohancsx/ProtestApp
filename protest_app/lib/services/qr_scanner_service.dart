import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

///QR code scanner class, responsible for scanning and generating QR codes
class QrScannerService {
  ///Scan options for Qrcode scanning
  ScanOptions options =
      ScanOptions(restrictFormat: [BarcodeFormat.qr], autoEnableFlash: true);

  ///Returns a QR code widget with embedded data
  Widget getQRCode(String data, double size) {
    return QrImage(
      data: data,
      version: QrVersions.auto,
      size: size,
    );
  }

  ///Scans a QR code, and returns the data as a string
  ///Will also request permissions to scan if not enabled
  ///Upon a failure will return a null string
  Future<String> scanQRcode() async {
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Cancelled ||
        result.type == ResultType.Error) {
      return null;
    }
    return result.rawContent;
  }
}
