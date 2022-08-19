import 'Section.dart';

class SectionList{
  List<Section> sectionList;

  SectionList(this.sectionList);

  factory SectionList.empty(){
    return new SectionList([ ]);
  }
}