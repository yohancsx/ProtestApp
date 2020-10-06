import 'package:flutter/material.dart';

///A checkmark selector that maintains it's state if it is selected or not
class CheckmarkSelector extends StatefulWidget {
  CheckmarkSelector({@required this.onChanged});

  final Function(bool) onChanged;

  @override
  _CheckmarkSelectorState createState() => _CheckmarkSelectorState();
}

class _CheckmarkSelectorState extends State<CheckmarkSelector> {
  bool checkValue;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checkValue,
      onChanged: (value) {
        widget.onChanged(value);
        setState(
          () {
            checkValue = value;
          },
        );
      },
    );
  }
}
