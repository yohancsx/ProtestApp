import 'package:flutter/material.dart';
import 'package:protest_app/app/retreive_cache_page/retreive_cache_page_model.dart';

class RetreivePage extends StatelessWidget {
  RetreivePage({@required this.model});

  ///The page model
  final RetreivePageModel model;

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
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        constraints: BoxConstraints.loose(size),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //padding for the top
            SizedBox(height: size.height * 0.02),

            //title
            Container(
              alignment: Alignment.center,
              child: Text(
                "Retreive Cache",
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: size.height * 0.06),

            //retreive session ID
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5.0,
                    color: Colors.black,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.blue,
                  cursorHeight: 40.0,
                  cursorWidth: 3.0,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter Cache ID'),
                  onChanged: (text) {
                    print("Cache ID: $text");
                  },
                ),
              ),
            ),
            SizedBox(height: size.height * 0.06),

            //retreive session Password
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5.0,
                    color: Colors.black,
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.blue,
                  cursorHeight: 40.0,
                  cursorWidth: 3.0,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Cache Password'),
                  onChanged: (text) {
                    print("Cache Pass: $text");
                  },
                ),
              ),
            ),
            SizedBox(height: size.height * 0.06),

            //submit button
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.5,
                color: Colors.red,
                alignment: Alignment.center,
                child: FlatButton(
                  color: Colors.red,
                  onPressed: () => print("submitted"),
                  child: Text(
                    "SUBMIT",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white, fontSize: 50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
