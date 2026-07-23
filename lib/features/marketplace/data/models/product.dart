import 'category.dart';
import 'merchant.dart';

class Product {
  final String id;
  final String merchantId;
  final Merchant? merchant;
  final String title;
  final String description;
  final int price;
  final int stock;
  final List<String> imageUrls;
  final Category? category;
  final bool isPublished;

  Product({
    required this.id,
    required this.merchantId,
    this.merchant,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
    this.category,
    required this.isPublished,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imageUrlsJson = json['image_urls'] as List? ?? [];
    final merchantJson = json['merchant'] as Map<String, dynamic>?;
    final categoryJson = json['category'] as Map<String, dynamic>?;

    return Product(
      id: json['id'] as String,
      merchantId: json['merchant_id'] as String? ?? '',
      merchant: merchantJson != null && (merchantJson['id'] as String?)?.isNotEmpty == true
          ? Merchant.fromJson(merchantJson)
          : null,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      imageUrls: imageUrlsJson.map((e) => e as String).toList(),
      category: categoryJson != null && (categoryJson['id'] as String?)?.isNotEmpty == true
          ? Category.fromJson(categoryJson)
          : null,
      isPublished: json['is_published'] as bool? ?? false,
    );
  }
}
