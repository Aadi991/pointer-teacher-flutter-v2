import 'SubjectGroup.dart';

class SubjectGroupList{
  List<SubjectGroup> subjectGroupList;

  SubjectGroupList(this.subjectGroupList);

  factory SubjectGroupList.empty(){
    return new SubjectGroupList([ ]);
}}