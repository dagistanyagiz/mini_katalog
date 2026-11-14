import '../models/product.dart';

/// Sepetteki tek bir satır: ürün + adet
class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});

  double get total => product.price * quantity;
}

/// Basit sepet simülasyonu.
/// Veriler uygulama açık olduğu sürece bellekte tutulur.
/// Ekranlar değişiklikten sonra setState() çağırarak kendini günceller.
class Cart {
  Cart._(); // Bu sınıftan nesne üretilmesin, sadece static üyeler kullanılsın

  static final List<CartItem> items = [];

  /// Sepetteki toplam ürün adedi (rozet için)
  static int get count => items.fold(0, (sum, item) => sum + item.quantity);

  /// Sepet toplam tutarı
  static double get total => items.fold(0.0, (sum, item) => sum + item.total);

  static void add(Product product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(CartItem(product));
    }
  }

  static void decrease(Product product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;

    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
  }

  static void clear() => items.clear();
}
