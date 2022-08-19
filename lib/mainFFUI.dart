// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:pointer_teachers_v2/Storage/StorageStructure/SubjectGroup.dart';
import 'package:pointer_teachers_v2/Storage/cloudFirestoreControl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pointer_teachers_v2/Utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const providerConfigs = [
      EmailProviderConfiguration(),
      GoogleProviderConfiguration(
          clientId:
              '696596299791-alt408dif151f3e32ueqm68daochufst.apps.googleusercontent.com'),
      PhoneProviderConfiguration()
    ];

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.blue,
      ),
      title: 'Flutter Demo',
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      //home: const SplashPage(),
      //initialRoute: '/',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/sign-in': (context) {
          return SignInScreen(
            providerConfigs: providerConfigs,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                 Future.delayed(Duration.zero, () {
                  Navigator.pushReplacementNamed(context, '/profile');
                });
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providerConfigs: providerConfigs,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  CloudFirestoreControl? control;

  String random10DigitNumber() {
    String ret = " ";
    for (int i = 0; i < 10; i++) {
      ret = ret + Utils.randomRange(1, 9).toString();
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pointer Teachers",
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9AA33)),
              textAlign: TextAlign.center,
            ),
            Text(
              "Children, are you well behaved?",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    control = CloudFirestoreControl();
  }
}
