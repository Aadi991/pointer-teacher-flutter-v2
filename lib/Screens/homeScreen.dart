// ignore_for_file: prefer_const_constructors
/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Screens/NewClassScreen.dart';
import 'package:pointer_teachers_v2/Screens/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colours.dart';
import '../Storage/StorageStructure/Section.dart';
import '../Storage/StorageStructure/SectionList.dart';
import '../Storage/cloudFirestoreControl.dart';
import '../Utils.dart';
import '../Widgets/SectionWidget.dart';
import 'ClassScreen.dart';

class Home extends StatefulWidget {
  String phoneNo, schoolID;

  Home({Key? key, required this.schoolID, required this.phoneNo})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CloudFirestoreControl control = CloudFirestoreControl();
  SectionList? sectionList;
  bool loading = false;
  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Home')),
        ),
        body: Column(children: <Widget>[
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewClass(
                              phoneNo: widget.phoneNo.toString(),
                              schoolID: widget.schoolID.toString(),
                            ),
                          ),
                        );
                      },
                    ),
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
                        Icons.account_circle,
                        color: Colours.accent,
                        size: 75,
                      ),
                      onPressed: () {
                        GlobalVariables.profileFrom = ProfileFrom.Home;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
          !loading
              ? ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Row(
                      key: UniqueKey(),
                        children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 5),
                          child: SectionWidget(
                            key: UniqueKey(),
                            position: position,
                            section: sectionList?.sectionList[position] ??
                                Section.empty(),
                            context: context,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Classes(
                                    clickedSection:
                                        sectionList?.sectionList[position] ??
                                            Section.empty(),
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Section'),
                                      content: Text(
                                          'Are you sure you want to delete this section?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            sectionList?.sectionList
                                                .removeAt(position);
                                            List<String> list = List<
                                                    String>.generate(
                                                sectionList
                                                        ?.sectionList.length ??
                                                    0,
                                                (index) =>
                                                    "/Schools/${widget.schoolID}/Grades/${sectionList?.sectionList[index].classGrade}/Section/${sectionList?.sectionList[index].classSection}",
                                                growable: true);
                                            control.setTeacherClassroomList(
                                                widget.schoolID,
                                                widget.phoneNo,
                                                list);
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                        ),
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            phoneNo: widget.phoneNo,
                            schoolID: widget.schoolID,
                          ),
                        ),
                      )
                    ]);
                  },
                  itemCount: sectionList?.sectionList.length,
                )
              : CircularProgressIndicator()
        ]));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    sectionList = SectionList.empty();
    control.getTeacherClassroomList(widget.schoolID, widget.phoneNo).then(
        (value) => {
              value?.forEach((element) {
                control.getSectionFromRef(element).then((section) => {
                      sectionList?.sectionList.add(section!),
                      print(
                          "Section: ${section?.classGrade}${section?.classSection}")
                    });
              }),
            },
        onError: (error) => {
              print(error),
              setState(() {
                loading = false;
              })
            });

    setState(() {
      loading = false;
    });
    print("Section list length > ${sectionList?.sectionList.length}");
  }
}*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Screens/profileScreen.dart';
import 'package:pointer_teachers_v2/Screens/signInOrRegisterScreen.dart';
import 'package:pointer_teachers_v2/Screens/subjectGroupScreen.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/GradeList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SectionList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroupList.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Colours.dart';
import '../Storage/StorageStructure/Section.dart';
import '../Utils.dart';
import '../Widgets/SectionWidget.dart';
import '../Widgets/subjectGroupWidget.dart';
import 'ClassScreen.dart';
import 'NewClassScreen.dart';

class Home extends StatefulWidget {
  String phoneNo, schoolID;

  Home({Key? key, required this.schoolID, required this.phoneNo})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String schoolID = "";
  String phoneNo = "";
  TextEditingController classGradeController = TextEditingController();
  TextEditingController classSectionController = TextEditingController();
  TextEditingController HRTIDController = TextEditingController();

