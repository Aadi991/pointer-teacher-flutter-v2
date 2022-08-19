import 'package:flutter/material.dart';

class ViewTeacherData extends StatelessWidget {
  TextEditingController screenNameController;
  TextEditingController phoneNumberController;
  TextEditingController ageController;
  TextEditingController schoolIDController;
  TextEditingController teacherPinController;
  int index;

  ViewTeacherData(
      {Key? key,
        required this.screenNameController,
        required this.phoneNumberController,
        required this.ageController,
        required this.schoolIDController,
        required this.teacherPinController,
        required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          Expanded(
            child: TextField(
              controller: screenNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Screen Name",
              ),
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
          Expanded(
            child: TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone Number",
              ),
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
          Expanded(
            child: TextField(
              controller: ageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Age",
              ),
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
          Expanded(
            child: TextField(
              controller: schoolIDController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "School ID",
              ),
            ),
          ),
        ],
      ),
      Row(
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
          Expanded(
            child: TextField(
              controller: teacherPinController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Teacher Pin",
              ),
            ),
          ),
        ],
      )
    ],);
  }
}
