/// Ürün model sınıfı.
/// JSON verisini Dart nesnesine (fromJson) ve tekrar JSON'a (toJson) çevirir.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.specs,
  });

  /// JSON (Map) -> Product
  factory Product.fromJson(Map<String, dynamic> json) {
    // specs alanı yoksa boş Map kullan (null safety)
    final rawSpecs = json['specs'] as Map<String, dynamic>? ?? {};

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      category: json['category'] as String? ?? '',
      // JSON'da sayı int (64) ya da double (64.5) gelebilir, num ile ikisini de karşılarız
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] as String,
      description: json['description'] as String? ?? '',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// Product -> JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'category': category,
      'price': price,
      'image': imageUrl,
      'description': description,
      'specs': specs,
    };
  }

  /// Ekranda gösterilecek fiyat metni, ör: 3.499,90 ₺
  String get formattedPrice => formatPrice(price);
}

/// Sayıyı Türk lirası biçimine çevirir: 18999.5 -> "18.999,50 ₺"
/// (intl paketi kullanmadan, eğitim kuralına uygun şekilde)
String formatPrice(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final whole = parts[0];
  final buffer = StringBuffer();
  for (int i = 0; i < whole.length; i++) {
    // Sondan itibaren her 3 basamakta bir nokta koy
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return '${buffer.toString()},${parts[1]} ₺';
}
