import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
        return web;
      case TargetPlatform.windows:
        return web;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC7jDEGIrkc5YFvGV-ootOxn85Ndgwyi4E',
    authDomain: 'gobeyond-54d44.firebaseapp.com',
    projectId: 'gobeyond-54d44',
    storageBucket: 'gobeyond-54d44.firebasestorage.app',
    messagingSenderId: '776239598660',
    appId: '1:776239598660:web:522cadd48016dc47efc011',
    measurementId: 'G-3HEHBRWJ7C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7jDEGIrkc5YFvGV-ootOxn85Ndgwyi4E',
    appId: '1:776239598660:android:da815f9370d4dd10efc011',
    messagingSenderId: '776239598660',
    projectId: 'gobeyond-54d44',
    storageBucket: 'gobeyond-54d44.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7jDEGIrkc5YFvGV-ootOxn85Ndgwyi4E',
    appId: '1:776239598660:ios:341f49430b4f7fe3efc011',
    messagingSenderId: '776239598660',
    projectId: 'gobeyond-54d44',
    storageBucket: 'gobeyond-54d44.firebasestorage.app',
    iosBundleId: 'com.example.goBeyond',
  );
}
