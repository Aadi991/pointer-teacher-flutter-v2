// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../Colours.dart';
import '../Screens/profileScreen.dart';
import '../Storage/SignInOption.dart';
import '../Utils.dart';

class RegisterWidget extends StatefulWidget {
  Function switchScreen;

  RegisterWidget({Key? key, required this.switchScreen}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool error = false;
  bool progress = false;
  String errorMessage = 'Error';
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  UserCredential? credential;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      progress
          ? Column(
              children: [
                Center(child: CircularProgressIndicator()),
                TextButton(
                    onPressed: () => setState(() => progress = false),
                    child: Text('Cancel')),
              ],
            )
          : Column(
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Quicksand')),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text('Sign in',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colours.accent,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600)),
                      onTap: () => widget.switchScreen(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  controller: emailController,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16)),
                  controller: password1Controller,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(fontSize: 16)),
                  controller: password2Controller,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onRegisterClick,
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(0),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side:
                                      BorderSide(color: Colors.grey.shade300))),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colours.accent),
                        ),
                      ),
                    )
                  ],
                ),
                getErrorMsg(),
              ],
            ),
    ]);
  }

  Widget getErrorMsg() {
    if (error) {
      return Text(errorMessage,
          style: TextStyle(fontSize: 14, color: Colors.red));
    } else {
      return Container();
    }
  }

  void onRegisterClick() async {
    if (emailController.text.isEmpty) {
      setState(() {
        error = true;
        errorMessage = 'Email is required';
      });
      return;
    }
    if (password1Controller.text.isEmpty) {
      setState(() {
        error = true;
        errorMessage = 'Password is required';
      });
      return;
    }
    if (password1Controller.text != password2Controller.text) {
      setState(() {
        error = true;
        errorMessage = 'Passwords do not match';
      });
      return;
    }
    if (password1Controller.text.length < 8) {
      setState(() {
        error = true;
        errorMessage = 'Password must be at least 8 characters';
      });
      return;
    }
    try {
      setState(() {
        progress = true;
      });
      GlobalVariables.signInOption = SignInOptions.EmailAndPassword;
      credential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: password1Controller.text);
      setState(() {
        progress = false;
      });
      if (credential != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GlobalVariables.profileFrom = ProfileFrom.RegisterWidget;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          error = true;
          errorMessage = 'Password is too weak';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          error = true;
          errorMessage = 'Email is already in use';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          error = true;
          errorMessage = 'Email is invalid';
        });
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
