import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model_produk.dart';

class LayananFirestore {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _jalurKoleksi = 'electronics_products';

  Stream<List<ModelProduk>> dapatkanAliranProduk(String idPengguna) {
    return _db
        .collection(_jalurKoleksi)
        .where('userId', isEqualTo: idPengguna)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ModelProduk.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> tambahProduk(ModelProduk produk) async {
    await _db.collection(_jalurKoleksi).add(produk.toMap());
  }

  Future<void> perbaruiProduk(ModelProduk produk) async {
    if (produk.id == null) return;
    await _db.collection(_jalurKoleksi).doc(produk.id).update(produk.toMap());
  }

  Future<void> hapusProduk(String idProduk) async {
    await _db.collection(_jalurKoleksi).doc(idProduk).delete();
  }
}
