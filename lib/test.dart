// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:pointer_teachers_v2/Storage/StorageStructure/ChildRank.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Section.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/Student.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/StudentList.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/StudentRank.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';

import 'Colours.dart';
import 'Storage/StorageStructure/Action.dart';
import 'Utils.dart';
import 'firebase_options.dart';

List<String> fullName = [
  "Quillan Morritt",
  "Luz Martschik",
  "Bili Jakubovits",
  "Adrian Longford",
  "Darcey Barrat",
  "Bobby Blaylock",
  "Cheryl Learman",
  "Ezekiel MacRury",
  "Elyse Wolland",
  "Etta Latliff",
];
List<String> screenName = [
  "Quillan",
  "Luz",
  "Bili",
  "Adrian",
  "Darcey",
  "Bobby",
  "Cheryl",
  "Ezekiel",
  "Elyse",
  "Etta",
];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      primarySwatch: Colours.accentMat,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Quicksand',
    );

    return MaterialApp(theme: themeData, title: 'Flutter Demo', home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CloudFirestoreControl control = CloudFirestoreControl();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: loading ? CircularProgressIndicator() : Text("Hello")),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "aadinair544@gmail.com", password: "mieowmieow");
        /*Section toSave = Section(
            StudentList(List<Student>.generate(
                10,
                (index) => Student.withOutLists(
                    fullName[index],
                    screenName[index],
                    Utils.random10DigitNumber(),
                    Utils.randomRange(14, 16),
                    Utils.random10DigitNumber(),
                    Utils.random10DigitNumber(),
                    "Candor",
                    ChildRank.Novice,
                    9,
                    "A",
                    0,
                    0,
                    "Candor",
                    Utils.random10DigitNumber(),
                    StudentRank.Novice))),
            "Candor",
            9,
            "A",
            "9093819203");
        await control.setSection(toSave);*/
        //await control.setAction(Action("Good boy",1000), "Candor", "Aadi Vijayakumar Nair ");
        await control.setAction(Action("A*",5000), "Candor", "Aadi Vijayakumar Nair");
        await FirebaseFirestore.instance
            .doc("/Schools/Candor/Students/Aadi Vijayakumar Nair/Actions/A")
            .set(Action("A",4500).toFirestore());
        setState(() {
          loading = false;
        });
      }),
    );
  }
}
