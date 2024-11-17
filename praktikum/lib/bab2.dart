class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;

  ProdukDigital(this.namaProduk, this.harga, this.kategori);

  void terapkanDiskon(int jumlahTerjual) {
    if (kategori == "NetworkAutomation" && jumlahTerjual > 50) {
      double diskon = 0.15;
      double hargaDiskon = harga * (1 - diskon);
      harga = hargaDiskon < 200000 ? 200000 : hargaDiskon;
    }
  }
}

abstract class Karyawan {
  String nama;
  int umur;
  String peran;
  Karyawan(this.nama, {required this.umur, required this.peran});

  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(super.nama, {required super.umur, required super.peran});

  @override
  void bekerja() {
    print("$nama bekerja selama hari kerja reguler.");
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(super.nama, {required super.umur, required super.peran});

  @override
  void bekerja() {
    print("$nama bekerja pada proyek dengan periode spesifik.");
  }
}

mixin Kinerja {
  int produktivitas = 0;
  DateTime lastUpdate = DateTime.now();

  void updateProduktivitas(int nilai) {
    DateTime sekarang = DateTime.now();
    if (sekarang.difference(lastUpdate).inDays >= 30) {
      produktivitas = (nilai < 0) ? 0 : (nilai > 100 ? 100 : nilai);
      lastUpdate = sekarang;
    } else {
      print("Produktivitas hanya bisa diperbarui setiap 30 hari.");
    }
  }
}

class Manager extends KaryawanTetap with Kinerja {
  Manager(super.nama, int umur) : super(umur: umur, peran: "Manager") {
    produktivitas = produktivitas < 85 ? 85 : produktivitas;
  }
}

enum FaseProyek { perencanaan, pengembangan, evaluasi }

class Proyek {
  FaseProyek fase = FaseProyek.perencanaan;
  DateTime tanggalMulai = DateTime.now();
  int jumlahKaryawan = 0;

  void tambahKaryawan() {
    jumlahKaryawan++;
  }

  void gantiFase() {
    if (fase == FaseProyek.perencanaan && jumlahKaryawan >= 5) {
      fase = FaseProyek.pengembangan;
    } else if (fase == FaseProyek.pengembangan &&
        DateTime.now().difference(tanggalMulai).inDays > 45) {
      fase = FaseProyek.evaluasi;
    }
  }
}

class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  final int batasKaryawanAktif = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < batasKaryawanAktif) {
      karyawanAktif.add(karyawan);
    } else {
      print("Batas karyawan aktif telah tercapai.");
    }
  }

  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print("${karyawan.nama} telah resign dan menjadi karyawan non-aktif.");
    }
  }
}

void main() {
  // Membuat beberapa produk digital
  var produk1 = ProdukDigital("Software A", 300000, "NetworkAutomation");
  var produk2 = ProdukDigital("Software B", 250000, "NetworkAutomation");

  // Menerapkan diskon pada produk jika memenuhi syarat
  produk1.terapkanDiskon(60);
  print("Harga produk1 setelah diskon: ${produk1.harga}");

  produk2.terapkanDiskon(60);
  print("Harga produk2 setelah diskon: ${produk2.harga}");

  // Membuat beberapa karyawan
  var karyawan1 = KaryawanTetap("Alice", umur: 30, peran: "Developer");
  var karyawan2 = KaryawanKontrak("Bob", umur: 25, peran: "Designer");
  var manager = Manager("Charlie", 40);

  // Menambahkan karyawan ke perusahaan
  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);
  perusahaan.tambahKaryawan(manager);

  // Menampilkan jumlah karyawan aktif
  print("Jumlah karyawan aktif: ${perusahaan.karyawanAktif.length}");

  // Manager melakukan update produktivitas
  manager.updateProduktivitas(90);
  print("Produktivitas manager setelah update: ${manager.produktivitas}");

  // Membuat proyek baru
  var proyek = Proyek();
  print("Fase proyek saat ini: ${proyek.fase}");

  // Menambah karyawan ke proyek
  for (int i = 0; i < 5; i++) {
    proyek.tambahKaryawan();
  }
  proyek.gantiFase();
  print("Fase proyek setelah menambah karyawan: ${proyek.fase}");

  // Mengubah fase proyek setelah 45 hari (misalnya)
  proyek.tanggalMulai = proyek.tanggalMulai.subtract(Duration(days: 46));
  proyek.gantiFase();
  print("Fase proyek setelah 45 hari: ${proyek.fase}");

  // Karyawan resign
  perusahaan.resignKaryawan(karyawan2);
  print("Jumlah karyawan non-aktif: ${perusahaan.karyawanNonAktif.length}");
}
