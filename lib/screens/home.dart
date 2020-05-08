import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
class Home extends StatefulWidget {
  static String id ='/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            padding: EdgeInsets.all(8),
            child: Image.asset('back/logo.png'),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('Users',
        style:TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body:Column(
        children: <Widget>[
          UserStream(),
        ],
      )
    );
  }
}

class UserStream extends StatelessWidget {
  void getCurrentUser() async{
    final user=await FirebaseAuth.instance.currentUser();
    currentUser = user.email;
  }
  String currentUser;
  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context ,snapshot){
        List<UserCard>chatUsers = [];
         if(snapshot.data!=null){
           final users=snapshot.data.documents;
           for(var user in users) {
             if (currentUser != user){
               print(currentUser);
               String username;
               if(user.data['name']!=currentUser) {
                 username = user.data['name'];
                 final User = UserCard(
                   user: username,
                 );
                 chatUsers.add(User);
               }
             }
           }
           return Expanded(
             child: ListView(
                 padding: EdgeInsets.all(10),
                 children: chatUsers
             ),
           );
         }
         return Expanded(child:Text('Loading...'));
      },
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({this.user});
  String user;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10, 10, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue, 
          borderRadius: BorderRadius.circular(20)
        ),
        
        child: ListTile(
          onTap: (){
            Navigator.pushNamed(context, ChatScreen.id,arguments: {
              'user':user,
              'currentUser':currUser
              }
            );
          },
          title: Text(user,
          style:TextStyle(
             fontSize: 20,
             color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

