import 'package:flutter/material.dart';

import '../data/cart.dart';

/// Üzerinde sepetteki ürün sayısını gösteren sepet butonu
class CartIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CartIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: Cart.count > 0,
        label: Text('${Cart.count}'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
