import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'inti/tema/tema_aplikasi.dart';
import 'fitur/auth/tampilan/screens/login.dart';
import 'fitur/auth/tampilan/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YusyTech',
      theme: TemaAplikasi.temaTerang,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (userSnapshot.hasData && userSnapshot.data != null) {
            return const DashboardScreen(); // Pengguna sudah login, arahkan ke Dashboard
          }
          return const HalamanLogin(); // Pengguna belum login, arahkan ke Login
        },
      ),
    );
  }
}
