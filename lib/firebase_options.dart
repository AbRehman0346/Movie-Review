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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCBu4MhVZULDdu1UOkGjimzJmQqG4hi628',
    appId: '1:1023341613288:web:568716e26085017973b95d',
    messagingSenderId: '1023341613288',
    projectId: 'movie-review-b12e1',
    authDomain: 'movie-review-b12e1.firebaseapp.com',
    storageBucket: 'movie-review-b12e1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXrgmUtNbZSa-gdjlhCUpjlE2UIs5ZQG0',
    appId: '1:1023341613288:android:c28e642b4453c8cd73b95d',
    messagingSenderId: '1023341613288',
    projectId: 'movie-review-b12e1',
    storageBucket: 'movie-review-b12e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-X6Vuin0DI8RSe4pDj4UWyAGxiM98DcE',
    appId: '1:1023341613288:ios:24fa73d2e1445a6f73b95d',
    messagingSenderId: '1023341613288',
    projectId: 'movie-review-b12e1',
    storageBucket: 'movie-review-b12e1.appspot.com',
    iosClientId: '1023341613288-pgargdp2ubbg70jtohkj1m73ear93jlb.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieReview',
  );
}
