import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Screens/newStudentScreen.dart';
import 'package:pointer_teachers_v2/Screens/studentScreen.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Colours.dart';
import '../Storage/StorageStructure/Student.dart';
import '../Widgets/studentListWidget.dart';

class SubjectGroupScreen extends StatefulWidget {
  SubjectGroup subjectGroup;
  String phoneNo;
  String schoolID;

  SubjectGroupScreen(
      {Key? key,
      required this.subjectGroup,
      required this.phoneNo,
      required this.schoolID})
      : super(key: key);

  @override
  State<SubjectGroupScreen> createState() => _SubjectGroupState();
}

class _SubjectGroupState extends State<SubjectGroupScreen> {
  CloudFirestoreControl control = CloudFirestoreControl();
  TextEditingController teacherIDController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    teacherIDController.text = widget.subjectGroup.teacherID!;
    subjectController.text = widget.subjectGroup.subject!;
    gradeController.text = widget.subjectGroup.classGradeRef.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.subjectGroup.subject!),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(onSelected: (String result) async {
              if (result == Options.delete) {
                setState(() {
                  loading = true;
                });
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                              "Are you sure you want to delete this group?"),
                          actions: [
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("Schools")
                                    .doc(widget.schoolID)
                                    .collection("Grades")
                                    .doc(widget.subjectGroup.classGradeRef
                                        .toString())
                                    .collection("Subject Groups")
                                    .doc(widget.subjectGroup.subject)
                                    .delete();
                                List<String> subjects =
                                    (await control.getTeacherSubjectGroupList(
                                        widget.schoolID, widget.phoneNo));
                                subjects.remove(
                                    "/Schools/${widget.schoolID}/Grades/${widget.subjectGroup.classGradeRef}/SubjectGroups/${widget.subjectGroup.subject}");
                                await control.setTeacherSubjectGroupList(
                                    widget.schoolID, widget.phoneNo, subjects);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
                setState(() {
                  loading = false;
                });
              } else if (result == Options.edit) {
                if (kDebugMode) {
                  print("editing");
                }
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Subject Group'),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                            controller: teacherIDController,
                            decoration: InputDecoration(
                              labelText: 'Teacher ID',
                            ),
                          ),
                          TextField(
                            controller: subjectController,
                            decoration: InputDecoration(
                              labelText: 'Subject',
                            ),
                          ),
                          TextField(
                            controller: gradeController,
                            decoration: InputDecoration(
                              labelText: 'Grade',
                            ),
                          ),
                        ]),
                        actions: [
                          TextButton(
                            child: Text('Update'),
                            onPressed: () async {
                              if (teacherIDController.text == null &&
                                  subjectController.text == null &&
                                  gradeController.text == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content:
                                            Text('Please fill in all fields'),
                                        actions: [
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                if (widget.subjectGroup ==
                                        gradeController.text &&
                                    widget.subjectGroup.subject ==
                                        subjectController.text) {
                                  Navigator.pop(context);
                                  control.updateSubjectGroup(
                                      SubjectGroup.withOutLists(
                                          widget.schoolID,
                                          teacherIDController.text,
                                          subjectController.text,
                                          null,
                                          int.parse(gradeController.text)),
                                      widget.subjectGroup);
                                  return;
                                } else {
                                  List<String> temp = List<String>.from(
                                      await control.getTeacherSubjectGroupList(
                                          widget.schoolID, widget.phoneNo),
                                      growable: true);
                                  temp.remove(
                                      "/Schools/${widget.schoolID}/Grades/${widget.subjectGroup.classGradeRef}/Subject Groups/${widget.subjectGroup.subject}");
                                  temp.add(
                                      "/Schools/${widget.schoolID}/Grades/${gradeController.text}/Subject Groups/${subjectController.text}");
                                  control.setTeacherSubjectGroupList(
                                      widget.schoolID, widget.phoneNo, temp);
                                  control.updateSubjectGroup(
                                      SubjectGroup.withOutLists(
                                        widget.schoolID,
                                        teacherIDController.text,
                                        subjectController.text,
                                        null,
                                        int.parse(gradeController.text),
                                      ),
                                      widget.subjectGroup);
                                  Navigator.pop(context);
                                  setState(() {
                                    gradeController.value.text == "";
                                    subjectController.value.text == "";
                                    teacherIDController.value.text == "";
                                  });
                                }
                              }
                            },
                          ),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"))
                        ],
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
          child: GestureDetector(
              onVerticalDragUpdate: (details) async {
                if (details.delta.dy > 0) {
                  setState(() {});
                }
              },
              child: loading
                  ? CircularProgressIndicator()
                  : Column(
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
                                          onPressed: () => NewStudentScreen(subjectGroup: widget.subjectGroup, schoolID: widget.schoolID))),
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
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EditDialog(
                                                teacherIDController:
                                                    teacherIDController,
                                                subjectController:
                                                    subjectController,
                                                gradeController:
                                                    gradeController,
                                                subjectGroup:
                                                    widget.subjectGroup,
                                                schoolID: widget.schoolID,
                                                phoneNo: widget.phoneNo);
                                          });
                                    },
                                  ))
                                ])),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              FutureBuilder(
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<String>?> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    List<String>? studentStringList =
                                        snapshot.data!;
                                    return Container(
                                      height: 650,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: studentStringList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                              key: UniqueKey(),
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.5,
                                                            horizontal: 5),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2.5,
                                                            horizontal: 5),
                                                    child:
                                                        FutureBuilder<Student>(
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<Student>
                                                              snapshot) {
                                                        if (snapshot.hasData &&
                                                            snapshot.data !=
                                                                null &&
                                                            snapshot.connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                          Student student =
                                                              snapshot.data!;
                                                          return StudentListWidget(
                                                              onPressed: () {
                                                                print(
                                                                    "pressed");
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            StudentScreen(
                                                                              clickedStudent: snapshot.data!,
                                                                            )));
                                                              },
                                                              onLongPress: () {
                                                                print(
                                                                    "long pressed");
                                                              },
                                                              clickedStudent:
                                                                  student);
                                                        } else {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
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
                                future: control.getTeacherSubjectGroupList(
                                    widget.schoolID, widget.phoneNo),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    teacherIDController.dispose();
    subjectController.dispose();
    gradeController.dispose();
  }
}

