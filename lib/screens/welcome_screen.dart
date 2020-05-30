import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/components/Rounded_Button.dart';
import 'package:provider/provider.dart';
import 'package:flashchat/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
class WelcomeScreen extends StatefulWidget {
  static String id='/Welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=AnimationController(
      duration: Duration(
        seconds:3
      ),

      vsync: this,
    );
    animation=ColorTween(begin:Colors.grey, end:Colors.blue[900]).animate(controller);
    controller.forward();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print(user);
    if(user!=null)
      return Home();
    else
    return Scaffold(
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
                  tag:'logo',
                  child: Container(
                    child: Image.asset('back/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 63.0,
                    fontFamily: 'Caveat',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
           RoundedButton(colour:Colors.lightBlue,title:'Log in',onPressed: () {
             Navigator.pushNamed(context, LoginScreen.id);
             },
           ),
            RoundedButton(colour:Colors.lightBlueAccent ,title:'Register',onPressed:(){
            Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}