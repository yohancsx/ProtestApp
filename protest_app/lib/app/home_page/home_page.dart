import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //size of screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: Text("ProtestApp")),
        drawer: _buildDrawer(context),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          constraints: BoxConstraints.loose(size),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //padding for the top
              SizedBox(height: size.height * 0.3),

              //TODO: create QR code widget
              //center QR code widget
              Container(alignment: Alignment.center, color: Colors.black),

              //padding between QR code and photo
              SizedBox(height: size.height * 0.05),

              //take video button
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.video_call),
                    onPressed: () {
                      print("take photo");
                    },
                    color: Colors.red),
              ),

              //padding between take video and
              SizedBox(height: size.height * 0.01),

              //message button
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      print("message");
                    },
                    color: Colors.blue),
              ),
            ],
          ),
        ));
  }

  //builds the drawer widget
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              //closes drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              //closes drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
