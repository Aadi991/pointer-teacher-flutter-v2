// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Colours.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            margin: EdgeInsets.only(left: 30, top: 250, right: 30),
            child: _progress
                ? Center(
                  child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sending email...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _progress = false;
                              });
                            },
                            child: Text('Cancel'))
                      ],
                    ),
                )
                : Column(children: [
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Provide your email and we will send you a link to reset your password",
                      style: TextStyle(fontFamily: 'Quicksand'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(fontFamily: 'Quicksand'),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  _progress = true;
                                });
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: 'aadinair544@gmail.com');
                                setState(() {
                                  _progress = false;
                                });

                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-email') {
                                  print('User not found');
                                } else if (e.code == 'user-not-found') {
                                  print('User not found');
                                } else {
                                  print(e.code);
                                }
                              } catch (e) {
                                print(e);
                              }
                              await Future.delayed(Duration(seconds: 5), () {
                                Navigator.pop(context);
                              });
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              elevation: MaterialStateProperty.all<double>(0),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(
                                          color: Colors.grey.shade300))),
                            ),
                            child: Text(
                              "Reset password",
                              style: TextStyle(
                                  color: Colours.accent,
                                  fontFamily: 'Quicksand',
                                  fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              elevation: MaterialStateProperty.all<double>(0),
                            ),
                            child: Text(
                              "Go back",
                              style: TextStyle(
                                  color: Colours.accent,
                                  fontFamily: 'Quicksand',
                                  fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  ])));
  }
}
