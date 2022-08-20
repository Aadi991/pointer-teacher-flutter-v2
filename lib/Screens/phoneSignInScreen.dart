// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {

  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController smsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              Text(
                "Sign in with phone",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              PhoneInput(initialCountryCode:"IN",onSubmit: (phoneNo)async{
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneNo,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {},
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },),
            ],
          )
          ),
    );
  }
}
