class ListKeahlian {
  static List<String> keahlianList = [
    'Programmer',
    'Barista',
    'Guru Les Privat',
    'Desainer Grafis',
    'Waiter',
    'Lainnya',
  ];
  List<Map<String, String>> keahlian;

  getList() {
    keahlian = [
      {
        "display": "Programmer",
        "value": "Programmer",
      },
      {
        "display": "Barista",
        "value": "Barista",
      },
      {
        "display": "Penulis Lepas",
        "value": "Penulis Lepas",
      },
      {
        "display": "Guru Les Privat",
        "value": "Guru Les Privat",
      },
      {
        "display": "Desainer Grafis",
        "value": "Desainer Grafis",
      },
      {
        "display": "Waiter",
        "value": "Waiter",
      },
      {
        "display": "Lainnya",
        "value": "Lainnya",
      },
    ];
    return keahlian;
  }
}

class ListGender {
  List<Map<String, String>> gender;
  getList() {
    gender = [
      {
        "display": "Laki-Laki",
        "value": "Laki-Laki",
      },
      {
        "display": "Perempuan",
        "value": "Perempuan",
      },
    ];
    return gender;
  }
}

class ListGenderPekerjaan {
  static List<Map<String, String>> gender;
  getList() {
    gender = [
      {
        "display": "Laki-Laki",
        "value": "Laki-Laki",
      },
      {
        "display": "Perempuan",
        "value": "Perempuan",
      },
      {
        "display": "Semua gender",
        "value": "Semua gender",
      },
    ];
    return gender;
  }
}

class ListPendidikan {
  List<Map<String, String>> pendidikan;
  getList() {
    pendidikan = [
      {
        "display": "SMA / Sederajat",
        "value": "SMA / Sederajat",
      },
      {
        "display": "D3",
        "value": "D3",
      },
      {
        "display": "S1",
        "value": "S1",
      },
      {
        "display": "Lainnya",
        "value": "Lainnya",
      },
    ];
    return pendidikan;
  }
}

class ListJamKerja {
  List<Map<String, String>> jamKerja;
  getList() {
    jamKerja = [
      {
        "display": "08:00 - 12:00",
        "value": "08:00 - 12:00",
      },
      {
        "display": "12:00 - 18:00",
        "value": "12:00 - 18:00",
      },
      {
        "display": "18:00 - 00:00",
        "value": "18:00 - 00:00",
      },
      {
        "display": "00:00 - 08:00",
        "value": "00:00 - 08:00",
      }
    ];
    return jamKerja;
  }
}

class ListKota {
  List<Map<String, String>> kota;
  getList() {
    kota = [
      {
        "display": "Bandung",
        "value": "Bandung",
      },
      {
        "display": "Jakarta",
        "value": "Jakarta",
      },
      {
        "display": "Karawang",
        "value": "Karawang",
      }
    ];
    return kota;
  }
}

class ListKategoriPerusahaan {
  List<Map<String, String>> kategoriPerusahaan;
  getList() {
    kategoriPerusahaan = [
      {
        "display": "Teknologi Informasi",
        "value": "Teknologi Informasi",
      },
      {
        "display": "Layanan Jasa",
        "value": "Layanan Jasa",
      },
      {
        "display": "Otomotif",
        "value": "Otomotif",
      },
      {
        "display": "Makanan",
        "value": "Makanan",
      },
      {
        "display": "Lainnya",
        "value": "Lainnya",
      }
    ];
    return kategoriPerusahaan;
  }
}
