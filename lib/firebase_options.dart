import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBMGa_YY9C22SDKh_w4r5SuiDgAlDSyQ7k',
    appId: '1:11274454237:web:7203cf633d544efeff8734',
    messagingSenderId: '11274454237',
    projectId: 'flutterfirebasedemo-f911e',
    authDomain: 'flutterfirebasedemo-f911e.firebaseapp.com',
    storageBucket: 'flutterfirebasedemo-f911e.firebasestorage.app',
    measurementId: 'G-L9W4DEN393',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOmm4dP0k_0cKEG77okUwiIuK1tj4hiog',
    appId: '1:11274454237:android:07da4e48a8c5e9cfff8734',
    messagingSenderId: '11274454237',
    projectId: 'flutterfirebasedemo-f911e',
    storageBucket: 'flutterfirebasedemo-f911e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1afVEoDrbh6XAHwosxC5neXZcIi1FasI',
    appId: '1:11274454237:ios:dded341ce0a99d0fff8734',
    messagingSenderId: '11274454237',
    projectId: 'flutterfirebasedemo-f911e',
    storageBucket: 'flutterfirebasedemo-f911e.firebasestorage.app',
    iosBundleId: 'com.example.flutterfirebasedemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1afVEoDrbh6XAHwosxC5neXZcIi1FasI',
    appId: '1:11274454237:ios:dded341ce0a99d0fff8734',
    messagingSenderId: '11274454237',
    projectId: 'flutterfirebasedemo-f911e',
    storageBucket: 'flutterfirebasedemo-f911e.firebasestorage.app',
    iosBundleId: 'com.example.flutterfirebasedemo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBMGa_YY9C22SDKh_w4r5SuiDgAlDSyQ7k',
    appId: '1:11274454237:web:5958a1d5f4bf1efdff8734',
    messagingSenderId: '11274454237',
    projectId: 'flutterfirebasedemo-f911e',
    authDomain: 'flutterfirebasedemo-f911e.firebaseapp.com',
    storageBucket: 'flutterfirebasedemo-f911e.firebasestorage.app',
    measurementId: 'G-D1RGXVVBF5',
  );
}
