import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bolt_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//create our _firestore property outside the class so it can be used in our refactored code
//initialise a new FirebaseUser, loggedInUser
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  //static constant so we don't have to create a new object of this class to access it
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

//create a new object of the TextEditingController class, this allows us to control the TextField
//static instance of FirebaseAuth
//messageText property of type String
class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  //init state where we get the current user
  //runs as soon as the class gets created
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  //asynchronous method to get the currently logged in user
  //currentUser method of the _auth instance returns the currently logged in user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      //if returned user is not null, assign it to our loggedInUser property
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //this is how you log out
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //using our controller to clear the text field
                      messageTextController.clear();
                      //adding data to our collection
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//now this is our stream
//imagine you order food at a restaurant and they send out bits of food a bit at a time, that is like a stream
//we subscribe to this stream and listen for any new data, the new data then becomes available to us
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //we know that our stream is going to be returning instances of Firebase QuerySnapshots
    return StreamBuilder<QuerySnapshot>(
      //this is the actual stream
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      //we set the builder property to a call back that takes the current build context, and an object of the AsyncSnapshot class as input
      ///important to note that our instance of AsyncSnapshot CONTAINS our QuerySnapshot, so we can dig into it to retrieve the data we need
      builder: (context, snapshot) {
        //check if the object of AsyncSnapshot has data or not
        if (!snapshot.hasData) {
          //if not, we show a progress indicator until it does have data
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        //now our object of AsyncSnapshot does have data so we can start digging into it
        //snapshot contains data, data contains documents, documents is like an array of arrays containing our messages
        //we reverse the order they are returned in
        final messages = snapshot.data.documents.reversed;

        //initialise an empty list which will take our custom MessageBubble widgets
        List<MessageBubble> messageBubbles = [];

        //loop through our array of arrays to get to our juicy message data
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          //set the current user
          final currentUser = loggedInUser.email;

          //create a final variable that we assign an object of our custom MessageBubble widget
          //set the text property to the message text
          //set the sender property to the sender of the message
          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            //here we use a bit of syntax voodoo
            //if the current user (loggedInUser.email) is the same as the message sender, isMe will be true, if not, it will be false
            isMe: currentUser == messageSender,
          );

          //add our new MessageBubble object to our List of MessageBubbles
          messageBubbles.add(messageBubble);
        }

        ///the call back assigned to the builder property of the StreamBuilder expects a Column widget to be returned
        ///we can return an Expanded widget with a child of a ListView widget because a ListView widget is just a Column on crack
        ///we set the reverse property of the ListView to true, this means it will present data from the bottom up, instead of the other way round
        ///we set the children property to our List of MessageBubbles, it expects a List so we are good there
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

///this is our refactored widget that makes our message bubbles look fancy
///constructor method sets text, sender and isMe properties
class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      //column widget which will have the sender text and then the actual bubble beneath it
      child: Column(
        //if isMe is false, align start, if isMe is true, align end
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          //this is our sender text
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          //this is our styled material widget that will contain the message text
          Material(
            //set border radius based on isMe
            borderRadius: isMe ? kPersonalBubbleRadius : kNonPersonalBubbleRadius,
            elevation: 5.0,
            //set colour based on isMe
            color: isMe ? Colors.lightBlueAccent : Colors.lightGreen,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
