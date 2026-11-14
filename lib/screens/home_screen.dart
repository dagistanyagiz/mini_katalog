import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: başlık, arama, banner ve ürün listesi (GridView)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String bannerUrl = 'https://wantapi.com/assets/banner.png';

  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = []; // JSON'dan gelen tüm ürünler
  List<Product> _filteredProducts = []; // aramaya göre ekranda gösterilenler
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductRepository.loadProducts();
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Ürünler yüklenemedi: $e';
        _isLoading = false;
      });
    }
  }

  /// Basit arama / filtreleme
  void _onSearchChanged(String text) {
    final query = text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query) ||
              product.tagline.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  /// Detay sayfasına ürünü argüman olarak göndererek git
  Future<void> _openDetail(Product product) async {
    await Navigator.pushNamed(context, AppRoutes.detail, arguments: product);
    // Geri dönüldüğünde sepet rozetini güncellemek için ekranı yenile
    if (mounted) setState(() {});
  }

  Future<void> _openCart() async {
    await Navigator.pushNamed(context, AppRoutes.cart);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildSearchField(),
          const SizedBox(height: 16),
          _buildBanner(),
          const SizedBox(height: 20),
          Text(
            'Ürünler (${_filteredProducts.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keşfet',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Sana en uygun ürünü bul',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        CartIconButton(onPressed: _openCart),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Ürün ara...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        bannerUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        // Banner yüklenemezse kendi tasarımımızı göster
        errorBuilder: (context, error, stackTrace) => Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HEDİYE MAĞAZASI',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 4),
              Text('Sevdiklerine en güzel hediyeyi seç'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('Aramana uygun ürün bulunamadı.')),
      );
    }

    return GridView.builder(
      // Dışarıdaki SingleChildScrollView kaydıracağı için:
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 sütun
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68, // kart genişlik / yükseklik oranı
      ),
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return ProductCard(
          product: product,
          onTap: () => _openDetail(product),
        );
      },
    );
  }
}
