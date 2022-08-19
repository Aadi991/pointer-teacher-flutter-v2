import 'package:flutter/material.dart';

import '../Colours.dart';

class GetTeacherData extends StatefulWidget {
  TextEditingController screenNameController;
  TextEditingController phoneNumberController;
  TextEditingController ageController;
  TextEditingController schoolIDController;
  TextEditingController teacherPinController;
  int index;

  GetTeacherData(
      {Key? key,
      required this.screenNameController,
      required this.phoneNumberController,
      required this.ageController,
      required this.schoolIDController,
      required this.teacherPinController,
      required this.index})
      : super(key: key);

  @override
  State<GetTeacherData> createState() => _GetTeacherDataState();
}

class _GetTeacherDataState extends State<GetTeacherData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Screen Name:",
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.screenNameController.value == null
                  ? "Unknown"
                  : widget.screenNameController.value.text,
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Phone Number:",
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.phoneNumberController.value == null
                  ? "Unknown"
                  : widget.phoneNumberController.value.text,
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Age:",
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.ageController.value == null
                  ? "Unknown"
                  : widget.ageController.value.text,
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "School ID:",
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.schoolIDController.value == null
                  ? "Unknown"
                  : widget.schoolIDController.value.text,
              style: TextStyle(
                fontSize: 20,
                
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Teacher Pin:",
              style: TextStyle(
                fontSize: 20,

              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.teacherPinController.value == null
                  ? "Unknown"
                  : widget.teacherPinController.value.text,
              style: TextStyle(
                fontSize: 20,

              ),
            ),
          ],
        ),
      ],
    );
  }
}
