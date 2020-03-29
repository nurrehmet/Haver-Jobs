import 'package:flutter/material.dart';

class KategoriPerusahaan {
  int id;
  String name;

  KategoriPerusahaan(this.id, this.name);
  static List<KategoriPerusahaan> getKategoriPerusahaan(){
    return <KategoriPerusahaan>[
      KategoriPerusahaan(0,'Teknologi Informasi'),
      KategoriPerusahaan(1,'Layanan Jasa'),
      KategoriPerusahaan(2,'Otomotif'),
      KategoriPerusahaan(3,'Pendidikan'),
      KategoriPerusahaan(4,'Hiburan'),
      KategoriPerusahaan(5,'Makanan'),
      KategoriPerusahaan(0,'Lainnya')
    ];
  }
}