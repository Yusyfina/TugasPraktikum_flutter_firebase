import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../inti/aturan/warna.dart';
import '../../data/autentikasi.dart';
import '../../../inventory/data/models/model_produk.dart';
import '../../../inventory/data/services/firestore_service.dart';
import 'form_produk.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = LayananAutentikasi();
  final _firestoreService = LayananFirestore();
  final _searchController = TextEditingController();

  String _searchQuery = '';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.penggunaSaatIni;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatRupiah(double value) {
    String valStr = value.toInt().toString();
    String result = '';
    int count = 0;
    for (int i = valStr.length - 1; i >= 0; i--) {
      result = valStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }

  void _confirmDelete(ModelProduk product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: WarnaAplikasi.error,
              size: 28,
            ),
            SizedBox(width: 8),
            Text('Hapus Produk'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus produk "${product.namaBarang}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _firestoreService.hapusProduk(product.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Produk "${product.namaBarang}" berhasil dihapus',
                      ),
                      backgroundColor: WarnaAplikasi.sukses,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus produk: ${e.toString()}'),
                      backgroundColor: WarnaAplikasi.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WarnaAplikasi.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: WarnaAplikasi.gradienBiru,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0x33FFFFFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.devices_other,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'YusyTech',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Toko Elektronik & Inventory',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Logout',
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await _authService.keluar();
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Logout berhasil.'),
                              backgroundColor: WarnaAplikasi.primer,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // User info row
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Operator: ${_currentUser!.email}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xE6FFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<List<ModelProduk>>(
                stream: _firestoreService.dapatkanAliranProduk(
                  _currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          style: const TextStyle(color: WarnaAplikasi.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final allProducts = snapshot.data ?? [];

                  final totalProducts = allProducts.length;
                  int totalStock = 0;
                  int outOfStock = 0;
                  int lowStock = 0;

                  for (var product in allProducts) {
                    totalStock += product.stok;
                    if (product.stok == 0) {
                      outOfStock++;
                    } else if (product.stok <= 5) {
                      lowStock++;
                    }
                  }

                  final filteredProducts = allProducts.where((p) {
                    final searchLower = _searchQuery.toLowerCase();
                    return p.namaBarang.toLowerCase().contains(searchLower) ||
                        p.merk.toLowerCase().contains(searchLower) ||
                        p.kategori.toLowerCase().contains(searchLower);
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 16.0,
                            bottom: 8.0,
                          ),
                          sliver: SliverGrid.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1.6,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: [
                              _buildStatCard(
                                title: 'Total Produk',
                                value: totalProducts.toString(),
                                icon: Icons.inventory_2_outlined,
                                color: WarnaAplikasi.primer,
                              ),
                              _buildStatCard(
                                title: 'Total Stok',
                                value: totalStock.toString(),
                                icon: Icons.dns_outlined,
                                color: WarnaAplikasi.primerMuda,
                              ),
                              _buildStatCard(
                                title: 'Produk Habis',
                                value: outOfStock.toString(),
                                icon: Icons.do_not_disturb_on_total_silence,
                                color: WarnaAplikasi.error,
                                highlight: outOfStock > 0,
                              ),
                              _buildStatCard(
                                title: 'Stok Menipis (≤5)',
                                value: lowStock.toString(),
                                icon: Icons.warning_amber_rounded,
                                color: WarnaAplikasi.peringatan,
                                highlight: lowStock > 0,
                              ),
                            ],
                          ),
                        ),

                        // Pencarian Produk
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Cari barang...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: WarnaAplikasi.primer,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: WarnaAplikasi.teksSekunder,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'Daftar Inventaris'
                                      : 'Hasil Pencarian (${filteredProducts.length})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: WarnaAplikasi.teksUtama,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Produk List
                        filteredProducts.isEmpty
                            ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: _buildEmptyState(allProducts.isEmpty),
                              )
                            : SliverPadding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 80.0,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    ctx,
                                    index,
                                  ) {
                                    final product = filteredProducts[index];
                                    return _buildProductCard(product);
                                  }, childCount: filteredProducts.length),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
        backgroundColor: WarnaAplikasi.primer,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool highlight = false,
  }) {
    return Card(
      elevation: highlight ? 6 : 2,
      shadowColor: highlight
          ? color.withValues(alpha: 0.3)
          : const Color(0x0A000000), // black with 0.04 opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: highlight
            ? BorderSide(color: color, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: highlight ? color : Colors.transparent,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: WarnaAplikasi.teksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: WarnaAplikasi.teksSekunder,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ModelProduk product) {
    Color stockBadgeColor;
    String stockText;

    if (product.stok == 0) {
      stockBadgeColor = WarnaAplikasi.error;
      stockText = 'Habis';
    } else if (product.stok <= 5) {
      stockBadgeColor = WarnaAplikasi.peringatan;
      stockText = 'Stok Menipis (${product.stok})';
    } else {
      stockBadgeColor = WarnaAplikasi.sukses;
      stockText = 'Stok: ${product.stok}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Edit produk saat kartu ditekan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x141565C0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.kategori,
                            style: const TextStyle(
                              fontSize: 11,
                              color: WarnaAplikasi.primer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Nama produk
                        Text(
                          product.namaBarang,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WarnaAplikasi.teksUtama,
                          ),
                        ),
                        // Brand
                        Text(
                          'Merk: ${product.merk}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: WarnaAplikasi.teksSekunder,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.blueAccent,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductFormScreen(product: product),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: WarnaAplikasi.error,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _confirmDelete(product),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price Tag
                  Text(
                    _formatRupiah(product.harga),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: WarnaAplikasi.primer,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: stockBadgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: stockBadgeColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      stockText,
                      style: TextStyle(
                        fontSize: 12,
                        color: stockBadgeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (product.deskripsi.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  product.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WarnaAplikasi.teksSekunder,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isCollectionEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0x0D1565C0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCollectionEmpty
                    ? Icons.inventory_2_outlined
                    : Icons.search_off_rounded,
                size: 64,
                color: const Color(0x661565C0),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isCollectionEmpty
                  ? 'Belum ada data barang'
                  : 'Produk tidak ditemukan',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaAplikasi.teksUtama,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCollectionEmpty
                  ? 'Gunakan tombol di bawah untuk menambah barang elektronik pertama Anda.'
                  : 'Coba periksa kembali ejaan kata kunci pencarian Anda.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: WarnaAplikasi.teksSekunder,
              ),
            ),
            if (isCollectionEmpty) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Barang'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
