import 'dart:io';

// ignore: constant_identifier_names
enum Role { Admin, Customer }

class ProductOutOfStockException implements Exception {
  final String message;
  ProductOutOfStockException(this.message);

  @override
  String toString() {
    return 'Informasi: $message';
  }
}

class Product {
  String productName;
  double price;
  bool inStock;
  Product({required this.productName, required this.price, required this.inStock});

  @override
  String toString() {
    return 'Produk: $productName, Harga: \$${price.toStringAsFixed(2)}, Tersedia: ${inStock ? 'Ya' : 'Tidak'}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.productName == productName &&
        other.price == price;
  }

  @override
  int get hashCode => productName.hashCode ^ price.hashCode;
}

class User {
  String name;
  int age;
  late Map<String, Product> products;
  late Role role;

  User(
      {required this.name,
      required this.age,
      Map<String, Product>? products,
      Role? role}) {
    this.products = products ?? {};
    this.role = role ?? Role.Customer;
  }

  void showProducts() {
    print('$name memiliki role ${role == Role.Admin ? "Admin" : "Customer"}');
    if (products.isEmpty) {
      print('$name belum memiliki produk di dalam daftar.');
    } else {
      print('Daftar Produk $name:');
      for (var product in products.values) {
        print(product);
      }
    }
  }
}

class AdminUser extends User {
  AdminUser({required super.name, required super.age, super.products})
      : super(role: Role.Admin);

  void addProduct(Product product) {
    try {
      if (!product.inStock) {
        throw ProductOutOfStockException(
            'Produk ${product.productName} tidak tersedia di stok.');
      }
      products[product.productName] = product;
      print(
          'Admin $name berhasil menambahkan produk: ${product.productName} ke daftar.');
    } on ProductOutOfStockException catch (e) {
      print(e);
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void removeProduct(Product product) {
    if (products.containsKey(product.productName)) {
      products.remove(product.productName);
      print(
          'Admin $name berhasil menghapus produk: ${product.productName} dari daftar.');
    } else {
      print('Produk ${product.productName} tidak ditemukan di daftar.');
    }
  }
}

class CustomerUser extends User {
  CustomerUser({required super.name, required super.age, super.products})
      : super(role: Role.Customer);

  void showAvailableProducts() {
    if (products.isEmpty) {
      print('$name belum memiliki produk di dalam daftar.');
    } else {
      print('Produk yang Tersedia:');
      for (var product in products.values) {
        if (product.inStock) {
          print(product);
        }
      }
    }
  }
}

Future<Role> chooseRole() async {
  print('Pilih role:');
  print('1. Admin');
  print('2. Customer');
  stdout.write('Masukkan pilihan (1 atau 2): ');

  String? choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      return Role.Admin;
    case '2':
      return Role.Customer;
    default:
      print('Pilihan tidak valid. Default ke Customer.');
      return Role.Customer;
  }
}

Product createProduct() {
  stdout.write('Masukkan nama produk: ');
  String? productName = stdin.readLineSync();

  stdout.write('Masukkan harga produk: ');
  double price = double.parse(stdin.readLineSync() ?? '0.0');

  stdout.write('Apakah produk tersedia di stok? (y/n): ');
  String? inStockInput = stdin.readLineSync();
  bool inStock = (inStockInput?.toLowerCase() == 'y');

  return Product(
      productName: productName ?? 'Nama Produk',
      price: price,
      inStock: inStock);
}

void main() async {
  try {
    stdout.write('Masukkan nama Anda: ');
    String? name = stdin.readLineSync();
    stdout.write('Masukkan usia Anda: ');
    String? ageInput = stdin.readLineSync();

    if (name == null || ageInput == null) {
      print('Input tidak valid.');
      return;
    }

    int age = int.tryParse(ageInput) ?? 0;

    Map<String, Product> initialProducts = {
      'Produk A': Product(productName: 'HP', price: 13400000.0, inStock: true),
      'Produk B':
          Product(productName: 'Tablet', price: 15200000.0, inStock: false),
      'Produk C':
          Product(productName: 'Leptop', price: 14600000.0, inStock: true),
    };

    Role role = await chooseRole();

    User user;
    if (role == Role.Admin) {
      user = AdminUser(name: name, age: age, products: initialProducts);
    } else {
      user = CustomerUser(name: name, age: age, products: initialProducts);
    }

    if (user is AdminUser) {
      bool addingProducts = true;
      while (addingProducts) {
        print('\n--- Menambah atau Menghapus Produk ---');
        print('1. Tambah produk');
        print('2. Hapus produk');
        print('3. Lihat produk');
        print('4. EXIT');
        stdout.write('Pilih aksi (1/2/3/4): ');
        String? action = stdin.readLineSync();

        if (action == '1') {
          Product newProduct = createProduct();
          user.addProduct(newProduct);
        } else if (action == '2') {
          stdout.write('Masukkan nama produk yang ingin dihapus: ');
          String? productName = stdin.readLineSync();
          if (productName != null && user.products.containsKey(productName)) {
            Product product = user.products[productName]!;
            user.removeProduct(product);
          } else {
            print('Produk tidak ditemukan.');
          }
        } else if (action == '3') {
          user.showProducts();
        } else if (action == '4') {
          print('Anda telah keluar.');
          break;
        } else {
          print('Pilihan tidak valid.');
        }
      }
    }

    if (user is CustomerUser) {
      bool viewingProducts = true;
      while (viewingProducts) {
        print('\n--- Lihat Produk ---');
        print('1. Lihat produk yang tersedia');
        print('2. EXIT');
        stdout.write('Pilih aksi (1/2): ');
        String? action = stdin.readLineSync();

        if (action == '1') {
          user.showAvailableProducts();
        } else if (action == '2') {
          print('Anda telah keluar.');
          break;
        }
      }
    }
    // ignore: empty_catches
  } catch (e) {}
}
