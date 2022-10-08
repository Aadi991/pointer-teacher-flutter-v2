import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/ChildRank.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/GradeList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/History.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Section.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SectionList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Student.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/StudentList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroupList.dart';
import 'package:pointer_teachers_v2/Utils.dart';
import 'StorageStructure/Action.dart';
import 'StorageStructure/ActionList.dart';
import 'StorageStructure/Grade.dart';
import 'StorageStructure/HistoryList.dart';
import 'StorageStructure/School.dart';
import 'StorageStructure/SchoolBoard.dart';
import 'StorageStructure/StudentRank.dart';
import 'StorageStructure/Teacher.dart';
import 'StorageStructure/TeachersList.dart';

class CloudFirestoreControl {
  FirebaseFirestore db =FirebaseFirestore.instance;

  //region Keys
  static const String keyFullName = "Full Name";
  static const String keyScreenName = "Screen Name";
  static const String keyPhoneNumber = "Phone Number";
  static const String keyAge = "Age";
  static const String keyStudentRanks = "Student Rank";
  static const String keyHomeRanks = "Rank";
  static const String keyTeacherID = "Teacher ID";
  static const String keyParentID = "Parent ID";
  static const String keySchoolID = "School ID";
  static const String keyIsStudent = "Is a Student?";
  static const String keySchoolPoints = "School Points";
  static const String keyHomePoints = "Home Points";
  static const String keyPin = "Parent Pin";
  static const String keyReason = "Reason";
  static const String keyValue = "Value";
  static const String keyTimestamp = "Timestamp";
  static const String keyAskParentPin = "Ask Parent Pin";
  static const String keyTeacherRef = "Teacher Reference";
  static const String keySchoolRef = "School Reference";
  static const String keySection = "Section";
  static const String keyPoints = "Points";

  //region School Data Keys
  static const String keySchoolBoard = "Board";
  static const String keySchoolName = "Name";
  static const String keyTeacherPin = "Teacher Pin";
  static const String keyIsBoy = "Is a Boy?";

  //KEY_SCHOOL_ID line 14
  //endregion

  static const String keySubjectGroup = "Subject Group";

  //region Grade Data Keys
  static const String keyGrade = "Grade";

  //endregion

  //region Section Data Keys
  static const String keyClassGrade = "Grade";
  static const String keyHRClass = "Homeroom Class";
  static const String keyClassSection = "Section";
  static const String keyHRTID = "Homeroom Teacher ID";
  static const String keySectionRef = "Section Reference";

  //endregion

  //region Subject Group Data Keys
  //KEY_SCHOOL_ID at line 11
  static const String keyTeacher = "Teacher ID";
  static const String keySubjectName = "Subject Name";
  static const String keyStudentID = "Student ID";
  static const String keyStudentRef = "Student Ref";

  //KEY_HRT_ID at line26
  static const String keyClassGradeRef = "Class Grade Reference";
  static const String keyClassSectionRef = "Class Section Reference";

  //endregion
  //endregion

  void setSchool(School toSave) {
    String? schoolID = toSave.schoolID;
    print("Setting school $schoolID");
    DocumentReference docRef = db
        .collection("Schools")
        .doc(toSave.schoolID)
        .withConverter<School>(
            fromFirestore: School.fromFirestore,
            toFirestore: (school, _) => school.toFirestore());
    docRef.set(toSave);
    if (toSave.grades != null) {
      GradeList grades = toSave.grades as GradeList;
      setGradeList(grades);
    }
    if (toSave.students != null) {
      StudentList students = toSave.students as StudentList;
      setStudentList(students);
    }
    if (toSave.teachers != null) {
      TeachersList teachers = toSave.teachers as TeachersList;
      setTeacherList(teachers);
    }
  }

  void updateSchool(String schoolID, School original,
      {SchoolBoard? schoolBoard, String? schoolName}) {
    if(db == null)
    if (schoolID == original.schoolID)
      db.collection("Schools").doc(schoolID).update(
          School.withOutLists(schoolBoard, schoolName, schoolID).toFirestore());
    else {
      db.collection("Schools").doc(original.schoolID).delete();
      db
          .collection("Schools")
          .doc(schoolID)
          .withConverter<School>(
              fromFirestore: School.fromFirestore,
              toFirestore: (school, _) => school.toFirestore())
          .set(School.withOutLists(schoolBoard, schoolName, schoolID));
    }
  }

