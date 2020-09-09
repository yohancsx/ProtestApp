import 'package:flutter/material.dart';

///A class for the bottom navigation bar, used to offset the main page code
class BottomNavBar extends StatelessWidget {
  BottomNavBar(
      {@required this.button1, @required this.button2, @required this.button3});

  ///callback for the first button
  final VoidCallback button1;

  ///callback for the second button
  final VoidCallback button2;

  ///callback for the third button
  final VoidCallback button3;

  @override
  Widget build(BuildContext context) {
    //All the navigation button callbacks
    List<VoidCallback> navButtonCallbacks = [button1, button2, button3];

    return BottomNavigationBar(
      fixedColor: Colors.red,
      currentIndex: 1, // this will be set when a new tab is tapped
      onTap: (index) => navButtonCallbacks[index](),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map,
            size: 50.0,
            color: Colors.black,
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete_forever,
            size: 50.0,
            color: Colors.red,
          ),
          label: 'Delete',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people,
            size: 50.0,
            color: Colors.blue,
          ),
          label: 'People',
        ),
      ],
    );
  }
}
