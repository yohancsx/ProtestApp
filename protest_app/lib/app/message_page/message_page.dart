import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:protest_app/app/message_page/media_picker_page.dart';
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
              model.friend.friendName,
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
        color: Colors.red,
        padding: EdgeInsets.only(bottom: 70),
        child: Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: model.cloud.getMessageStream(model.friend),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                //update the messages
                model.updateMessages(snapshot.data);
                //then create the chat widget
                return DashChat(
                  inverted: false,
                  onSend: (message) async => model.sendMessage(message),
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: model.user,
                  inputDecoration: InputDecoration.collapsed(
                      hintText: "Send a helpful message"),
                  dateFormat: DateFormat('yyyy-MMM-dd'),
                  timeFormat: DateFormat('HH:mm'),
                  messages: model.messages,
                  showUserAvatar: false,
                  showAvatarForEveryMessage: false,
                  scrollToBottom: true,
                  onPressAvatar: (ChatUser user) {
                    print("OnPressAvatar: ${user.name}");
                  },
                  onLongPressAvatar: (ChatUser user) {
                    print("OnLongPressAvatar: ${user.name}");
                  },
                  inputMaxLines: 5,
                  messageContainerPadding:
                      EdgeInsets.only(left: 5.0, right: 5.0),
                  alwaysShowSend: true,
                  inputTextStyle: TextStyle(fontSize: 16.0),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(width: 0.0),
                    color: Colors.white,
                  ),
                  onLoadEarlier: () {
                    print("loading...");
                  },
                  shouldShowLoadEarlier: false,
                  showTraillingBeforeSend: true,
                  leading: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MediaPickerPage(
                                    session: model.session,
                                    onSubmitFiles: model.sendMediaMessages)));
                      },
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
