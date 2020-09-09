import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/message_page/message_page_model.dart';

class MessagePage extends StatelessWidget {
  MessagePage({@required this.model});

  ///The page model
  final MessagePageModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "largefarmer-42",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 30.0, color: Colors.white),
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 55.0,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20.0, top: 5.0),
              child: IconButton(
                onPressed: () => print("more settings"),
                icon: Icon(
                  Icons.more_horiz,
                  size: 45.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          child: DashChat(messages: null, user: null, onSend: null)),
    );
  }
}
