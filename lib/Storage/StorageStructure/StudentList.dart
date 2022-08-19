import 'package:pointer_teachers_v2/Storage/StorageStructure/Student.dart';

class StudentList{
  List<Student> studentList;

  StudentList(this.studentList);

  factory StudentList.empty(){
    return StudentList([ ]);
  }
}