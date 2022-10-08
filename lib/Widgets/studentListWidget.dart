import 'package:flutter/material.dart';

import '../Colours.dart';
import '../Storage/StorageStructure/Student.dart';

class StudentListWidget extends StatefulWidget {
  Function onPressed;
  Function onLongPress;
  Student clickedStudent;

  StudentListWidget(
      {Key? key,
      required this.onPressed,
      required this.onLongPress,
      required this.clickedStudent})
      : super(key: key);

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed();
      },
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
            Image.asset(
              widget.clickedStudent.isBoy!?'images/boy.png':'images/girl.png',
              height: 120,
              width: 120,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.clickedStudent.fullName??'',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.clickedStudent.age.toString(),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Points:",
                    style: TextStyle(fontSize: 20, color: Colours.accent)),
                SizedBox(
                  width:10
                ),
                Text(
                  widget.clickedStudent.schoolPoints.toString(),
                  style: TextStyle(fontSize: 20),
                ),],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.clickedStudent.grade.toString() +
                  widget.clickedStudent.section.toString(),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'images/ranks/Beginner.png',
              height: 60,
              width: 60,
            ),
          ]
        ),
      ),
    );
  }
}
