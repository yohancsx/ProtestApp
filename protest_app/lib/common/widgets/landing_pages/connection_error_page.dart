import 'package:flutter/material.dart';

class ConnectionErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.signal_wifi_off, size: 100.0, color: Colors.red),
          Text(
            "Please connect to a network to continue!",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.red, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
