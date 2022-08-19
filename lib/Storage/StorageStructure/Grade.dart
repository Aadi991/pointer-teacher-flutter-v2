import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloudFirestoreControl.dart';
import 'SectionList.dart';
import 'SubjectGroupList.dart';

class Grade {
  SectionList? sectionList;
  SubjectGroupList? subjectGroupList;
  String? schoolID;
  int? grade;


  Grade(this.sectionList, this.subjectGroupList, this.schoolID, this.grade);

  Grade.empty();

  Grade.withOutLists(this.schoolID, this.grade);

  factory Grade.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Grade.withOutLists(
      data?[CloudFirestoreControl.keySchoolID],
      data?[CloudFirestoreControl.keyGrade],
    );
  }

  factory Grade.fromMap(Map<String, dynamic> data) {
    return Grade.withOutLists(
      data[CloudFirestoreControl.keySchoolID],
      data[CloudFirestoreControl.keyGrade],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keySchoolID: schoolID,
      CloudFirestoreControl.keyGrade: grade,
    };
  }
}
