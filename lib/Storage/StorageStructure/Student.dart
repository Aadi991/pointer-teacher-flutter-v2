

// ignore: invalid_null_aware_operator

import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloudFirestoreControl.dart';
import 'ActionList.dart';
import 'ChildRank.dart';
import 'HistoryList.dart';
import 'ParentsList.dart';
import 'StudentRank.dart';
import 'SubjectGroup.dart';
import 'SubjectGroupList.dart';
import 'TeachersList.dart';

class Student {
  String? fullName, screenName, phoneNo;
  int? age;
  TeachersList? teachersList = TeachersList.empty();
  ActionList? actionList = ActionList.empty();
  ParentsList? parentsList = ParentsList.empty();
  HistoryList? historyList = HistoryList.empty();
  String? teachersID, parentsID, schoolID;
  ChildRank? rank;
  int? HomePoints, schoolPoints, grade;
  String? section, schoolRef, teacherRef;
  bool? isBoy;
  SubjectGroupList? subjectGroups;
  StudentRank? studentRank;

  Student(
      this.fullName,
      this.screenName,
      this.phoneNo,
      this.age,
      this.teachersList,
      this.actionList,
      this.parentsList,
      this.historyList,
      this.teachersID,
      this.parentsID,
      this.schoolID,
      this.rank,
      this.HomePoints,
      this.schoolPoints,
      this.grade,
      this.section,
      this.schoolRef,
      this.teacherRef,
      this.isBoy,
      this.subjectGroups,
      this.studentRank);

  Student.empty();

  Student.withOutLists(
      this.fullName,
      this.screenName,
      this.phoneNo,
      this.age,
      this.teachersID,
      this.parentsID,
      this.schoolID,
      this.rank,
      this.grade,
      this.section,
      this.HomePoints,
      this.schoolPoints,
      this.schoolRef,
      this.teacherRef,
      this.isBoy,
      this.studentRank);

  factory Student.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Student.withOutLists(
        data?[CloudFirestoreControl.keyFullName],
        data?[CloudFirestoreControl.keyScreenName],
        data?[CloudFirestoreControl.keyPhoneNumber],
        data?[CloudFirestoreControl.keyAge],
        data?[CloudFirestoreControl.keyTeacherID],
        data?[CloudFirestoreControl.keyParentID],
        data?[CloudFirestoreControl.keySchoolID],
        CloudFirestoreControl.stringToChildRank(data?[CloudFirestoreControl.keyHomeRanks]),
        data?[CloudFirestoreControl.keyGrade],
        data?[CloudFirestoreControl.keySection],
        data?[CloudFirestoreControl.keyHomePoints],
        data?[CloudFirestoreControl.keySchoolPoints],
        data?[CloudFirestoreControl.keySchoolID],
        data?[CloudFirestoreControl.keyTeacherRef],
        data?[CloudFirestoreControl.keyIsBoy],
        CloudFirestoreControl.stringToStudentRank(data?[CloudFirestoreControl.keyStudentRanks]));
  }

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student.withOutLists(
        data[CloudFirestoreControl.keyFullName],
        data[CloudFirestoreControl.keyScreenName],
        data[CloudFirestoreControl.keyPhoneNumber],
        data[CloudFirestoreControl.keyAge],
        data[CloudFirestoreControl.keyTeacherID],
        data[CloudFirestoreControl.keyParentID],
        data[CloudFirestoreControl.keySchoolID],
        CloudFirestoreControl.stringToChildRank(data[CloudFirestoreControl.keyHomeRanks]),
        data[CloudFirestoreControl.keyGrade],
        data[CloudFirestoreControl.keySection],
        data[CloudFirestoreControl.keyHomePoints],
        data[CloudFirestoreControl.keySchoolPoints],
        data[CloudFirestoreControl.keySchoolID],
        data[CloudFirestoreControl.keyTeacherRef],
        data[CloudFirestoreControl.keyIsBoy],
        CloudFirestoreControl.stringToStudentRank(data[CloudFirestoreControl.keyStudentRanks]));
  }

  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keyFullName: fullName,
      CloudFirestoreControl.keyScreenName: screenName,
      CloudFirestoreControl.keyPhoneNumber: phoneNo,
      CloudFirestoreControl.keyAge: age,
      CloudFirestoreControl.keyTeacherID: teachersID,
      CloudFirestoreControl.keyParentID: parentsID,
      CloudFirestoreControl.keySchoolID: schoolID,
      CloudFirestoreControl.keyHomeRanks: rank.toString(),
      CloudFirestoreControl.keyHomePoints: HomePoints,
      CloudFirestoreControl.keyGrade: grade,
      CloudFirestoreControl.keySection: section,
      CloudFirestoreControl.keySchoolPoints: schoolPoints,
      CloudFirestoreControl.keySchoolRef: schoolID,
      CloudFirestoreControl.keyTeacherRef: teacherRef,
      CloudFirestoreControl.keyIsBoy: isBoy,
      CloudFirestoreControl.keyStudentRanks: studentRank.toString()
    };
  }
}
