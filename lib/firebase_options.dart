// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
    apiKey: 'AIzaSyB5hh7FFtlNFYMN8w0sbqyrpItMc-lxb7g',
    appId: '1:393702546014:web:efb58f6d8029d9e1a172cf',
    messagingSenderId: '393702546014',
    projectId: 'bobo-app-9e643',
    authDomain: 'bobo-app-9e643.firebaseapp.com',
    storageBucket: 'bobo-app-9e643.appspot.com',
    measurementId: 'G-GZJEWKW440',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZmF45LXol9g5efIyeIZq23TDy4Tr5ILs',
    appId: '1:393702546014:android:71b007b102f2eefea172cf',
    messagingSenderId: '393702546014',
    projectId: 'bobo-app-9e643',
    storageBucket: 'bobo-app-9e643.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1Pk9OsSAaKNRcdQdWWQ7p4NRRkze1MRQ',
    appId: '1:393702546014:ios:5588f3d25a829fa0a172cf',
    messagingSenderId: '393702546014',
    projectId: 'bobo-app-9e643',
    storageBucket: 'bobo-app-9e643.appspot.com',
    iosBundleId: 'com.bubuApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1Pk9OsSAaKNRcdQdWWQ7p4NRRkze1MRQ',
    appId: '1:393702546014:ios:8648eb89434feffca172cf',
    messagingSenderId: '393702546014',
    projectId: 'bobo-app-9e643',
    storageBucket: 'bobo-app-9e643.appspot.com',
    iosBundleId: 'com.example.bubuApp',
  );
}