  Future<School?> getSchool(String schoolID) async {
    DocumentReference<School> _docRef = db
        .collection("Schools")
        .doc(schoolID)
        .withConverter<School>(
            fromFirestore: School.fromFirestore,
            toFirestore: (school, _) => school.toFirestore());
    DocumentSnapshot<School?> snap = await _docRef.get();
    School? got = snap.data();
    got?.students = await getStudentList(schoolID);
    got?.teachers = await getTeacherList(schoolID);
    got?.grades = await getGradelist(schoolID);
    return got;
  }

  void setStudentList(StudentList toSave) {
    int length = toSave.studentList.length;
    print("Saving students list length $length");
    List<Student> list = toSave.studentList as List<Student>;
    for (final e in list) {
      setStudent(e);
    }
  }

  Future<StudentList?> getStudentList(String SchoolID) async {
    CollectionReference _collectionRef =
        db.collection("Schools").doc(SchoolID).collection("Students");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    StudentList list = StudentList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final e in allData) {
      Map<String, dynamic> data = e as Map<String, dynamic>;
      list.studentList.add(Student.fromMap(data));
    }
    return list;
  }

  Future setStudent(Student toSave) async {
    String? schoolID = toSave.schoolID;
    String? fullName = toSave.fullName;
    print("Saving student $schoolID $fullName");
    await db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Students")
        .doc(toSave.fullName)
        .withConverter<Student>(
            fromFirestore: Student.fromFirestore,
            toFirestore: (student, _) => student.toFirestore())
        .set(toSave);
    if (toSave.actionList != null) {
      ActionList actions = toSave.actionList as ActionList;
      setActionList(
          actions, toSave.schoolID.toString(), toSave.fullName.toString());
    }
  }

  void setActionList(ActionList toSave, String schoolID, String fullName) {
    int length = toSave.actionList!.length;
    print("Saving actions list length $length");
    List<Action> list = toSave.actionList as List<Action>;
    for (final e in list) {
      setAction(e, schoolID, fullName);
    }
  }

  Future<ActionList> getActionList(String schoolID, String fullName) async {
    List<Map<String, dynamic>> data = (await db
            .collection("Schools")
            .doc(schoolID)
            .collection("Students")
            .doc(fullName)
            .collection("Actions")
            .get())
        .docs
        .map((doc) => doc.data())
        .toList();
    return ActionList(List<Action>.generate(
        data.length, (index) => Action.fromMap(data[index])));
  }

  Future<Action?> getAction(
      String schoolID, String fullName, String reason) async {
    return (await db
            .collection("Schools")
            .doc(schoolID)
            .collection("Students")
            .doc(fullName)
            .collection("Actions")
            .doc(reason)
            .withConverter<Action>(
                fromFirestore: Action.fromFirestore,
                toFirestore: (action, _) => action.toFirestore())
            .get())
        .data();
  }

  Future setAction(Action toSave, String schoolID, String fullName) async {
    await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Students")
        .doc(fullName)
        .collection("Actions")
        .doc(toSave.reason)
        .withConverter<Action>(
            fromFirestore: Action.fromFirestore,
            toFirestore: (action, _) => action.toFirestore())
        .set(toSave);
    print(db
        .collection("Schools")
        .doc(schoolID)
        .collection("Students")
        .doc(fullName)
        .collection("Actions")
        .doc(toSave.reason)
        .path);
  }

  void setHistoryList(HistoryList toSave, String schoolID, String fullName) {
    List<History> list = toSave.historyList!;
    for (final e in list) {
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Students")
          .doc(fullName)
          .collection("History")
          .doc()
          .withConverter<History>(
              fromFirestore: History.fromFirestore,
              toFirestore: (history, _) => history.toFirestore())
          .set(e);
    }
  }

  Future<HistoryList> getHistoryList(String schoolID, String fullName) async {
    final allData = (await db
            .collection("Schools")
            .doc(schoolID)
            .collection("Students")
            .doc(fullName)
            .collection("History")
            .get())
        .docs
        .map((doc) => doc.data())
        .toList();
    return HistoryList(List<History>.generate(
        allData.length, (index) => History.fromMap(allData[index])));
  }

  Future updateStudent(Student original, Student newStudent) async {
    print("Updating student $newStudent.schoolID $newStudent.fullName");
    if (newStudent.schoolID == original.schoolID &&
        newStudent.fullName == original.fullName) {
      await db
          .collection("Schools")
          .doc(newStudent.schoolID)
          .collection("Students")
          .doc(newStudent.fullName)
          .update(newStudent.toFirestore());
    } else {
      await db
          .collection("Schools")
          .doc(original.schoolID)
          .collection("Students")
          .doc(original.fullName)
          .delete();
      await db
          .collection("Schools")
          .doc(newStudent.schoolID)
          .collection("Students")
          .doc(newStudent.fullName)
          .withConverter<Student>(
              fromFirestore: Student.fromFirestore,
              toFirestore: (student, _) => student.toFirestore())
          .set(newStudent);
    }
  }

  Future<Student?> getStudent(String SchoolID, String fullName) async {
    DocumentReference<Student> _docRef = db
        .collection("Schools")
        .doc(SchoolID)
        .collection("Students")
        .doc(fullName)
        .withConverter<Student>(
            fromFirestore: Student.fromFirestore,
            toFirestore: (student, _) => student.toFirestore());
    DocumentSnapshot<Student?> snap = await _docRef.get();
    return snap.data();
  }

  Future<Student?> getStudentWithRef(String ref) async {
    DocumentReference<Student> _docRef = db.doc(ref).withConverter<Student>(
        fromFirestore: Student.fromFirestore,
        toFirestore: (student, _) => student.toFirestore());
    DocumentSnapshot<Student?> snap = await _docRef.get();
    return snap.data();
  }

  void setTeacherList(TeachersList toSave) {
    int length = toSave.teachersList.length;
    print("Saving teachers list length $length");
    List<Teacher> list = toSave.teachersList as List<Teacher>;
    for (final e in list) {
      setTeacher(e);
    }
  }

  Future<TeachersList> getTeacherList(String schoolID) async {
    CollectionReference _collectionRef =
        db.collection("Schools").doc(schoolID).collection("Teachers");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    TeachersList list = TeachersList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final e in allData) {
      Map<String, dynamic> data = e as Map<String, dynamic>;
      list.teachersList.add(Teacher.fromMap(data));
    }
    return list;
  }

  void setTeacher(Teacher toSave) {
    String? schoolID = toSave.schoolID;
    String? phoneNo = toSave.phoneNo;
    print("Saving teacher $schoolID $phoneNo");
    DocumentReference docRef = db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Teachers")
        .doc(toSave.phoneNo)
        .withConverter<Teacher>(
            fromFirestore: Teacher.fromFirestore,
            toFirestore: (teacher, _) => teacher.toFirestore());
    docRef.set(toSave);
  }

  void updateTeacher(
    String schoolID,
    String phoneNo,
    Teacher original, {
    String? fullName,
    screenName,
    int? age,
    Section? HRClass,
    int? teacherPin,
  }) {
    if (schoolID == original.schoolID && phoneNo == original.phoneNo) {
      Map<String, dynamic> data = Map();
      if (fullName != null) data[keyFullName] = fullName;
      if (screenName != null) data[keyScreenName] = screenName;
      if (age != null) data[keyAge] = age;
      if (teacherPin != null) data[keyTeacherPin] = teacherPin;
      data[keySchoolID] = schoolID;
      data[keyPhoneNumber] = phoneNo;
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Teachers")
          .doc(phoneNo)
          .update(data);
    } else {
      Teacher toSave = Teacher.withOutLists(
          fullName, screenName, phoneNo, age, HRClass, schoolID, teacherPin);
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Teachers")
          .doc(phoneNo)
          .delete();
      setTeacher(toSave);
    }
  }

  Future<Teacher?> getTeacher(String schoolID, String phoneNo) async {
    DocumentReference<Teacher> _docRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Teachers")
        .doc(phoneNo)
        .withConverter<Teacher>(
            fromFirestore: Teacher.fromFirestore,
            toFirestore: (teacher, _) => teacher.toFirestore());
    DocumentSnapshot<Teacher?> snap = await _docRef.get();
    Teacher? got = snap.data();
    got?.classroomList = await getTeacherClassroomList(schoolID, phoneNo);
    return got;
  }

  void setTeacherClassroomList(
      String schoolID, String phoneNo, List<String> classroomList) async {
    await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Teachers")
        .doc(phoneNo)
        .collection("Classes")
        .doc("classes")
        .set({"Classes": classroomList});
  }

  Future<List<String>?> getTeacherClassroomList(
      String schoolID, String phoneNo) async {
    print("School Id: $schoolID");
    print("Phone Number: $phoneNo");
    DocumentSnapshot<Map<String, dynamic>> snap = await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Teachers")
        .doc(phoneNo)
        .collection("Classes")
        .doc("classes")
        .get();
    if (snap.data() == null) {
      return List<String>.empty();
    } else if (snap.exists == false) {
      return List<String>.empty();
    }
    Map<String, dynamic> data = snap.data()!;
    //return data["Classes"] as List<String>;
    return List<String>.from(
        (data["Classes"] as List).map((e) => e as String).toList(),
        growable: true);
  }

  Future setTeacherSubjectGroupList(
      String schoolID, String phoneNo, List<String> subjectGroupList) async {
    await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Teachers")
        .doc(phoneNo)
        .collection("Subjects")
        .doc("subjects")
        .set({"Subjects": subjectGroupList});
  }

  Future<List<String>> getTeacherSubjectGroupList(
      String schoolID, String phoneNo) async {
    DocumentSnapshot<Map<String, dynamic>> snap = await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Teachers")
        .doc(phoneNo)
        .collection("Subjects")
        .doc("subjects")
        .get();
    if (snap.data() == null) {
      return List<String>.empty();
    } else if (snap.exists == false) {
      return List<String>.empty();
    }
    Map<String, dynamic> data = snap.data()!;
    return List<String>.from(
        (data["Subjects"] as List).map((e) => e as String).toList(),
        growable: true);
  }

  void setGradeList(GradeList toSave) {
    List<Grade> list = toSave.gradeList as List<Grade>;
    for (final e in list) {
      setGrade(e);
    }
  }

  Future<GradeList> getGradelist(String schoolID) async {
    CollectionReference _collectionRef =
        db.collection("Schools").doc(schoolID).collection("Grades");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    GradeList list = GradeList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final e in allData) {
      Map<String, dynamic> data = e as Map<String, dynamic>;
      list.gradeList.add(Grade.fromMap(data));
    }
    return list;
  }

  void setGrade(Grade toSave) {
    DocumentReference docRef = db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Grades")
        .doc(toSave.grade.toString())
        .withConverter<Grade>(
            fromFirestore: Grade.fromFirestore,
            toFirestore: (grade, _) => grade.toFirestore());
    docRef.set(toSave);
    setSubjectGroupList(toSave.subjectGroupList as SubjectGroupList);
    setSectionList(toSave.sectionList as SectionList);
  }

  void updateGrade(String schoolID, int grade, Grade original) {
    if (schoolID == original.schoolID && grade == original.grade) {
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Grades")
          .doc(grade.toString())
          .update(original.toFirestore());
    } else {
      Grade toSave = Grade.withOutLists(schoolID, grade);
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Grades")
          .doc(grade.toString())
          .delete();
      setGrade(toSave);
    }
  }

  Future<Grade?> getGrade(String schoolID, int grade) async {
    DocumentReference<Grade> _docRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .withConverter<Grade>(
            fromFirestore: Grade.fromFirestore,
            toFirestore: (grade, _) => grade.toFirestore());
    DocumentSnapshot<Grade?> snap = await _docRef.get();
    Grade? got = snap.data();
    got?.sectionList = await getSectionList(schoolID, grade);
    got?.subjectGroupList = await getSubjectGroupList(schoolID, grade);
    return got;
  }

  void setSectionList(SectionList toSave) {
    List<Section> list = toSave.sectionList as List<Section>;
    for (final e in list) {
      setSection(e);
    }
  }

  Future<SectionList?> getSectionList(String schoolID, int grade) async {
    CollectionReference _collectionRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Section");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    SectionList list = SectionList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final e in allData) {
      Map<String, dynamic> data = e as Map<String, dynamic>;
      list.sectionList.add(Section.fromMap(data));
    }
    return list;
  }

  Future setSection(Section toSave) async {
    DocumentReference docRef = db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Grades")
        .doc(toSave.classGrade.toString())
        .collection("Section")
        .doc(toSave.classSection)
        .withConverter<Section>(
            fromFirestore: Section.fromFirestore,
            toFirestore: (section, _) => section.toFirestore());
    await docRef.set(toSave);
    if (toSave.students != null)
      setSectionStudentsList(
          toSave.students as StudentList, toSave.classSection!);
  }

  void updateSection(
      String schoolID, int classGrade, String classSection, Section original,
      {String? HRTID}) {
    if (schoolID != original.schoolID ||
        classGrade != original.classGrade ||
        classSection != original.classSection) {
      db
          .collection("Schools")
          .doc(original.schoolID)
          .collection("Grades")
          .doc(original.classGrade.toString())
          .collection("Section")
          .doc(original.classSection)
          .delete();
      setSection(
          Section.withOutLists(schoolID, classGrade, classSection, HRTID));
    } else {
      Map<String, dynamic> data = Map();
      if (HRTID != null) data[keyHRTID] = HRTID;
      data[keySchoolID] = schoolID;
      data[keyClassGrade] = classGrade;
      data[keyClassSection] = classSection;
      db
          .collection("Schools")
          .doc(schoolID)
          .collection("Grades")
          .doc(classGrade.toString())
          .collection("Section")
          .doc(classSection)
          .withConverter<Section>(
              fromFirestore: Section.fromFirestore,
              toFirestore: (section, _) => section.toFirestore())
          .update(data);
    }
  }

  Future<Section?> getSection(
      String schoolID, int grade, String section) async {
    DocumentReference<Section> _docRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Section")
        .doc(section)
        .withConverter<Section>(
            fromFirestore: Section.fromFirestore,
            toFirestore: (section, _) => section.toFirestore());
    DocumentSnapshot<Section?> snap = await _docRef.get();
    Section? got = snap.data();
    got?.students = await getSectionStudentsList(schoolID, grade, section);
    return got;
  }

  Future<Section> getSectionFromRef(String ref) async {
    DocumentReference<Section> _docRef = db.doc(ref).withConverter<Section>(
        fromFirestore: Section.fromFirestore,
        toFirestore: (section, _) => section.toFirestore());
    DocumentSnapshot<Section?> snap = await _docRef.get();
    Section? got = snap.data();
    got?.students = await getSectionStudentsListRef(ref + "/Students");
    return got!;
  }

  setSubjectGroupStudentsList(List<Student> students, String subject) {
    for (final e in students) {
      setSubjectGroupStudent(e, subject);
    }
  }

  Future<StudentList?> getSubjectGroupStudentsList(
      String schoolID, int grade, String subject) async {
    CollectionReference _collectionRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Subject Groups")
        .doc(subject)
        .collection("Students");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    StudentList list = StudentList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final e in allData) {
      Map<String, dynamic> data = e as Map<String, dynamic>;
      list.studentList.add(Student.fromMap(data));
    }
    return list;
  }

  setSubjectGroupStudent(Student toSave, String subject) {
    db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Grades")
        .doc(toSave.grade.toString())
        .collection("Subject Groups")
        .doc(subject)
        .collection("Students")
        .doc(toSave.fullName)
        .set(toSave.toFirestore());
  }

  setSectionStudentsList(StudentList students, String section) {
    for (final e in students.studentList) {
      setSectionStudent(e, section);
    }
  }

  Future<StudentList?> getSectionStudentsList(
      String schoolID, int grade, String section) async {
    final allData = (await db
            .collection("Schools")
            .doc(schoolID)
            .collection("Grades")
            .doc(grade.toString())
            .collection("Section")
            .doc(section)
            .collection("Students")
            .get())
        .docs
        .map((doc) => doc.data())
        .toList();
    StudentList list = StudentList(List<Student>.empty(growable: true));
    for (var element in allData) {
      list.studentList.add(
          await getStudentWithRef(element[keyStudentRef]) ?? Student.empty());
    }
    return list;
  }

  Future<StudentList?> getSectionStudentsListRef(String ref) async {
    final allData = (await db.collection("ref").get())
        .docs
        .map((doc) => doc.data())
        .toList();
    return StudentList(List<Student>.generate(
        allData.length, (index) => Student.fromMap(allData[index])));
    ;
  }

  Future setSectionStudent(Student toSave, String section) async {
    await db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Grades")
        .doc(toSave.grade.toString())
        .collection("Section")
        .doc(section)
        .collection("Students")
        .doc(toSave.fullName)
        .set({
      keyStudentRef: "/Schools/" +
          toSave.schoolID.toString() +
          "/Students/" +
          toSave.fullName.toString()
    });
  }

  Future updateSectionStudent(Student toSave, Student original) async {
    if (toSave.fullName == original.fullName) {
      await db
          .collection("Schools")
          .doc(toSave.schoolID)
          .collection("Grades")
          .doc(toSave.grade.toString())
          .collection("Section")
          .doc(toSave.section)
          .collection("Students")
          .doc(toSave.fullName)
          .set({
        keyStudentRef: "/Schools/" +
            toSave.schoolID.toString() +
            "/Students/" +
            toSave.fullName.toString()
      });
    } else {
      db
          .collection("Schools")
          .doc(original.schoolID)
          .collection("Grades")
          .doc(original.grade.toString())
          .collection("Section")
          .doc(original.section)
          .collection("Students")
          .doc(original.fullName)
          .delete();
      await db
          .collection("Schools")
          .doc(toSave.schoolID)
          .collection("Grades")
          .doc(toSave.grade.toString())
          .collection("Section")
          .doc(toSave.section)
          .collection("Students")
          .doc(toSave.fullName)
          .set({
        keyStudentRef: "/Schools/" +
            toSave.schoolID.toString() +
            "/Students/" +
            toSave.fullName.toString()
      });
    }
  }

  Future<Student?> getSectionStudent(
      String schoolID, int grade, String section, String fullName) async {
    return (await getStudentWithRef((await db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Section")
        .doc(section)
        .collection("Students")
        .doc(fullName)
        .get())[keyStudentRef]));
  }

  void setSubjectGroupList(SubjectGroupList toSave) {
    List<SubjectGroup>? list = toSave.subjectGroupList;
    for (final l in list) {
      setSubjectGroup(l);
    }
  }

  Future<SubjectGroupList> getSubjectGroupList(
      String schoolID, int grade) async {
    CollectionReference _collectionRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Subject Groups");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    SubjectGroupList list = SubjectGroupList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final o in allData) {
      Map<String, dynamic> data = o as Map<String, dynamic>;
      SubjectGroup got = SubjectGroup.fromMap(data);
      list.subjectGroupList.add(got);
      print(got.schoolID);
      print(got.HRTID);
      print(got.classGradeRef);
      print(got.subject);
      print(got.teacherID);
    }
    return list;
  }

  Future<SubjectGroupList> getSubjectGroupListRef(String ref) async {
    SubjectGroupList list = SubjectGroupList.empty();
    QuerySnapshot querySnapshot = await db.collection(ref).get();
    querySnapshot.docs.map((doc) => doc.data()).toList().forEach((element) {
      Map<String, dynamic> data = element as Map<String, dynamic>;
      SubjectGroup got = SubjectGroup.fromMap(data);
      list.subjectGroupList.add(got);
    });
    return list;
  }

  void setSubjectGroup(SubjectGroup toSave) {
    DocumentReference docRef = db
        .collection("Schools")
        .doc(toSave.schoolID)
        .collection("Grades")
        .doc(toSave.classGradeRef.toString())
        .collection("Subject Groups")
        .doc(toSave.subject)
        .withConverter<SubjectGroup>(
            fromFirestore: SubjectGroup.fromFirestore,
            toFirestore: (subjectGroup, _) => subjectGroup.toFirestore());
    print(docRef.toString());

    docRef.set(toSave);
    if (toSave.students != null) {
      StudentList list = toSave.students as StudentList;
      setStudentRefList(list, toSave);
    }
  }

  void updateSubjectGroup(SubjectGroup toSave, SubjectGroup original) {
    if (toSave.schoolID != original.schoolID ||
        toSave.classGradeRef != original.classGradeRef ||
        toSave.subject != original.subject) {
      DocumentReference<SubjectGroup> docRef = db
          .collection("Schools")
          .doc(original.schoolID)
          .collection("Grades")
          .doc(original.classGradeRef.toString())
          .collection("Subject Groups")
          .doc(original.subject)
          .withConverter<SubjectGroup>(
              fromFirestore: SubjectGroup.fromFirestore,
              toFirestore: (subjectGroup, _) => subjectGroup.toFirestore());
      docRef.delete();
      setSubjectGroup(toSave);
    } else {
      db
          .collection("Schools")
          .doc(toSave.schoolID)
          .collection("Grades")
          .doc(toSave.classGradeRef.toString())
          .collection("Subject Groups")
          .doc(toSave.subject)
          .update(toSave.toFirestore());
    }
  }

  Future<SubjectGroup?> getSubjectGroup(
      String schoolID, int grade, String subject) async {
    DocumentReference<SubjectGroup> docRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Subject Groups")
        .doc(subject)
        .withConverter<SubjectGroup>(
            fromFirestore: SubjectGroup.fromFirestore,
            toFirestore: (subjectGroup, _) => subjectGroup.toFirestore());
    DocumentSnapshot<SubjectGroup?> snap = await docRef.get();
    return snap.data();
  }

  Future<SubjectGroup> getSubjectGroupRef(String ref) async {
    DocumentReference<SubjectGroup> docRef = db
        .doc(ref)
        .withConverter<SubjectGroup>(
            fromFirestore: SubjectGroup.fromFirestore,
            toFirestore: (subjectGroup, _) => subjectGroup.toFirestore());
    DocumentSnapshot<SubjectGroup?> snap = await docRef.get();
    return snap.data() ?? SubjectGroup.empty();
  }

  void setStudentRefList(StudentList toSave, SubjectGroup ref) {
    List<Student> list = toSave.studentList as List<Student>;
    for (final e in list) {
      setStudentRef(e.screenName!, e.schoolID!, e.fullName!, ref);
    }
  }

  Future<StudentList> getStudentRefList(
      String schoolID, int grade, String section, String subject) async {
    CollectionReference _collectionRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Subject Groups")
        .doc(subject)
        .collection("Students");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    StudentList list = StudentList.empty();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (final o in allData) {
      Map<String, dynamic> data = o as Map<String, dynamic>;
      String ref = data[keyStudentRef];
      Student? got = await getStudentWithRef(ref);
      list.studentList.add(got!);
    }
    return list;
  }

  void setStudentRef(
      String screenName, String schoolID, String fullName, SubjectGroup ref) {
    DocumentReference docRef = db
        .collection("Schools")
        .doc(ref.schoolID)
        .collection("Grades")
        .doc(ref.classGradeRef.toString())
        .collection("Subject Groups")
        .doc(ref.subject)
        .collection("Students")
        .doc(screenName);
    docRef
        .set({keyStudentRef: "/Schools/" + schoolID + "/Students/" + fullName});
  }

  void updateStudentRef(
      String screenName, String schoolID, String fullName, SubjectGroup ref) {
    DocumentReference docRef = db
        .collection("Schools")
        .doc(ref.schoolID)
        .collection("Grades")
        .doc(ref.classGradeRef.toString())
        .collection("Subject Groups")
        .doc(ref.subject)
        .collection("Students")
        .doc(screenName);
    docRef.update(
        {keyStudentRef: "/Schools/" + schoolID + "/Students/" + fullName});
  }

  Future<String> getStudentRef(String schoolID, int grade, String section,
      String subject, String screenName) async {
    DocumentReference _docRef = db
        .collection("Schools")
        .doc(schoolID)
        .collection("Grades")
        .doc(grade.toString())
        .collection("Subject Groups")
        .doc(subject)
        .collection("Students")
        .doc(screenName);
    DocumentSnapshot doc = await _docRef.get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data[keyStudentRef];
  }

  Future<void> deleteDocRef(String ref) async {
    await db.doc(ref).delete();
  }

  static SchoolBoard stringToSchoolBoard(String? schoolBoard) {
    if (schoolBoard == null) return SchoolBoard.None;
    List<SchoolBoard> data = SchoolBoard.values;
    for (final e in data) {
      if (e.toString() == schoolBoard) {
        return e;
      }
    }
    return SchoolBoard.None;
  }

  static ChildRank stringToChildRank(String? childRank) {
    if (childRank == null) return ChildRank.None;
    List<ChildRank> data = ChildRank.values;
    for (final e in data) {
      if (e.toString() == childRank) {
        return e;
      }
    }
    return ChildRank.None;
  }

  static StudentRank stringToStudentRank(String? studentRank) {
    if (studentRank == null) return StudentRank.None;
    List<StudentRank> data = StudentRank.values;
    for (final e in data) {
      if (e.toString() == studentRank) {
        return e;
      }
    }
    return StudentRank.None;
  }

  void getPhoneNo() {}

  Future<bool> checkIfDocumentExists(String path) async {
    try {
      DocumentSnapshot snap = await db.doc(path).get();
      return snap.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
