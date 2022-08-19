// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Storage/StorageStructure/Section.dart';

class SectionWidget extends StatefulWidget {
  Section section;
  GestureTapCallback onPressed;
  int position;
  String schoolID, phoneNo;
  BuildContext context;
  Function onLongPress;

  SectionWidget(
      {Key? key,
      required this.section,
      required this.onPressed,
      required this.position,
      required this.context,
      required this.phoneNo,
      required this.schoolID,
      required this.onLongPress})
      : super(key: key);

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
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
              widget.section.classGrade.toString() +
                  widget.section.classSection.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
