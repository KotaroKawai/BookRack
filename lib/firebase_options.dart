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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCnAKLfzlvnUa6zJJxITMGwzROFIIsIYgY',
    appId: '1:407594844473:web:41c033a1903a826a68e8e8',
    messagingSenderId: '407594844473',
    projectId: 'bookshelf-f4247',
    authDomain: 'bookshelf-f4247.firebaseapp.com',
    storageBucket: 'bookshelf-f4247.appspot.com',
    measurementId: 'G-NRCCKL9THQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKdTeoV69QThvheCjNGNA94DuNvO6UISQ',
    appId: '1:407594844473:android:accf3bd37ce81f1268e8e8',
    messagingSenderId: '407594844473',
    projectId: 'bookshelf-f4247',
    storageBucket: 'bookshelf-f4247.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyN7Wagw-1-pKDIyuk5mFHiFz1JCkI4dE',
    appId: '1:407594844473:ios:6adc6ae5de25974668e8e8',
    messagingSenderId: '407594844473',
    projectId: 'bookshelf-f4247',
    storageBucket: 'bookshelf-f4247.appspot.com',
    iosClientId: '407594844473-75v285rlq9hnv8p51292399fsfmgfcq8.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyN7Wagw-1-pKDIyuk5mFHiFz1JCkI4dE',
    appId: '1:407594844473:ios:f2afa96e6882fb9068e8e8',
    messagingSenderId: '407594844473',
    projectId: 'bookshelf-f4247',
    storageBucket: 'bookshelf-f4247.appspot.com',
    iosClientId: '407594844473-3ap7jcsgabhr85rs98bcmdcca2f5ik1n.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookrack.RunnerTests',
  );
}
