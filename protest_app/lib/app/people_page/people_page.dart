import 'package:flutter/material.dart';
import 'package:protest_app/app/people_page/people_page_model.dart';
import 'package:protest_app/common/app_session.dart';

///The page for showing added people
class PeoplePage extends StatelessWidget {
  PeoplePage({this.model, this.session});

  ///The application session
  final AppSession session;

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
                onPressed: () => print("refresh"),
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
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //padding from top
            SizedBox(height: size.height * 0.04),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Added Users",
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            //friend cards
            Card(
              child: ListTile(
                //Add changable widget to allow for changing the user status
                leading: Icon(Icons.plus_one, color: Colors.red, size: 50.0),
                title: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "largefarmer-42",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 30.0),
                  ),
                ),
                trailing: Icon(Icons.message, color: Colors.blue, size: 40.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
