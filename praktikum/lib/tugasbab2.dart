enum JenisHewan { mamalia, burung, reptil }

abstract class Hewan {
  final String nama;
  final int umur;

  // Constructor dengan Positional Arguments
  Hewan(this.nama, this.umur);

  void buatSuara();

  String get deskripsi => "Ini adalah $nama dan umurnya $umur tahun.";
}

class Anjing extends Hewan {
  String ras;

  // Constructor dengan Named Arguments
  Anjing(super.nama, super.umur, {required this.ras});

  @override
  void buatSuara() {
    print("Guk! Guk!");
  }
}

class Kucing extends Hewan {
  bool dalamRuangan;

  // Constructor dengan Positional dan Named Argument
  Kucing(super.nama, super.umur, {this.dalamRuangan = true});

  @override
  void buatSuara() {
    print("Meong! Meong!");
  }
}

mixin KemampuanTerbang {
  void terbang() {
    print("Saya sedang terbang!");
  }
}

class Burung extends Hewan with KemampuanTerbang {
  Burung(super.nama, super.umur);

  @override
  void buatSuara() {
    print("Cuit! Cuit!");
  }
}

void main() {
  Anjing anjingSaya = Anjing('Buddy', 4, ras: 'Golden Retriever');
  print(anjingSaya.deskripsi);
  anjingSaya.buatSuara();

  print("Ras: ${anjingSaya.ras}");
  anjingSaya.ras = 'Labrador';
  print("Ras Terbaru: ${anjingSaya.ras}");

  Kucing kucingSaya = Kucing('Whiskers', 2, dalamRuangan: true);
  print(kucingSaya.deskripsi);
  kucingSaya.buatSuara();

  Burung burungSaya = Burung('Polly', 1);
  print(burungSaya.deskripsi);
  burungSaya.buatSuara();
  burungSaya.terbang();

  JenisHewan jenisHewan = JenisHewan.burung;
  print("Jenis hewan ini adalah: ${jenisHewan.toString().split('.').last}");
}
