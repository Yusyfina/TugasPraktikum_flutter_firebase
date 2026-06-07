import 'package:firebase_auth/firebase_auth.dart';

class LayananAutentikasi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get penggunaSaatIni => _auth.currentUser;

  Stream<User?> get aliranStatusAutentikasi => _auth.authStateChanges();

  Future<UserCredential> masuk(String email, String sandi) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: sandi.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> daftar(String email, String sandi) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: sandi.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }
}
