import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:pointer_teachers_v2/Screens/newSubjectStudentScreen.dart';
import 'package:pointer_teachers_v2/Screens/studentScreen.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Colours.dart';
import '../Storage/StorageStructure/Student.dart';
import '../Storage/StorageStructure/StudentList.dart';
import '../Utils.dart';
import '../Widgets/studentListWidget.dart';
import 'homeScreen.dart';

class Subjects extends StatefulWidget {
  SubjectGroup clickedSubject;
  String schoolID;
  String phoneNo;

  Subjects(
      {Key? key,
      required this.clickedSubject,
      required this.schoolID,
      required this.phoneNo})
      : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String schoolID = "";
  String phoneNo = "";
  TextEditingController schoolIDController = TextEditingController();
  TextEditingController teacherIDController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController HRTIDController = TextEditingController();
  TextEditingController classGradeRefController = TextEditingController();
  CloudFirestoreControl control = CloudFirestoreControl();

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
          List<String>? subjectGroupStringList = snapshot.data;
          print(subjectGroupStringList?.length);
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text(widget.clickedSubject.subject!)),
                automaticallyImplyLeading: true,
                actions: [
                  PopupMenuButton<String>(onSelected: (String result) {
                    if (result == Options.delete) {
                      subjectGroupStringList?.remove(
                          "/Schools/${schoolID}/Grades/${widget.clickedSubject.classGradeRef}/Subject Groups/${widget.clickedSubject.subject}");
                      control.setTeacherClassroomList(
                          schoolID, phoneNo, subjectGroupStringList!);
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
                            return EditDialog(schoolIDController: schoolIDController, teacherIDController: teacherIDController, subjectController: subjectController, HRTIDController: HRTIDController, classGradeRefController: classGradeRefController, phoneNo: phoneNo, schoolID: schoolID, subjectGroupStringList: subjectGroupStringList!, clickedSubject: widget.clickedSubject);
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
                                                NewSubjectStudentScreen(
                                                  subjectGroup: widget.clickedSubject,
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
                                        return EditDialog(schoolIDController: schoolIDController, teacherIDController: teacherIDController, subjectController: subjectController, HRTIDController: HRTIDController, classGradeRefController: classGradeRefController, phoneNo: phoneNo, schoolID: schoolID, subjectGroupStringList: subjectGroupStringList!, clickedSubject: widget.clickedSubject);
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
                                  if (studentList.length == 1 &&
                                      studentList[0].fullName == null) {
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
                              future: control.getSubjectGroupStudentsList(schoolID, widget.clickedSubject.classGradeRef!, widget.clickedSubject.subject!)
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
  TextEditingController schoolIDController;
  TextEditingController teacherIDController;
  TextEditingController subjectController;
  TextEditingController HRTIDController;
  TextEditingController classGradeRefController;

  String phoneNo, schoolID;
  List<String> subjectGroupStringList;
  SubjectGroup clickedSubject;

  EditDialog(
      {Key? key,
      required this.schoolIDController,
      required this.teacherIDController,
      required this.subjectController,
      required this.HRTIDController,
      required this.classGradeRefController,
      required this.phoneNo,
      required this.schoolID,
      required this.subjectGroupStringList,
      required this.clickedSubject})
      : super(key: key) {
    schoolIDController.text = clickedSubject.schoolID!;
    teacherIDController.text = clickedSubject.teacherID!;
    subjectController.text = clickedSubject.subject!;
    HRTIDController.text = clickedSubject.HRTID!;
    classGradeRefController.text = clickedSubject.classGradeRef.toString();
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
                  children: [
                    Text("School ID"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: schoolIDController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'School ID',
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
                    Text("Teacher ID"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: teacherIDController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Teacher ID',
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
                    Text("Subject"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: subjectController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Subject',
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
              ),
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
                        controller: classGradeRefController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Class Grade',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  MaterialPageRoute(builder: (context) => PhoneInputScreen()));
              return;
            }
            if (schoolIDController.text.isEmpty ||
                teacherIDController.text.isEmpty ||
                subjectController.text.isEmpty ||
                HRTIDController.text.isEmpty ||
                classGradeRefController.text.isEmpty) {
              Utils.showSnackBar(context, 'Please fill all the fields');
              return;
            }
            subjectGroupStringList.remove(
                "/Schools/${schoolID}/Grades/${clickedSubject.classGradeRef}/Subject Group/${clickedSubject.subject}");

            subjectGroupStringList.add(
                "/Schools/${schoolID}/Grades/${classGradeRefController.text}/Subject Group/${subjectController.text}");
            control.setTeacherClassroomList(
                schoolID, phoneNo, subjectGroupStringList);
            Navigator.pop(context);
            control.updateSubjectGroup(
                clickedSubject,
                SubjectGroup.withOutLists(
                    schoolIDController.text,
                    teacherIDController.text,
                    subjectController.text,
                    HRTIDController.text,
                    int.parse(classGradeRefController.text)));
          },
        ),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
  }
}
