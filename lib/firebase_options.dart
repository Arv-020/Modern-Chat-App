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
    apiKey: 'AIzaSyB8BO_SRX1tG64VsXR13kWT0_Cex-ljOY8',
    appId: '1:896337234287:android:8bbb481a7a7114c2b8009a',
    messagingSenderId: '896337234287',
    projectId: 'modern-chat-app-cc6e7',
    storageBucket: 'modern-chat-app-cc6e7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDL4sgxWqb3_bDao4bROvFNJ0ifEJrVgU',
    appId: '1:896337234287:ios:01aa51b573ec1960b8009a',
    messagingSenderId: '896337234287',
    projectId: 'modern-chat-app-cc6e7',
    storageBucket: 'modern-chat-app-cc6e7.appspot.com',
    androidClientId: '896337234287-l5th5looaadg3degc14taq8qu86hfjob.apps.googleusercontent.com',
    iosClientId: '896337234287-lqca3cjsijlbj5gkquv0ron7th99na10.apps.googleusercontent.com',
    iosBundleId: 'com.example.modernChatApp',
  );
}
