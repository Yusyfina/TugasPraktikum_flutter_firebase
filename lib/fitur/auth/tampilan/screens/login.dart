import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../inti/aturan/warna.dart';
import '../../data/autentikasi.dart';
import 'daftar_akun.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _sandiController = TextEditingController();
  final _layananAutentikasi = LayananAutentikasi();

  bool _sembunyikanSandi = true;
  bool _sedangMemuat = false;

  void _prosesMasuk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangMemuat = true;
    });

    try {
      await _layananAutentikasi.masuk(
        _emailController.text,
        _sandiController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil! Selamat datang di YusyTech.'),
            backgroundColor: WarnaAplikasi.sukses,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String pesanError = 'Terjadi kesalahan autentikasi.';
      if (e.code == 'user-not-found') {
        pesanError = 'Email tidak terdaftar.';
      } else if (e.code == 'wrong-password') {
        pesanError = 'Password salah.';
      } else if (e.code == 'invalid-email') {
        pesanError = 'Format email tidak valid.';
      } else if (e.code == 'user-disabled') {
        pesanError = 'Akun ini telah dinonaktifkan.';
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
                  // Yusytech Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0x4DFFFFFF),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.devices_other,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'YusyTech',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Inventory Elektronik',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 36),

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
                            const Text(
                              'Masuk Akun',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: WarnaAplikasi.teksUtama,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

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
                            const SizedBox(height: 24),

                            // Login
                            _sedangMemuat
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: _prosesMasuk,
                                    child: const Text('LOGIN'),
                                  ),
                            const SizedBox(height: 16),

                            // Tombol daftar akun baru
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(
                                    color: WarnaAplikasi.teksSekunder,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HalamanDaftar(),
                                      ),
                                    );
                                  },
                                  child: const Text('Daftar Sekarang'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
