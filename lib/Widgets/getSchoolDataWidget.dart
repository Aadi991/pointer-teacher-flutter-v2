// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SchoolBoard.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import '../Screens/homeScreen.dart';
import '../Storage/StorageStructure/School.dart';

class GetSchoolData extends StatefulWidget {
  TextEditingController schoolNameController;
  TextEditingController schoolIDController;
  Function(String?)? onChanged;
  String dropdownValue;
  String phoneNo;

  GetSchoolData(
      {Key? key,
      required this.schoolIDController,
      required this.schoolNameController,
      required this.onChanged,
      required this.dropdownValue,
      required this.phoneNo})
      : super(key: key);

  @override
  State<GetSchoolData> createState() => _GetSchoolDataState();
}

class _GetSchoolDataState extends State<GetSchoolData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "School Name:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: widget.schoolNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "School Name",
                ),
              ),
            ),
          ],
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
                controller: widget.schoolIDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "School ID",
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "School Board:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    icon: Icon(Icons.expand_more),
                    value: widget.dropdownValue,
                    items: [
                      DropdownMenuItem(child: Text("NONE"), value: "NONE"),
                      DropdownMenuItem(child: Text("CBSE"), value: "CBSE"),
                      DropdownMenuItem(child: Text("ICSE"), value: "ICSE"),
                      DropdownMenuItem(child: Text("CISCE"), value: "CISCE"),
                      DropdownMenuItem(child: Text("NIOS"), value: "NIOS"),
                      DropdownMenuItem(child: Text("IGCSE"), value: "IGCSE"),
                      DropdownMenuItem(child: Text("IB"), value: "IB"),
                    ],
                    onChanged: widget.onChanged),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  if (widget.schoolIDController.text.isEmpty ||
                      widget.schoolNameController.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Please fill all the fields"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    CloudFirestoreControl control = CloudFirestoreControl();
                    control.setSchool(School.withOutLists(getSchoolBoard(widget.dropdownValue),
                        widget.schoolNameController.text, widget.dropdownValue));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  phoneNo: widget.phoneNo,
                                  schoolID: widget.schoolIDController.text,
                                )));
                  }
                },
                child: Text("Submit")),
          ],
        ),
      ],
    );
  }
}

SchoolBoard? getSchoolBoard(String dropdownValue) {
  switch (dropdownValue) {
    case "NONE":
      return null;
    case "CBSE":
      return SchoolBoard.CBSE;
    case "ICSE":
      return SchoolBoard.ICSE;
    case "CISCE":
      return SchoolBoard.CISCE;
    case "NIOS":
      return SchoolBoard.NIOS;
    case "IGCSE":
      return SchoolBoard.IGCSE;
    case "IB":
      return SchoolBoard.IB;
    default:
      return null;
  }
}
