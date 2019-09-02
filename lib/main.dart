import 'package:flutter/material.dart';
import 'package:bolt_chat/screens/welcome_screen.dart';
import 'package:bolt_chat/screens/login_screen.dart';
import 'package:bolt_chat/screens/registration_screen.dart';
import 'package:bolt_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

//our named routes are set up to use static variables inside their classes
//this ensures there won't be any typo issues when doing our routes
class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
