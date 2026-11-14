import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../models/product.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';

/// Ürün detay sayfası.
/// Ürün bilgisi Route Arguments ile ana sayfadan gelir.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /// Navigator.pushNamed(..., arguments: product) ile gönderilen ürünü okur
  Product get _product =>
      ModalRoute.of(context)!.settings.arguments as Product;

  void _addToCart() {
    setState(() {
      Cart.add(_product);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${_product.name} sepete eklendi'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: 'Sepete Git', onPressed: _openCart),
        ),
      );
  }

  /// Bu sefer MaterialPageRoute ile (isimsiz) sayfa geçişi örneği
  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
    if (mounted) setState(() {}); // rozet güncellensin
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        actions: [CartIconButton(onPressed: _openCart)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Büyük ürün görseli
          Container(
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Hero(
              tag: 'product-${product.id}',
              child: ProductImage(url: product.imageUrl),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(product.tagline, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(
            product.formattedPrice,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Açıklama',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: TextStyle(color: Colors.grey.shade800, height: 1.5),
          ),
          const SizedBox(height: 24),

          if (product.specs.isNotEmpty) ...[
            const Text(
              'Özellikler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: product.specs.entries.map((spec) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.key,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec.value,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),

      // Alttaki sabit "Sepete Ekle" butonu
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addToCart,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Sepete Ekle', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}
