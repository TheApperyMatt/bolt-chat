import 'package:flutter/material.dart';

//refactored widget because we use it a few times throughout the app
//constructor method sets the properties when a new object of this class is created
class RoundedButton extends StatelessWidget {
  RoundedButton({this.buttonColour, this.buttonTitle, @required this.onPressed});

  final Color buttonColour;
  final String buttonTitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: buttonColour,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
