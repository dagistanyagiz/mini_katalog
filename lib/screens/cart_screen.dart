import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/cart.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';

/// Sepet sayfası (simülasyon)
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _checkout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sipariş Alındı'),
        content: Text(
          'Toplam ${formatPrice(Cart.total)} tutarındaki siparişin '
          'alındı.\n\n(Bu bir simülasyondur, gerçek ödeme yapılmaz.)',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // önce dialog'u kapat
              setState(() => Cart.clear());
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = Cart.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        actions: [
          if (!isEmpty)
            IconButton(
              tooltip: 'Sepeti boşalt',
              onPressed: () => setState(() => Cart.clear()),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: isEmpty ? _buildEmptyCart() : _buildCartList(),
      bottomNavigationBar: _buildBottomBar(isEmpty),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Sepetin boş',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Ürün ekleyerek alışverişe başlayabilirsin.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          TextButton(
            // Ana sayfaya kadar aradaki tüm sayfaları kapat
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(AppRoutes.home)),
            child: const Text('Alışverişe Dön'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: Cart.items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = Cart.items[index];
        return ListTile(
          leading: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ProductImage(url: item.product.imageUrl),
          ),
          title: Text(
            item.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item.product.formattedPrice),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => Cart.decrease(item.product)),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${item.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => Cart.add(item.product)),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(bool isEmpty) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu sepet eğitim amaçlı bir simülasyondur.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam', style: TextStyle(fontSize: 16)),
                Text(
                  formatPrice(Cart.total),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Sepet boşken buton pasif (null = disabled)
                onPressed: isEmpty ? null : _checkout,
                child: const Text('Ödeme Yap', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
