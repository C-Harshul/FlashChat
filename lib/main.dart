import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flashchat/Auth.dart';
import 'package:flashchat/Wrapper.dart';
void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value:AuthService.user,
      child: MaterialApp(
        home: Wrapper(),
        //initialRoute: Home.id,
        routes:{
          LoginScreen.id:(context)=>LoginScreen(),
          RegistrationScreen.id:(context)=>RegistrationScreen(),
          WelcomeScreen.id:(context)=>WelcomeScreen(),
          ChatScreen.id:(context)=>ChatScreen(),
          Home.id:(context)=>Home(),
        }
      ),
    );
  }
}
