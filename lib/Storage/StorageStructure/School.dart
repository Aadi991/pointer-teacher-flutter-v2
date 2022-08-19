import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloudFirestoreControl.dart';

import 'GradeList.dart';
import 'SchoolBoard.dart';
import 'StudentList.dart';
import 'TeachersList.dart';

class School {
  StudentList? students;
  TeachersList? teachers;
  GradeList? grades;
  SchoolBoard? schoolBoard;
  String? schoolName;
  String? schoolID;

  School(this.students, this.teachers, this.grades, this.schoolBoard,
      this.schoolName, this.schoolID);

  School.withOutLists(this.schoolBoard, this.schoolName, this.schoolID);

  School.empty();

  factory School.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return School.withOutLists(
        CloudFirestoreControl.stringToSchoolBoard( data?[CloudFirestoreControl.keySchoolBoard]),
        data?[CloudFirestoreControl.keySchoolName],
        data?[CloudFirestoreControl.keySchoolID]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keySchoolBoard: schoolBoard.toString(),
      CloudFirestoreControl.keySchoolName: schoolName,
      CloudFirestoreControl.keySchoolID: schoolID,
    };
  }


}
