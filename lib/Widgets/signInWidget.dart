// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/SignInOption.dart';
import 'package:pointer_teachers_v2/Utils.dart';

import '../Colours.dart';
import '../Screens/Archive/forgotPasswordScreen.dart';
import '../Screens/profileScreen.dart';

class SignInWidget extends StatefulWidget {
  Function switchScreen;

  SignInWidget({Key? key, required this.switchScreen}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool error = false;
  bool progress = false;
  String errorMessage = 'Error';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return progress ? Column(
      children: [
        Center(child: CircularProgressIndicator()),
        TextButton(
            onPressed: () => setState(() => progress = false),
            child: Text('Cancel')),
      ],
    ) :Column(
      children: [
        Text(
          "Sign in",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text("Don't have an account?",
                style: TextStyle(
                    fontSize: 12, color: Colors.grey, fontFamily: 'Quicksand')),
            SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () => widget.switchScreen(),
                child: Text('Register',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colours.accent,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
              labelText: "Email", labelStyle: TextStyle(fontSize: 16)),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
              labelText: "Password", labelStyle: TextStyle(fontSize: 16)),
        ),
        SizedBox(
          height: 20,
        ),
        Row(children: [
          Spacer(
            flex: 1,
          ),
          InkWell(
            child: Text(
              'Forgot password?',
              style: TextStyle(
                  color: Colours.accent, fontSize: 14, fontFamily: 'Quicksand'),
            ),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, '/forgot-password');
              });
            },
          ),
        ]),
        SizedBox(
          height: 10,
        ),
        getErrorMsg(),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => {
                  setState(() => progress = true),
                  signIn()
                },
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.black),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey))),
                ),
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colours.accent),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget getErrorMsg() {
    if (error) {
      return Text(errorMessage,
          style: TextStyle(fontSize: 14, color: Colors.red));
    } else {
      return Container();
    }
  }

  signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        error = true;
        errorMessage = 'Please fill all the fields';
      });
    } else {
      try {
        print("Signing in");
        GlobalVariables.signInOption = SignInOptions.EmailAndPassword;
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        setState(() {
          progress = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GlobalVariables.profileFrom = ProfileFrom.SignInWidget;
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => Profile()
          )
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('User not found');
          setState(() {
            error = true;
            errorMessage = 'The user was not found';
            progress = false;
          });
        } else if (e.code == 'wrong-password') {
          print('Wrong password');
          setState(() {
            error = true;
            errorMessage = 'The password is wrong';
            progress = false;
          });
        } else if (e.code == 'invalid-email') {
          print('Invalid email');
          setState(() {
            error = true;
            errorMessage = 'The email is invalid';
            progress = false;
          });
        } else if (e.code == 'user-disabled') {
          print('User disabled');
          setState(() {
            error = true;
            errorMessage = 'The user is disabled';
            progress = false;
          });
        }else{
          print('Unknown error');
          setState(() {
            error = true;
            var message = e.code;
            errorMessage = 'Unknown error: $message';
            progress = false;
          });
        }
      }
    }
  }

  onForgotPasswordPress() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const ForgotPassword()));
    });
  }
}
