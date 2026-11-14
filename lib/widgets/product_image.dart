import 'package:flutter/material.dart';

/// İnternetten ürün görseli yükler.
/// Yüklenirken dönen bir gösterge, hata olursa bir ikon gösterir.
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      // Web'de başka sitelerin resimleri (CORS) engellenirse
      // tarayıcının kendi <img> etiketiyle göster. Android'de etkisi yok.
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child; // yükleme bitti
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: Colors.grey, size: 40),
      ),
    );
  }
}
