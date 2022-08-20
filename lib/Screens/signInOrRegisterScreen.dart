// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pointer_teachers_v2/Screens/phoneSignInScreen.dart';
import 'package:pointer_teachers_v2/Screens/profileScreen.dart';
import 'package:pointer_teachers_v2/Widgets/registerWidget.dart';
import 'package:pointer_teachers_v2/Widgets/signInWidget.dart';

import '../Colours.dart';
import '../Storage/SignInOption.dart';
import '../Utils.dart';



class SignInOrRegister extends StatefulWidget {
  const SignInOrRegister({Key? key}) : super(key: key);

  @override
  State<SignInOrRegister> createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> {
  int index = 0;
  bool progress = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(left: 30, top: 200, right: 30),
        child: Column(
          children: [
            IndexedStack(
              index: index,
              children: [
                SignInWidget(switchScreen: switchScreen),
                RegisterWidget(switchScreen: switchScreen),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: onGoogleSignInButtonPress,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 2,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('images/googleIcon.png'),
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        "Sign in with Google",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onPhoneSignInButtonPress,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    child: Text(
                      "Sign in with phone",
                      style: TextStyle(color: Colours.accent),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  switchScreen() {
    setState(() {
      index = index == 0 ? 1 : 0;
    });
  }

  onGoogleSignInButtonPress() async {
    GlobalVariables.signInOption = SignInOptions.Google;
    print("onGoogleSignInButtonPress");
    setState(() {
      progress = true;

    });
    // try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        setState(() {
          progress = false;
        });
        String displayName = user.displayName!;
        print("signed in $displayName");
        GlobalVariables.profileFrom = ProfileFrom.SignInOrRegister;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Profile();
        }));
      } else {
        print("Error signing in");
      }
      print("onGoogleSignInButtonPress: success");
      GlobalVariables.profileFrom = ProfileFrom.SignInOrRegister;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    // } catch (e) {
    //   print(e);
    // }
  }

  onPhoneSignInButtonPress() {
    GlobalVariables.signInOption = SignInOptions.Phone;
    //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneSignIn()));

  }
}
