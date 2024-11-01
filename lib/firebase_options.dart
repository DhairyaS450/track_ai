// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCrkxDMQZR9B0urCV_yQLnorWYnmWvW-p4',
    appId: '1:519011897064:web:1533e6585b1072d745435d',
    messagingSenderId: '519011897064',
    projectId: 'track-ai-app',
    authDomain: 'track-ai-app.firebaseapp.com',
    storageBucket: 'track-ai-app.appspot.com',
    measurementId: 'G-ET5VGXHHLK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDYtHGFl8dolDW0sVhCFsQc-WJF6qRnKo',
    appId: '1:519011897064:android:b285bd915017b31645435d',
    messagingSenderId: '519011897064',
    projectId: 'track-ai-app',
    storageBucket: 'track-ai-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsgU8BfkR2rBdQL-RQnpzgMQednG2FToM',
    appId: '1:519011897064:ios:82a48c7d5efab4aa45435d',
    messagingSenderId: '519011897064',
    projectId: 'track-ai-app',
    storageBucket: 'track-ai-app.appspot.com',
    androidClientId: '519011897064-a8m9p3ursm3qlp4105uvvrt7np07jp11.apps.googleusercontent.com',
    iosClientId: '519011897064-45sujj05uklbckpf75ibsvg91745op7q.apps.googleusercontent.com',
    iosBundleId: 'com.app.trackAI',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsgU8BfkR2rBdQL-RQnpzgMQednG2FToM',
    appId: '1:519011897064:ios:f0db5ba4468f997245435d',
    messagingSenderId: '519011897064',
    projectId: 'track-ai-app',
    storageBucket: 'track-ai-app.appspot.com',
    androidClientId: '519011897064-a8m9p3ursm3qlp4105uvvrt7np07jp11.apps.googleusercontent.com',
    iosClientId: '519011897064-jku9tb3phikv3g0dsv2ltli5pv1944vv.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCrkxDMQZR9B0urCV_yQLnorWYnmWvW-p4',
    appId: '1:519011897064:web:65272705904d115f45435d',
    messagingSenderId: '519011897064',
    projectId: 'track-ai-app',
    authDomain: 'track-ai-app.firebaseapp.com',
    storageBucket: 'track-ai-app.appspot.com',
    measurementId: 'G-XGX4TT49LY',
  );

}