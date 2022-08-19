// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/ChildRank.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Student.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/StudentRank.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Storage/StorageStructure/Section.dart';
import '../Utils.dart';

class EditStudentScreen extends StatefulWidget {
  String schoolID;
  Student currentStudent;

  EditStudentScreen({Key? key, required this.schoolID,required this.currentStudent})
      : super(key: key);

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _screenNameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _teachersIDController = TextEditingController();
  TextEditingController _parentsIDController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _sectionController = TextEditingController();
  CloudFirestoreControl control = CloudFirestoreControl();
  bool loading = false;

  String gender = "";


  @override
  void initState() {
    _fullNameController.text = widget.currentStudent.fullName!;
    _screenNameController.text = widget.currentStudent.screenName!;
    _ageController.text = widget.currentStudent.age.toString();
    _phoneNoController.text = widget.currentStudent.phoneNo!;
    _teachersIDController.text = widget.currentStudent.teachersID!;
    _parentsIDController.text = widget.currentStudent.parentsID!;
    _gradeController.text = widget.currentStudent.grade.toString();
    _sectionController.text = widget.currentStudent.section!;
    gender = widget.currentStudent.isBoy! ? "Boy":"Girl";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Edit '),
        ),
        body: SingleChildScrollView(
          child: loading
              ? Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text('Cancel')),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _screenNameController,
                        decoration: InputDecoration(
                          labelText: 'Screen Name',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _phoneNoController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _teachersIDController,
                        decoration: InputDecoration(
                          labelText: 'Teachers ID',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _parentsIDController,
                        decoration: InputDecoration(
                          labelText: 'Parents ID',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _gradeController,
                        decoration: InputDecoration(
                          labelText: 'Grade',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _sectionController,
                        decoration: InputDecoration(
                          labelText: 'Section',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Boy'),
                              leading: Radio<String>(
                                value: "Boy",
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Girl'),
                              leading: Radio<String>(
                                value: "Girl",
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_fullNameController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_screenNameController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_phoneNoController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_ageController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_teachersIDController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_parentsIDController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_gradeController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else if (_sectionController == null) {
                              Utils.showSnackBar(
                                  context, "Fill all the fields");
                              return;
                            } else {
                              setState(() {
                                loading = true;
                              });
                              await control.updateStudent(
                                Student.withOutLists(
                                    _fullNameController.text.trim(),
                                    _screenNameController.text.trim(),
                                    _phoneNoController.text.trim(),
                                    int.parse(_ageController.text.trim()),
                                    _teachersIDController.text.trim(),
                                    _parentsIDController.text.trim(),
                                    widget.schoolID,
                                    ChildRank.None,
                                    int.parse(_gradeController.text.trim()),
                                    _sectionController.text.trim(),
                                    0,
                                    0,
                                    widget.schoolID,
                                    "",
                                    gender == "Boy" ? true : false,
                                    StudentRank.None),
                                widget.currentStudent
                              );
                              await control.updateStudent(widget.currentStudent, Student.withOutLists(
                                  _fullNameController.text.trim(),
                                  _screenNameController.text.trim(),
                                  _phoneNoController.text.trim(),
                                  int.parse(_ageController.text.trim()),
                                  _teachersIDController.text.trim(),
                                  _parentsIDController.text.trim(),
                                  widget.schoolID,
                                  ChildRank.None,
                                  int.parse(_gradeController.text.trim()),
                                  _sectionController.text.trim(),
                                  0,
                                  0,
                                  widget.schoolID,
                                  "",
                                  gender == "Boy" ? true : false,
                                  StudentRank.None));
                              setState(() {
                                loading = false;
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Text("Submit"))
                    ],
                  ),
                ),
        ));
  }
}
