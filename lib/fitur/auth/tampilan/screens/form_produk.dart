import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../inti/aturan/warna.dart';
import '../../../../inti/aturan/kategori.dart';
import '../../../inventory/data/models/model_produk.dart';
import '../../../inventory/data/services/firestore_service.dart';
import '../../data/autentikasi.dart';

class ProductFormScreen extends StatefulWidget {
  final ModelProduk? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = LayananFirestore();
  final _authService = LayananAutentikasi();

  final _namaController = TextEditingController();
  final _merkController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedKategori;
  bool _isLoading = false;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final product = widget.product!;
      _namaController.text = product.namaBarang;
      _merkController.text = product.merk;
      _hargaController.text = product.harga.toInt().toString();
      _stokController.text = product.stok.toString();
      _deskripsiController.text = product.deskripsi;
      _selectedKategori = product.kategori;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _merkController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = _authService.penggunaSaatIni;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi telah habis. Silakan masuk kembali.'),
          backgroundColor: WarnaAplikasi.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = ModelProduk(
        id: _isEditMode ? widget.product!.id : null,
        namaBarang: _namaController.text.trim(),
        kategori: _selectedKategori!,
        merk: _merkController.text.trim(),
        harga: double.parse(_hargaController.text.trim()),
        stok: int.parse(_stokController.text.trim()),
        deskripsi: _deskripsiController.text.trim(),
        tanggalDibuat: _isEditMode
            ? widget.product!.tanggalDibuat
            : DateTime.now(),
        idPengguna: currentUser.uid,
        emailPengguna: currentUser.email ?? 'no-email@yusytech.com',
      );

      if (_isEditMode) {
        await _firestoreService.perbaruiProduk(product);
      } else {
        await _firestoreService.tambahProduk(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Produk berhasil diperbarui!'
                  : 'Produk berhasil ditambahkan!',
            ),
            backgroundColor: WarnaAplikasi.sukses,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: WarnaAplikasi.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Produk Elektronik' : 'Tambah Produk Elektronik',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background Gradient accent at top
          Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x141565C0), // primary with 0.08 opacity
                  Color(0x0542A5F5), // primaryLight with 0.02 opacity
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Card
                    Card(
                      elevation: 2,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informasi Barang',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: WarnaAplikasi.teksUtama,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _namaController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Nama Barang',
                                prefixIcon: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: WarnaAplikasi.primer,
                                ),
                                hintText: 'Contoh: Laptop Apple MacBook Pro',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama barang tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              initialValue: _selectedKategori,
                              decoration: const InputDecoration(
                                labelText: 'Kategori',
                                prefixIcon: Icon(
                                  Icons.category_outlined,
                                  color: WarnaAplikasi.primer,
                                ),
                              ),
                              hint: const Text('Pilih Kategori'),
                              items: KategoriAplikasi.daftar.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedKategori = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pilih salah satu kategori';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _merkController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Merk / Brand',
                                prefixIcon: Icon(
                                  Icons.branding_watermark_outlined,
                                  color: WarnaAplikasi.primer,
                                ),
                                hintText: 'Contoh: Apple, Samsung',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Merk tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                // Harga
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _hargaController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Harga (Rp)',
                                      prefixIcon: Icon(
                                        Icons.attach_money,
                                        color: WarnaAplikasi.primer,
                                      ),
                                      hintText: '15000000',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Harga tidak boleh kosong';
                                      }
                                      final price = double.tryParse(value);
                                      if (price == null || price < 0) {
                                        return 'Format tidak valid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Stok
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _stokController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Stok',
                                      prefixIcon: Icon(
                                        Icons.format_list_numbered_outlined,
                                        color: WarnaAplikasi.primer,
                                      ),
                                      hintText: '10',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Stok wajib diisi';
                                      }
                                      final stock = int.tryParse(value);
                                      if (stock == null || stock < 0) {
                                        return 'Minimal 0';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Deskripsi
                            TextFormField(
                              controller: _deskripsiController,
                              maxLines: 4,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                labelText: 'Deskripsi Barang',
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: WarnaAplikasi.primer,
                                ),
                                hintText: 'Masukkan spesifikasi lengkap.',
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Deskripsi barang tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol Simpan
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _saveProduct,
                            icon: const Icon(Icons.save_rounded),
                            label: Text(
                              _isEditMode ? 'PERBARUI BARANG' : 'SIMPAN BARANG',
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
