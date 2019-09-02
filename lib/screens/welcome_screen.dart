import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bolt_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  //static constant so we don't have to create a new object of this class to access it
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//we add the mixin, SingleTickerProviderStateMixin to our class so that this class can implement a ticker
//initialise our AnimationController and Animation properties
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    //set our AnimationController
    //duration property can be set to any amount of time (days, hours, minutes etc)
    //we set the duration to 1 second
    //the vsync property is the ticker provider for the current context
    //we set the vsync property to this class because we have added our mixin, which allows us to do so
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    //tween animation
    //colours will animate between the begin colour and end colour over the duration of the AnimationController
    //the colour will change with each tick of the controller
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

    //start running the animation forwards towards the end
    controller.forward();

//    controller.addListener(() {
//      setState(() {
//        print(animation.value);
//      });
//    });
  }

  //this method destroys the animation
  //very important to do this or else the animation will carry on infinitely
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              buttonColour: Colors.lightBlueAccent,
              buttonTitle: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              buttonColour: Colors.blue,
              buttonTitle: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
