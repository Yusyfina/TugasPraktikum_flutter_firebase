import 'package:cloud_firestore/cloud_firestore.dart';

class ModelProduk {
  final String? id;
  final String namaBarang;
  final String kategori;
  final String merk;
  final double harga;
  final int stok;
  final String deskripsi;
  final DateTime tanggalDibuat;
  final String idPengguna;
  final String emailPengguna;

  ModelProduk({
    this.id,
    required this.namaBarang,
    required this.kategori,
    required this.merk,
    required this.harga,
    required this.stok,
    required this.deskripsi,
    required this.tanggalDibuat,
    required this.idPengguna,
    required this.emailPengguna,
  });

  ModelProduk copyWith({
    String? id,
    String? namaBarang,
    String? kategori,
    String? merk,
    double? harga,
    int? stok,
    String? deskripsi,
    DateTime? tanggalDibuat,
    String? idPengguna,
    String? emailPengguna,
  }) {
    return ModelProduk(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      kategori: kategori ?? this.kategori,
      merk: merk ?? this.merk,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
      deskripsi: deskripsi ?? this.deskripsi,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      idPengguna: idPengguna ?? this.idPengguna,
      emailPengguna: emailPengguna ?? this.emailPengguna,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaBarang': namaBarang,
      'kategori': kategori,
      'merk': merk,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
      'createdAt': Timestamp.fromDate(tanggalDibuat),
      'userId': idPengguna,
      'userEmail': emailPengguna,
    };
  }

  factory ModelProduk.fromMap(Map<String, dynamic> map, String documentId) {
    return ModelProduk(
      id: documentId,
      namaBarang: map['namaBarang'] ?? '',
      kategori: map['kategori'] ?? '',
      merk: map['merk'] ?? '',
      harga: (map['harga'] as num?)?.toDouble() ?? 0.0,
      stok: (map['stok'] as num?)?.toInt() ?? 0,
      deskripsi: map['deskripsi'] ?? '',
      tanggalDibuat:
          (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      idPengguna: map['userId'] ?? '',
      emailPengguna: map['userEmail'] ?? '',
    );
  }
}
