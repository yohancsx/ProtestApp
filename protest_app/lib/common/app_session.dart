import 'package:flutter/material.dart';

///A data class to hold all the data for a single application session
class AppSession {
  AppSession({@required this.isValid});

  ///Is this a valid app session, that is, are all required fields non-null?
  bool isValid;
}
