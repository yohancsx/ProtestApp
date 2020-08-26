import 'package:flutter/material.dart';

///A button alter with one body text
class SingleButtonAlert extends StatelessWidget {
  SingleButtonAlert(
      {this.title = "Alert",
      this.bodyText = "body text",
      this.buttonText = "OK",
      this.onSubmit});

  final String title;

  final String bodyText;

  final String buttonText;

  final VoidCallback onSubmit;

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
          child: Text(buttonText),
          onPressed: () {
            onSubmit();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
