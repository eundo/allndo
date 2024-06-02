import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

void main() async {
  await Firebase.initializeApp(
    name: 'all-n-do',
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

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

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCi3pWqwiTMGt_7C2vNAMtyRmAf-cOUWCc',
    appId: '1:729488646624:ios:593a2ba5655271d719cb85',
    messagingSenderId: '729488646624',
    projectId: 'all-n-do',
    storageBucket: 'all-n-do.appspot.com',
    iosBundleId: 'com.example.allndo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwBRZ9UchtzfwoHyCULEmjxkY7JuGAZl4',
    appId: '1:729488646624:web:5763d4e95d30072019cb85',
    messagingSenderId: '729488646624',
    projectId: 'all-n-do',
    authDomain: 'all-n-do.firebaseapp.com',
    storageBucket: 'all-n-do.appspot.com',
    measurementId: 'G-6VL1HY9K74',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi3pWqwiTMGt_7C2vNAMtyRmAf-cOUWCc',
    appId: '1:729488646624:ios:593a2ba5655271d719cb85',
    messagingSenderId: '729488646624',
    projectId: 'all-n-do',
    storageBucket: 'all-n-do.appspot.com',
    iosBundleId: 'com.example.allndo',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpQi7cX7tHhXJS9PkwFVfvCduWceETUB0',
    appId: '1:729488646624:android:29a18d128c1f169a19cb85',
    messagingSenderId: '729488646624',
    projectId: 'all-n-do',
    storageBucket: 'all-n-do.appspot.com',
  );

}