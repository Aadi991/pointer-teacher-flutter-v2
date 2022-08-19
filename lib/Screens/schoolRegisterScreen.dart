// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SchoolBoard.dart';
import 'package:pointer_teachers_v2/Widgets/getSchoolDataWidget.dart';

import '../Colours.dart';

class SchoolRegister extends StatefulWidget {
  String phoneNo;
  SchoolRegister({Key? key,required this.phoneNo}) : super(key: key);

  @override
  State<SchoolRegister> createState() => _SchoolRegisterState();
}

class _SchoolRegisterState extends State<SchoolRegister> {
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController schoolIDController = TextEditingController();
  String dropdownValue = "NONE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colours.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.school,
                      size: 50,
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GetSchoolData(
                phoneNo: widget.phoneNo,
                  schoolIDController: schoolIDController,
                  schoolNameController: schoolIDController,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownValue: dropdownValue)
            ])));
  }
}
