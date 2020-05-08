import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flashchat/screens/home.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if(user==null)
    return WelcomeScreen();
     else
    return Home();
  }
}
