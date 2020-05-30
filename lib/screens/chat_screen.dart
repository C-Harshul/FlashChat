import 'package:flutter/material.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
Map chatUserList ={};
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
String formattedTime;
String currUser;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  DateTime now;
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        currUser = loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }
  void refresh(){

  }
  @override
  Widget build(BuildContext context) {
    chatUserList = ModalRoute.of(context).settings.arguments;
    String chatUser = chatUserList['user'];
    return Scaffold(
      appBar: AppBar(
        leading: null,

        title: Text('⚡️$chatUser',
        style:TextStyle(
            fontFamily: 'Caveat',
                fontSize: 32,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MessagesStream(chatUser: chatUser,currUser: currUser,),
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
                  onPressed: () async{
                    if(messageTextController.text!=''){
                     final user = await FirebaseAuth.instance.currentUser();
                     setState(() {
                        now = DateTime.now();
                       int nowsec=now.second;
                       String nowSec=nowsec.toString();
                       print(now.second);
                       formattedTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);

                      }
                     );
                     print(formattedTime);
                    messageTextController.clear();

                    _firestore.collection('$currUser-$chatUser').add({
                      'text': messageText,
                      'sender': currUser,
                      'time': formattedTime,
                     }
                    );
                  _firestore.collection('$chatUser-$currUser').add({
                    'text': messageText,
                    'sender': currUser,
                    'time': formattedTime,
                       }
                     );
                    }
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
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.chatUser,this.currUser});
  String chatUser;
  String currUser;
  @override
  Widget build(BuildContext context) {
    chatUserList = ModalRoute.of(context).settings.arguments;
    String chatUser = chatUserList['user'];
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('$currUser-$chatUser').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        else{
          final messages = snapshot.data.documents;
          List<MessageBubble> messageBubbles = [] ;


          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final messageTime=message.data['time'] ;
            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              time:messageTime,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
            //print(message['time']);
          }
          messageBubbles.sort((b, a) => a.time.compareTo(b.time));
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe,this.time});

  final String sender;
  final String text;
  final bool isMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe?'':sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.blue[900],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color:  Colors.white ,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('$time',
          style:TextStyle(
            color:Colors.grey,
           ),
          ),
        ],
      ),
    );
  }
}