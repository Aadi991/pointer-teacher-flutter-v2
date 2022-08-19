import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloudFirestoreControl.dart';
import 'StringList.dart';
import 'StudentList.dart';
import 'Teacher.dart';

class SubjectGroup {
  StudentList? students;
  String? schoolID;
  String? teacherID;
  String? subject, HRTID;
  int? classGradeRef;

  SubjectGroup(this.students, this.schoolID, this.teacherID, this.subject,
      this.HRTID, this.classGradeRef);

  SubjectGroup.empty();

  SubjectGroup.withOutLists(this.schoolID, this.teacherID, this.subject,
      this.HRTID, this.classGradeRef, );

  factory SubjectGroup.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SubjectGroup.withOutLists(
        data?[CloudFirestoreControl.keySchoolID],
        data?[CloudFirestoreControl.keyTeacher],
        data?[CloudFirestoreControl.keySubjectName],
        data?[CloudFirestoreControl.keyHRTID],
        data?[CloudFirestoreControl.keyClassGradeRef]);
  }
  factory SubjectGroup.fromMap(Map<String, dynamic> data){
    return SubjectGroup.withOutLists(
        data[CloudFirestoreControl.keySchoolID],
        data[CloudFirestoreControl.keyTeacher],
        data[CloudFirestoreControl.keySubjectName],
        data[CloudFirestoreControl.keyHRTID],
        data[CloudFirestoreControl.keyClassGradeRef]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keySchoolID: schoolID,
      CloudFirestoreControl.keyTeacher: teacherID,
      CloudFirestoreControl.keySubjectName: subject,
      CloudFirestoreControl.keyHRTID: HRTID,
      CloudFirestoreControl.keyClassGradeRef:classGradeRef,
    };
  }
}
