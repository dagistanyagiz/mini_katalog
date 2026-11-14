import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Ürün verilerini assets/products.json dosyasından okur.
/// (API simülasyonu: gerçek bir sunucu yerine yerel JSON dosyası kullanılıyor.)
class ProductRepository {
  static Future<List<Product>> loadProducts() async {
    // 1) JSON dosyasını metin olarak oku
    final String rawJson = await rootBundle.loadString('assets/products.json');

    // 2) Metni Map'e çevir
    final Map<String, dynamic> data = jsonDecode(rawJson);

    // 3) "products" listesindeki her elemanı Product nesnesine çevir
    final List<dynamic> productList = data['products'];
    return productList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
