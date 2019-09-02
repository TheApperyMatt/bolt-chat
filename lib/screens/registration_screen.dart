import 'package:flutter/material.dart';
import 'package:bolt_chat/constants.dart';
import 'package:bolt_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  //static constant so we don't have to create a new object of this class to access it
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

//create a final property, _auth, that is an instance of the FirebaseAuth class (static)
//email, password and showSpinner properties
class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                //show email keyboard
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                //when the text field is changed, we assign the value in the text field to our email property
                onChanged: (value) {
                  email = value;
                },
                //set the decoration property to a constant from our constants file
                //use the copyWith method to set the hintText property in the constant
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                //hide the password text
                obscureText: true,
                textAlign: TextAlign.center,
                //when the text field is changed, we assign the value in the text field to our password property
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColour: Colors.blue,
                buttonTitle: 'Register',
                //set the call back to async so we can await on the newUser final variable to be set
                onPressed: () async {
                  //show the spinner while we wait for the newUser to be set
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);

                    //if newUser is not null, navigate to the chat screen
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    //newUser is now set so we hide the spinner
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
