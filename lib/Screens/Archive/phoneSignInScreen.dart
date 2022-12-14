// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pointer_teachers_v2/Screens/homeScreen.dart';
import 'package:pointer_teachers_v2/Screens/profileScreen.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController smsController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  TextEditingController otpEditingController = TextEditingController();
  String? _verificationId;
  int? forceResendingToken;
  bool showOtpScreen = false;
  late StreamController<ErrorAnimationType> errorController;
  bool loading = false;
  bool enterOTP = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "Sign in with phone",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(6.0),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      phoneNumber = number.phoneNumber;
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    spaceBetweenSelectorAndTextField: 0,
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: PhoneNumber(isoCode: 'IN'),
                    //enter country code for the default value
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => verifyPhoneNumber(),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.orange,
                    ),
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                enterOTP
                    ? Column(
                        children: [
                          Text(
                            "Enter your OTP",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            obscureText: false,
                            hintCharacter: '0',
                            hintStyle: TextStyle(
                              color: const Color(0x36000000),
                            ),
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              borderWidth: 0,
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              activeColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: otpEditingController,
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              return true;
                            },
                          ),
                        ],
                      )
                    : Container(),
                loading ? CircularProgressIndicator() : Container()
              ],
            ),
          )),
    );
  }

  void verifyPhoneNumber()async{
    if(_formKey.currentState!.validate())
    {
      setState(() {
        loading=true;
      });
      PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
        User? user;
        bool error=false;
        try{
          user=(await firebaseAuth.signInWithCredential(phoneAuthCredential)).user!;
        } catch (e){
          print("Failed to sign in: " + e.toString());
          error=true;
        }
        if(!error&&user!=null){
          String id=user.uid;
          //here you can store user data in backend
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Profile()));
        }
      };

      PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
        Fluttertoast.showToast(msg: authException.message!);
      };
      PhoneCodeSent codeSent = (String? verificationId, [int? forceResendingToken]) async {
        Fluttertoast.showToast(msg: 'Please check your phone for the verification code.');
        this.forceResendingToken=forceResendingToken;
        _verificationId = verificationId;
      };
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
        _verificationId = verificationId;
      };
      try {
        await firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber!,
            timeout: const Duration(seconds: 5),
            forceResendingToken: forceResendingToken!=null?forceResendingToken:null,
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
        showOtpScreen=true;
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to Verify Phone Number: $e");
        showOtpScreen=false;
      }
      setState(() {
        loading=false;
      });
    }
  }
}