  TextEditingController teacherIDController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  CloudFirestoreControl control = CloudFirestoreControl();

  @override
  void initState() {
    this.phoneNo = widget.phoneNo;
    this.schoolID = widget.schoolID;
    print(phoneNo);
    print(schoolID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Home"),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              GlobalVariables.profileFrom = ProfileFrom.Home;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
            },
            child: Icon(
              Icons.account_circle,
              size: 50,
            ),
          )
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) async {
          if (details.delta.dy > 0) {
            setState(() {});
          }
        },
        child: FutureBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.connectionState == ConnectionState.done) {
              List<String>? sectionStringList = snapshot.data;
              print("Line 298 ${sectionStringList?.length}");
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Text(
                            "Classes",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, position) {
                              if (position == sectionStringList!.length) {
                                return InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Add Section"),
                                              content: Container(
                                                height: 270,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Class Grade"),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                    classGradeController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      'Class Grade',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 15),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  "Class Section"),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      classSectionController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        'Class Section',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                        child: Row(
                                                          children: [
                                                            Text("HRT ID"),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                    HRTIDController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      'Homeroom Teacher ID',
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
                                                    if (phoneNo == null ||
                                                        schoolID == null) {
                                                      Utils.showSnackBar(
                                                          context,
                                                          'Please login to create a class');
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SignInOrRegister()));
                                                      return;
                                                    }
                                                    if (classGradeController
                                                            .text.isEmpty ||
                                                        classSectionController
                                                            .text.isEmpty ||
                                                        HRTIDController
                                                            .text.isEmpty) {
                                                      Utils.showSnackBar(
                                                          context,
                                                          'Please fill all the fields');
                                                      return;
                                                    }
                                                    List<String> temp =
                                                        List<String>.empty(
                                                            growable: true);
                                                    temp.addAll(
                                                        sectionStringList);
                                                    temp.add(
                                                        "/Schools/${schoolID}/Grades/${classGradeController.text}/Section/${classSectionController.text}");
                                                    control
                                                        .setTeacherClassroomList(
                                                            schoolID,
                                                            phoneNo,
                                                            temp);
                                                    control.setSection(
                                                        Section.withOutLists(
                                                            schoolID,
                                                            int.parse(
                                                                classGradeController
                                                                    .text),
                                                            classSectionController
                                                                .text,
                                                            HRTIDController
                                                                .text));
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      classGradeController
                                                              .value.text ==
                                                          "";
                                                      classSectionController
                                                              .value.text ==
                                                          "";
                                                      HRTIDController
                                                              .value.text ==
                                                          "";
                                                    });
                                                  },
                                                ),
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Cancel"))
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.add_circle,
                                      size: 75,
                                      color: Colours.accent,
                                    ));
                              } else {
                                return Row(key: UniqueKey(), children: [
                                  Container(
                                    width: 100,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 5),
                                    child: FutureBuilder<Section>(
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Section> snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          Section section = snapshot.data!;
                                          return SectionWidget(
                                            key: UniqueKey(),
                                            position: position,
                                            section: section,
                                            context: context,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Classes(
                                                    clickedSection: section,
                                                    phoneNo: widget.phoneNo,
                                                    schoolID: widget.schoolID,
                                                  ),
                                                ),
                                              );
                                            },
                                            onLongPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Delete Section'),
                                                      content: Text(
                                                          'Are you sure you want to delete this section?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Yes'),
                                                          onPressed: () async {
                                                            sectionStringList
                                                                .removeAt(
                                                                    position);
                                                            control.setTeacherClassroomList(
                                                                widget.schoolID,
                                                                widget.phoneNo,
                                                                sectionStringList);
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('No'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            phoneNo: widget.phoneNo,
                                            schoolID: widget.schoolID,
                                          );
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                      future: control.getSectionFromRef(
                                          sectionStringList[position]),
                                    ),
                                  ),
                                ]);
                              }
                            },
                            itemCount: sectionStringList!.length + 1,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Text(
                            "Subject Groups",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              List<String> subjectGroupStringList = snapshot.data!;
                              return Container(
                                alignment: Alignment.centerLeft,
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, position) {
                                    print("Line 628: Subject Group List: Element ${position}");
                                    if (subjectGroupStringList.length == position) {
                                      return InkWell(
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colours.accent,
                                          size: 75,
                                        ),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Add Subject Group'),
                                                  content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                          teacherIDController,
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
                                                      child: Text('Add'),
                                                      onPressed: () async {
                                                        List<String> temp = List<String>.from(await control
                                                            .getTeacherSubjectGroupList(
                                                            widget.schoolID,
                                                            widget.phoneNo),growable: true);
                                                        temp.add(
                                                            "/Schools/${widget.schoolID}/Grades/${gradeController.text}/Subject Groups/${subjectController.text}");
                                                        control.setTeacherSubjectGroupList(
                                                            widget.schoolID,
                                                            widget.phoneNo,
                                                            temp);
                                                        control.setSubjectGroup(
                                                            SubjectGroup.withOutLists(
                                                              widget.schoolID,
                                                              teacherIDController.text,
                                                              subjectController.text,
                                                              null,
                                                              int.parse(
                                                                  gradeController.text),
                                                            ));
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          gradeController.value.text ==
                                                              "";
                                                          subjectController
                                                              .value.text ==
                                                              "";
                                                          teacherIDController
                                                              .value.text ==
                                                              "";
                                                        });
                                                      },
                                                    ),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context),
                                                        child: Text("Cancel"))
                                                  ],
                                                );
                                              });
                                        },
                                      );
                                    }
                                    return Row(key: UniqueKey(), children: [
                                      Container(
                                        width: 150,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.5, horizontal: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.5, horizontal: 5),
                                        child: FutureBuilder<SubjectGroup>(
                                          builder: (BuildContext context,
                                              AsyncSnapshot<SubjectGroup> snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != null &&
                                                snapshot.connectionState ==
                                                    ConnectionState.done) {
                                              SubjectGroup subjectGroup =
                                              snapshot.data!;
                                              return SubjectGroupWidget(
                                                key: UniqueKey(),
                                                position: position,
                                                subjectGroup: subjectGroup,
                                                context: context,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Subjects(
                                                            clickedSubject: subjectGroup,
                                                            phoneNo: widget.phoneNo,
                                                            schoolID: widget.schoolID,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                onLongPress: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Delete Subject Group'),
                                                          content: Text(
                                                              'Are you sure you want to delete this subject group?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text('Yes'),
                                                              onPressed: () async {
                                                                subjectGroupStringList
                                                                    .removeAt(position);
                                                                control.setTeacherSubjectGroupList(
                                                                    widget.schoolID,
                                                                    widget.phoneNo,
                                                                    subjectGroupStringList);
                                                                Navigator.pop(context);
                                                                setState(() {});
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text('No'),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                phoneNo: widget.phoneNo,
                                                schoolID: widget.schoolID,
                                              );
                                            } else {
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            }
                                          },
                                          future: control.getSubjectGroupRef(
                                              subjectGroupStringList[position]),
                                        ),
                                      ),
                                    ]);
                                  },
                                  itemCount: subjectGroupStringList.length + 1,
                                ),
                              );
                            }else{
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          future: control.getTeacherSubjectGroupList(schoolID, phoneNo).timeout(Duration(minutes: 1), onTimeout: (){
                            return List<String>.empty(growable: false);
                          }),
                        ),
                      ],
                    ),
                  )
                ]),
              );
            } else if (snapshot.hasError) {
              print("line 809 ${snapshot.error}");
              return Center(
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
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  CircularProgressIndicator(),
                  Text("Loading...")
                ],
              ));
            }
          },
          future: control.getTeacherClassroomList(schoolID, phoneNo),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    gradeController.dispose();
    subjectController.dispose();
    teacherIDController.dispose();
  }
}
