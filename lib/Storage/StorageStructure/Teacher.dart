import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloudFirestoreControl.dart';
import 'Section.dart';
import 'SectionList.dart';

class Teacher{
  String? fullName, screenName, phoneNo;
  int? age;
  List<String>? classroomList;
  Section? HRClass;
  String? schoolID;
  int? teacherPin;

  Teacher(this.fullName, this.screenName, this.phoneNo, this.age,
      this.classroomList, this.HRClass, this.schoolID, this.teacherPin);

  Teacher.empty();

  Teacher.withOutLists(this.fullName, this.screenName, this.phoneNo, this.age,
      this.HRClass, this.schoolID, this.teacherPin);

  factory Teacher.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Teacher.withOutLists(
        data?[CloudFirestoreControl.keyFullName],
        data?[CloudFirestoreControl.keyScreenName],
        data?[CloudFirestoreControl.keyPhoneNumber],
        data?[CloudFirestoreControl.keyAge],
        data?[CloudFirestoreControl.keyHRClass],
        data?[CloudFirestoreControl.keySchoolID],
        data?[CloudFirestoreControl.keyTeacherPin],);
  }

  factory Teacher.fromMap(Map<String, dynamic> data) {
    return Teacher.withOutLists(
      data[CloudFirestoreControl.keyFullName],
      data[CloudFirestoreControl.keyScreenName],
      data[CloudFirestoreControl.keyPhoneNumber],
      data[CloudFirestoreControl.keyAge],
      data[CloudFirestoreControl.keyHRClass],
      data[CloudFirestoreControl.keySchoolID],
      data[CloudFirestoreControl.keyTeacherPin],);
  }


  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keyFullName:fullName,
      CloudFirestoreControl.keyScreenName:screenName,
      CloudFirestoreControl.keyPhoneNumber:phoneNo,
      CloudFirestoreControl.keyAge:age,
      CloudFirestoreControl.keyHRClass:HRClass,
      CloudFirestoreControl.keySchoolID:schoolID,
      CloudFirestoreControl.keyTeacherPin:teacherPin,
    };
  }
}