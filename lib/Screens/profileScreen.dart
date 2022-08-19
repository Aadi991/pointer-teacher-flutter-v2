// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Colours.dart';
import 'package:pointer_teachers_v2/Screens/schoolRegisterScreen.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Teacher.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';
import 'package:pointer_teachers_v2/Widgets/getTeacherDataWidget.dart';
import 'package:pointer_teachers_v2/Widgets/viewTeacherDataWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Storage/SignInOption.dart';
import '../Utils.dart';
import '../main.dart';
import 'homeScreen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _editing = true;
  bool progress = false;
  bool _seeData = false;
  String prefKey = SharedPrefsKeys.phoneNoKey;
  int userDataStackIndex = 1;
  int collapseStackIndex = 0;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController screenNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolIDController = TextEditingController();
  TextEditingController teacherPinController = TextEditingController();
  CloudFirestoreControl control = CloudFirestoreControl();
  bool _progress = false;
  String phoneNo = "";

  @override
  void initState() {
    super.initState();
    userDataStackIndex = _editing ? 1 : 0;
    collapseStackIndex = _seeData ? 0 : 1;
    String schoolID = "";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SharedPrefsKeys.schoolIDKey)) {
        schoolID = prefs.getString(SharedPrefsKeys.schoolIDKey) ?? "";
      }
      else {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter your school name"),
                content: TextField(
                  controller: schoolIDController,
                  decoration: InputDecoration(
                    labelText: "School Name",
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Submit"),
                    onPressed: () {
                      schoolID = schoolIDController.text;
                      if (schoolID.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Please enter your school name"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        prefs.setString(SharedPrefsKeys.schoolIDKey, schoolID);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            });
      }
      if (prefs.containsKey(prefKey)) {
        String phoneNo = await prefs.getString(prefKey)!;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Home(phoneNo: phoneNo, schoolID: schoolID);
        }));
      }
      else{
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter your phone number"),
                content: TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Submit"),
                    onPressed: () {
                      phoneNo = phoneNumberController.text;
                      if (phoneNo.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content:
                                Text("Please enter your phone number"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        prefs.setString(
                            SharedPrefsKeys.phoneNoKey, phoneNo);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            });
      }
      if(GlobalVariables.profileFrom == ProfileFrom.Home){
        Teacher? current = await control.getTeacher(schoolID, phoneNo);
        fullNameController.text = current!.fullName!;
        screenNameController.text = current.screenName!;
        phoneNumberController.text = current.phoneNo!;
        ageController.text = current.age.toString();
        schoolIDController.text = current.schoolID!;
        teacherPinController.text = current.teacherPin.toString();
      }
    });
  }

  void setPhoneNo(String phoneNo) async {
    setState(() {
      progress = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, phoneNo);
    setState(() {
      progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            progress
                ? Center(child: CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(left: 30, top: 75, right: 30),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Center(
                            child: Icon(
                              Icons.account_circle,
                              size: 125,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          collapseStackIndex == 0
                              ? Column(
                                  children: [
                                    userDataStackIndex == 0
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Full Name:",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      fullNameController
                                                                  .value ==
                                                              null
                                                          ? "Unknown"
                                                          : fullNameController
                                                              .value.text,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    child: Icon(Icons.edit,
                                                        color: Colours.accent,
                                                        size: 16),
                                                    onTap: () {
                                                      setState(() {
                                                        userDataStackIndex =
                                                            userDataStackIndex ==
                                                                    0
                                                                ? 1
                                                                : 0;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              GetTeacherData(
                                                screenNameController:
                                                    screenNameController,
                                                phoneNumberController:
                                                    phoneNumberController,
                                                ageController: ageController,
                                                schoolIDController:
                                                    schoolIDController,
                                                teacherPinController:
                                                    teacherPinController,
                                                index: userDataStackIndex,
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Full Name:",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          fullNameController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Full Name",
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    child: Icon(Icons.edit,
                                                        color: Colours.accent,
                                                        size: 16),
                                                    onTap: () {
                                                      setState(() {
                                                        userDataStackIndex =
                                                            userDataStackIndex ==
                                                                    0
                                                                ? 1
                                                                : 0;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              ViewTeacherData(
                                                  screenNameController:
                                                      screenNameController,
                                                  phoneNumberController:
                                                      phoneNumberController,
                                                  ageController: ageController,
                                                  schoolIDController:
                                                      schoolIDController,
                                                  teacherPinController:
                                                      teacherPinController,
                                                  index: userDataStackIndex)
                                            ],
                                          ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("User Data",
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            child: Icon(
                                collapseStackIndex == 0
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.grey,
                                size: 30),
                            onTap: () {
                              setState(() {
                                collapseStackIndex =
                                    collapseStackIndex == 0 ? 1 : 0;
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                progress = true;
                              });
                              await FirebaseAuth.instance.signOut();
                              setState(() {
                                progress = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SplashPage();
                              }));
                            },
                            child: Text(
                              "Logout",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colours.accent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colours.accent,
                                                width: 1))),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _progress = true;
                                    });
                                    if (fullNameController.text == null) {
                                      const snackBar = SnackBar(
                                        content:
                                            Text('Please enter your full name'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (screenNameController.text ==
                                        null) {
                                      const snackBar = SnackBar(
                                        content: Text(
                                            'Please enter your screen name'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (phoneNumberController.text ==
                                        null) {
                                      const snackBar = SnackBar(
                                        content: Text(
                                            'Please enter your phone number'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (ageController.text == null) {
                                      const snackBar = SnackBar(
                                        content: Text('Please enter your age'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (schoolIDController.text ==
                                        null) {
                                      const snackBar = SnackBar(
                                        content:
                                            Text('Please enter your school ID'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      String schoolID = schoolIDController.text;
                                      if (await control.checkIfDocumentExists(
                                          "Schools/$schoolID")) {
                                        control.setTeacher(Teacher(
                                            fullNameController.text,
                                            screenNameController.text,
                                            phoneNumberController.text,
                                            int.tryParse(ageController.text),
                                            null,
                                            null,
                                            schoolIDController.text,
                                            int.tryParse(
                                                teacherPinController.text)));
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setString(prefKey,
                                            phoneNumberController.text);
                                        //? //print("true")
                                        //: //print("false");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home(
                                                      phoneNo:
                                                          phoneNumberController
                                                              .text,
                                                      schoolID:
                                                          schoolIDController
                                                              .text,
                                                    )));
                                      } else {
                                        Utils.showSnackBar(context,
                                            "School ID does not exist");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SchoolRegister(
                                                      phoneNo: phoneNo,
                                                    )));
                                      }
                                    }
                                    setState(() {
                                      _progress = false;
                                    });
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _progress
                                  ? CircularProgressIndicator()
                                  : Container(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}