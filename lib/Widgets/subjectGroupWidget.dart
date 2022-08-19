// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Storage/StorageStructure/Section.dart';

class SubjectGroupWidget extends StatefulWidget {
  SubjectGroup subjectGroup;
  GestureTapCallback onPressed;
  int position;
  String schoolID, phoneNo;
  BuildContext context;
  Function onLongPress;

  SubjectGroupWidget(
      {Key? key,
      required this.subjectGroup,
      required this.onPressed,
      required this.position,
      required this.context,
      required this.phoneNo,
      required this.schoolID,
      required this.onLongPress})
      : super(key: key);

  @override
  State<SubjectGroupWidget> createState() => _SubjectGroupWidgetState();
}

class _SubjectGroupWidgetState extends State<SubjectGroupWidget> {
  CloudFirestoreControl control = CloudFirestoreControl();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onLongPress: () {
        widget.onLongPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 30,
            ),
            Text(
              "Grade ${widget.subjectGroup.classGradeRef}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${widget.subjectGroup.subject}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
