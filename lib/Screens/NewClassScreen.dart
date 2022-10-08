// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Screens/Archive/signInOrRegisterScreen.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Storage/StorageStructure/Section.dart';
import '../Storage/StorageStructure/SectionList.dart';
import '../Utils.dart';

class NewClass extends StatefulWidget {
  String phoneNo, schoolID;

  NewClass({Key? key, required this.schoolID, required this.phoneNo})
      : super(key: key);

  @override
  State<NewClass> createState() => _NewClassState();
}

class _NewClassState extends State<NewClass> {
  CloudFirestoreControl control = CloudFirestoreControl();
  String? phoneNo;
  String? schoolID;
  TextEditingController classGradeController = TextEditingController();
  TextEditingController classSectionController = TextEditingController();
  TextEditingController HRTIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('New Class')),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Class Grade"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: classGradeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Class Grade',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text("Class Section"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: classSectionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Class Section',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text("Homeroom Teacher ID"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: HRTIDController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Homeroom Teacher ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text('Create Class'),
                      onPressed: () async {
                        if (phoneNo == null || schoolID == null) {
                          Utils.showSnackBar(
                              context, 'Please login to create a class');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInOrRegister()));
                          return;
                        }
                        if (classGradeController.text.isEmpty ||
                            classSectionController.text.isEmpty ||
                            HRTIDController.text.isEmpty) {
                          Utils.showSnackBar(
                              context, 'Please fill all the fields');
                          return;
                        }
                        control.setSection(Section.withOutLists(
                            schoolID,
                            int.parse(classGradeController.text),
                            classSectionController.text,
                            HRTIDController.text));
                        List<String> sectionList = List<String>.from(
                            await control.getTeacherClassroomList(
                                    schoolID!, phoneNo!) ??
                                List<String>.empty());

                        sectionList.add(
                            "/Schools/$schoolID/Grades/${classGradeController.text}/Section/${classSectionController.text}");
                        control.setTeacherClassroomList(
                            schoolID!, phoneNo!, sectionList);
                        Future.delayed(Duration(seconds: 5), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ))));
  }

  @override
  void initState() {
    super.initState();
    phoneNo = widget.phoneNo;
    schoolID = widget.schoolID;
  }
}
