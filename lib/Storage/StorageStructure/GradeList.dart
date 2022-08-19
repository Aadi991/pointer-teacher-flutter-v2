import 'Grade.dart';

class GradeList{
  List<Grade> gradeList;

  GradeList(this.gradeList);

  factory GradeList.empty(){
    return GradeList([ ]);
  }
}