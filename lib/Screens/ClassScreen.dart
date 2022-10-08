// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Screens/homeScreen.dart';
import 'package:pointer_teachers_v2/Screens/newClassStudentScreen.dart';
import 'package:pointer_teachers_v2/Screens/newSubjectStudentScreen.dart';
import 'package:pointer_teachers_v2/Screens/Archive/signInOrRegisterScreen.dart';
import 'package:pointer_teachers_v2/Screens/studentScreen.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';
import 'package:pointer_teachers_v2/Widgets/studentListWidget.dart';

import '../Colours.dart';
import '../Storage/StorageStructure/Section.dart';
import '../Storage/StorageStructure/Student.dart';
import '../Storage/StorageStructure/StudentList.dart';
import '../Utils.dart';

class Classes extends StatefulWidget {
  Section clickedSection;
  String schoolID;
  String phoneNo;

  Classes(
      {Key? key,
      required this.clickedSection,
      required this.schoolID,
      required this.phoneNo})
      : super(key: key);

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  String schoolID = "";
  String phoneNo = "";
  TextEditingController classGradeController = TextEditingController();
  TextEditingController classSectionController = TextEditingController();
  TextEditingController HRTIDController = TextEditingController();
  CloudFirestoreControl control = CloudFirestoreControl();


  _ClassesState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    schoolID = widget.schoolID;
    phoneNo = widget.phoneNo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) async {
        if (details.delta.dy > 0) {
          setState(() {});
        }
      },
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
          List<String>? sectionStringList = snapshot.data;
          print(sectionStringList?.length);
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                    child: Text(widget.clickedSection.classGrade.toString() +
                        widget.clickedSection.classSection!)),
                automaticallyImplyLeading: true,
                actions: [
                  PopupMenuButton<String>(onSelected: (String result) {
                    if (result == Options.delete) {
                      sectionStringList?.remove(
                          "/Schools/${schoolID}/Grades/${widget.clickedSection.classGrade}/Section/${widget.clickedSection.classSection}");
                      control.setTeacherClassroomList(
                          schoolID, phoneNo, sectionStringList!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Home(schoolID: schoolID, phoneNo: phoneNo)));
                    } else if (result == Options.edit) {
                      print("editing");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditDialog(
                              schoolID: schoolID,
                              phoneNo: phoneNo,
                              clickedSection: widget.clickedSection,
                              sectionStringList: sectionStringList!,
                              classGradeController: classGradeController,
                              classSectionController: classSectionController,
                              HRTIDController: HRTIDController,
                            );
                          });
                    }
                  }, itemBuilder: (BuildContext context) {
                    return Options.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
                ],
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                          color: Colours.primary,
                          width: MediaQuery.of(context).size.width,
                          height: 125,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colours.accent,
                                      size: 75,
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewClassStudentScreen(
                                                  section:
                                                      widget.clickedSection,
                                                  schoolID: widget.schoolID,
                                                )))),
                              ),
                              Center(
                                child: Container(
                                  width: 1,
                                  color: Colours.accent,
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colours.accent,
                                    size: 75,
                                  ),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EditDialog(
                                          schoolID: schoolID,
                                          phoneNo: phoneNo,
                                          clickedSection: widget.clickedSection,
                                          sectionStringList: sectionStringList!,
                                          classGradeController:
                                              classGradeController,
                                          classSectionController:
                                              classSectionController,
                                          HRTIDController: HRTIDController,
                                        );
                                      }),
                                ),
                              )
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<StudentList?> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  List<Student>? studentList =
                                      snapshot.data!.studentList;
                                  if(studentList.length == 1&&studentList[0].fullName == null){
                                    studentList.removeAt(0);
                                  }
                                  for (var i = 0; i < studentList.length; i++) {
                                    print(
                                        "Element ${i} ${studentList[i].toFirestore().toString()}");
                                  }
                                  return Container(
                                    height: 650,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: studentList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(key: UniqueKey(), children: [
                                          Expanded(
                                            child: Container(
                                              width: 100,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2.5, horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.5, horizontal: 5),
                                              child: StudentListWidget(
                                                  onPressed: () {
                                                    print("pressed");
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StudentScreen(
                                                                  clickedStudent:
                                                                      studentList[
                                                                          index],
                                                                )));
                                                  },
                                                  onLongPress: () {
                                                    print("long pressed");
                                                  },
                                                  clickedStudent:
                                                      studentList[index]),
                                            ),
                                          ),
                                        ]);
                                      },
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                              future: control.getSectionStudentsList(
                                  schoolID,
                                  widget.clickedSection.classGrade!,
                                  widget.clickedSection.classSection!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Colors.red,
                    ),
                    Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  CircularProgressIndicator(),
                  Text("Loading...")
                ],
              )),
            );
          }
        },
        future: control.getTeacherClassroomList(schoolID, phoneNo),
      ),
    );
  }

  void edit() {}
}

class Options {
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const List<String> choices = [delete, edit];
}

class EditDialog extends StatelessWidget {
  TextEditingController classGradeController;
  TextEditingController classSectionController;
  TextEditingController HRTIDController;

  String phoneNo, schoolID;
  List<String> sectionStringList;
  Section clickedSection;

  EditDialog(
      {Key? key,
      required this.classGradeController,
      required this.classSectionController,
      required this.HRTIDController,
      required this.phoneNo,
      required this.schoolID,
      required this.sectionStringList,
      required this.clickedSection})
      : super(key: key) {
    classGradeController.text = clickedSection.classGrade.toString();
    classSectionController.text = clickedSection.classSection ?? "";
    HRTIDController.text = clickedSection.HRTID ?? "";
  }

  @override
  Widget build(BuildContext context) {
    CloudFirestoreControl control = CloudFirestoreControl();
    return AlertDialog(
      title: Text("Edit Section"),
      content: Container(
        height: 270,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
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
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
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
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Text("HRT ID"),
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
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Submit'),
          onPressed: () async {
            if (phoneNo == null || schoolID == null) {
              Utils.showSnackBar(context, 'Please login to create a class');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInOrRegister()));
              return;
            }
            if (classGradeController.text.isEmpty ||
                classSectionController.text.isEmpty ||
                HRTIDController.text.isEmpty) {
              Utils.showSnackBar(context, 'Please fill all the fields');
              return;
            }
            sectionStringList.remove(
                "/Schools/${schoolID}/Grades/${clickedSection.classGrade}/Section/${clickedSection.classSection}");

            sectionStringList.add(
                "/Schools/$schoolID/Grades/${classGradeController.text}/Section/${classSectionController.text}");
            control.setTeacherClassroomList(
                schoolID, phoneNo, sectionStringList);
            Navigator.pop(context);
            control.updateSection(
                schoolID,
                int.parse(classGradeController.value.text),
                classSectionController.text,
                clickedSection,
                HRTID: HRTIDController.text);
            classGradeController.value.text == "";
            classSectionController.value.text == "";
            HRTIDController.value.text == "";
          },
        ),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
  }
}