class Options {
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const List<String> choices = [delete, edit];
}

class EditDialog extends StatefulWidget {
  TextEditingController teacherIDController;
  TextEditingController subjectController;
  TextEditingController gradeController;
  SubjectGroup subjectGroup;
  String schoolID, phoneNo;

  EditDialog(
      {Key? key,
      required this.teacherIDController,
      required this.subjectController,
      required this.gradeController,
      required this.subjectGroup,
      required this.schoolID,
      required this.phoneNo})
      : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  CloudFirestoreControl control = CloudFirestoreControl();
  late TextEditingController teacherIDController;
  late TextEditingController subjectController;
  late TextEditingController gradeController;

  @override
  void initState() {
    super.initState();
    teacherIDController = widget.teacherIDController;
    subjectController = widget.subjectController;
    gradeController = widget.gradeController;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Subject Group'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: teacherIDController,
          decoration: InputDecoration(
            labelText: 'Teacher ID',
          ),
        ),
        TextField(
          controller: subjectController,
          decoration: InputDecoration(
            labelText: 'Subject',
          ),
        ),
        TextField(
          controller: gradeController,
          decoration: InputDecoration(
            labelText: 'Grade',
          ),
        ),
      ]),
      actions: [
        TextButton(
          child: Text('Update'),
          onPressed: () async {
            if (teacherIDController.text == null &&
                subjectController.text == null &&
                gradeController.text == null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill in all fields'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            } else {
              if (widget.subjectGroup == gradeController.text &&
                  widget.subjectGroup.subject == subjectController.text) {
                Navigator.pop(context);
                control.updateSubjectGroup(
                    SubjectGroup.withOutLists(
                        widget.schoolID,
                        teacherIDController.text,
                        subjectController.text,
                        null,
                        int.parse(gradeController.text)),
                    widget.subjectGroup);
                return;
              } else {
                List<String> temp = List<String>.from(
                    await control.getTeacherSubjectGroupList(
                        widget.schoolID, widget.phoneNo),
                    growable: true);
                temp.remove(
                    "/Schools/${widget.schoolID}/Grades/${widget.subjectGroup.classGradeRef}/Subject Groups/${widget.subjectGroup.subject}");
                temp.add(
                    "/Schools/${widget.schoolID}/Grades/${gradeController.text}/Subject Groups/${subjectController.text}");
                control.setTeacherSubjectGroupList(
                    widget.schoolID, widget.phoneNo, temp);
                control.updateSubjectGroup(
                    SubjectGroup.withOutLists(
                      widget.schoolID,
                      teacherIDController.text,
                      subjectController.text,
                      null,
                      int.parse(gradeController.text),
                    ),
                    widget.subjectGroup);
                Navigator.pop(context);
                setState(() {
                  gradeController.value.text == "";
                  subjectController.value.text == "";
                  teacherIDController.value.text == "";
                });
              }
            }
          },
        ),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
  }
}
