import 'package:flutter/material.dart';

///A styled alert button with two buttons to press
class TwoButtonAlert extends StatelessWidget {
  TwoButtonAlert(
      {this.title = "Alert",
      this.bodyText = "body text",
      this.buttonText1 = "Cancel",
      this.buttonText2 = "OK",
      this.onSubmit1,
      this.onSubmit2});

  final String title;

  final String bodyText;

  final String buttonText1;

  final String buttonText2;

  final VoidCallback onSubmit1;

  final VoidCallback onSubmit2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(bodyText),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(buttonText1),
          onPressed: () {
            onSubmit1();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(buttonText2),
          onPressed: () {
            onSubmit2();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
