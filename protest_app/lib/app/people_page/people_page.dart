import 'package:flutter/material.dart';
import 'package:protest_app/app/message_page/message_page_wrapper.dart';
import 'package:protest_app/app/people_page/people_page_model.dart';
import 'package:protest_app/common/widgets/landing_pages/connection_error_page.dart';

///The page for showing added people
class PeoplePage extends StatelessWidget {
  PeoplePage({this.model});

  ///The page model
  final PeoplePageModel model;

  @override
  Widget build(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
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
              padding: EdgeInsets.only(right: 25.0),
              child: IconButton(
                onPressed: () => model.refreshPage(),
                icon: Icon(
                  Icons.refresh,
                  size: 55.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        constraints: BoxConstraints.loose(size),
        child: FutureBuilder<bool>(
          future: model.cloud.refreshFriendsList(model
              .session), //look at the friends in the database, add any to the friends list that arent there
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return _buildFriendList(context);
              } else {
                return ConnectionErrorPage();
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFriendList(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    //list of friends
    List<Widget> friendsListCards = [];

    //for each friend in the list
    if (model.session.user.userFriendList.length != 0) {
      model.session.user.userFriendList.forEach(
        (friend) {
          friendsListCards.add(
            SizedBox(height: size.height * 0.03),
          );
          friendsListCards.add(
            Card(
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.red, size: 50.0),
                title: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    friend.friendName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 30.0),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.message, color: Colors.blue, size: 40.0),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePageWrapper(
                        friend: friend,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      friendsListCards.add(
        SizedBox(height: size.height * 0.3),
      );
      friendsListCards.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            "Add Users by scanning their QR codes!",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.red, fontSize: 20),
          ),
        ),
      );
    }

    return Stack(
      children: [
        //Friends
        Positioned(
          top: 60.0,
          child: SizedBox(
            height: size.height * 0.8,
            width: size.width,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: friendsListCards,
            ),
          ),
        ),

        //Title
        Container(
          padding: EdgeInsets.only(top: 20.0),
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.white,
            height: 60.0,
            alignment: Alignment.topCenter,
            child: Text(
              "Added Users",
              style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
