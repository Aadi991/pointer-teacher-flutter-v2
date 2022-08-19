import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/StudentList.dart';
import '../cloudFirestoreControl.dart';

import 'SubjectGroupList.dart';

class Section {
  StudentList? students;
  String? schoolID;
  int? classGrade;
  String? classSection, HRTID;

  Section(this.students, this.schoolID, this.classGrade,
      this.classSection, this.HRTID);

  Section.empty();

  Section.withOutLists(
      this.schoolID, this.classGrade, this.classSection, this.HRTID);

  factory Section.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Section.withOutLists(
        data?[CloudFirestoreControl.keySchoolID],
        data?[CloudFirestoreControl.keyClassGrade],
        data?[CloudFirestoreControl.keyClassSection],
        data?[CloudFirestoreControl.keyHRTID]);
  }

  factory Section.fromMap(Map<String, dynamic> data) {
    return Section.withOutLists(
        data[CloudFirestoreControl.keySchoolID],
        data[CloudFirestoreControl.keyClassGrade],
        data[CloudFirestoreControl.keyClassSection],
        data[CloudFirestoreControl.keyHRTID]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keySchoolID: schoolID,
      CloudFirestoreControl.keyClassGrade: classGrade,
      CloudFirestoreControl.keyClassSection: classSection,
      CloudFirestoreControl.keyHRTID: HRTID
    };
  }
}
