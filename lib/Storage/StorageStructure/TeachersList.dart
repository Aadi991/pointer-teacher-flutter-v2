import 'package:pointer_teachers_v2/Storage/StorageStructure/Teacher.dart';

class TeachersList{
  List<Teacher> teachersList;

  TeachersList(this.teachersList);

  factory TeachersList.empty(){
    return TeachersList([ ]);
  }
}