// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCf47Oz8uoo3wFXQnktmr54NQmK26MZPg8',
    appId: '1:696596299791:android:876100b7d958324d31237a',
    messagingSenderId: '696596299791',
    projectId: 'pointer-teachers',
    storageBucket: 'pointer-teachers.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeoJHiLq72Skje2GEIWtv1bkP7GO4SYLc',
    appId: '1:696596299791:ios:dfeb4200bc16b01631237a',
    messagingSenderId: '696596299791',
    projectId: 'pointer-teachers',
    storageBucket: 'pointer-teachers.appspot.com',
    androidClientId: '696596299791-2ldh6i85dhsc7urb6jtgivl0elubej5o.apps.googleusercontent.com',
    iosClientId: '696596299791-jbfkj6u1htchameoq5qe5a4bk9be19qm.apps.googleusercontent.com',
    iosBundleId: 'com.aadi.flutter.pointerTeachersV2',
  );
}
