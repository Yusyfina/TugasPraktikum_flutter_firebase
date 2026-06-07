import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../inti/aturan/warna.dart';
import '../../data/autentikasi.dart';

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _sandiController = TextEditingController();
  final _konfirmasiSandiController = TextEditingController();
  final _layananAutentikasi = LayananAutentikasi();

  bool _sembunyikanSandi = true;
  bool _sembunyikanKonfirmasiSandi = true;
  bool _sedangMemuat = false;

  void _prosesDaftar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangMemuat = true;
    });

    try {
      await _layananAutentikasi.daftar(
        _emailController.text,
        _sandiController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan masuk.'),
            backgroundColor: WarnaAplikasi.sukses,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String pesanError = 'Terjadi kesalahan registrasi.';
      if (e.code == 'email-already-in-use') {
        pesanError = 'Email sudah digunakan oleh akun lain.';
      } else if (e.code == 'invalid-email') {
        pesanError = 'Format email tidak valid.';
      } else if (e.code == 'weak-password') {
        pesanError = 'Password terlalu lemah.';
      }
      _tampilkanSnackBarError(pesanError);
    } catch (e) {
      _tampilkanSnackBarError('Kesalahan: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _sedangMemuat = false;
        });
      }
    }
  }

  void _tampilkanSnackBarError(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(pesan)),
          ],
        ),
        backgroundColor: WarnaAplikasi.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _sandiController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: WarnaAplikasi.gradienBiru,
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo / Header
                  const Text(
                    'Daftar Akun',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Text(
                    'Buat akun YusyTech Anda sekarang',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),

                  Card(
                    elevation: 12,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'nama@example.com',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: WarnaAplikasi.primer,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value.trim())) {
                                  return 'Masukkan format email yang benar';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _sandiController,
                              obscureText: _sembunyikanSandi,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: WarnaAplikasi.primer,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _sembunyikanSandi
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _sembunyikanSandi = !_sembunyikanSandi;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Konfirmasi Sandi
                            TextFormField(
                              controller: _konfirmasiSandiController,
                              obscureText: _sembunyikanKonfirmasiSandi,
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi Password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: WarnaAplikasi.primer,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _sembunyikanKonfirmasiSandi
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _sembunyikanKonfirmasiSandi =
                                          !_sembunyikanKonfirmasiSandi;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Konfirmasi password tidak boleh kosong';
                                }
                                if (value != _sandiController.text) {
                                  return 'Password tidak cocok';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit
                            _sedangMemuat
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: _prosesDaftar,
                                    child: const Text('DAFTAR'),
                                  ),
                            const SizedBox(height: 16),

                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sudah memiliki akun? ',
                                  style: TextStyle(
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Masuk'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
