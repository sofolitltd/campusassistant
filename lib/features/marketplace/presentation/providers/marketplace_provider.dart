import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/address.dart';
import '../../data/models/category.dart';
import '../../data/models/merchant.dart';
import '../../data/models/product.dart';

final productsListProvider = FutureProvider.family<
    List<Product>, ({String universityId, String departmentId})>(
  (ref, params) async {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get(
      '/products-by-location',
      queryParameters: {
        'university_id': params.universityId,
        'department_id': params.departmentId,
      },
    );
    final data = response.data as List;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  },
);

final productsListByCategoryProvider = FutureProvider.family<
    List<Product>,
    ({String universityId, String departmentId, String categoryId})>(
  (ref, params) async {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get(
      '/products-by-location',
      queryParameters: {
        'university_id': params.universityId,
        'department_id': params.departmentId,
        'category_id': params.categoryId,
      },
    );
    final data = response.data as List;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  },
);

final productDetailsProvider =
    FutureProvider.family<Product, String>((ref, productId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/products/$productId');
  return Product.fromJson(response.data as Map<String, dynamic>);
});

final categoriesListProvider = FutureProvider<List<Category>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/marketplace-categories');
  final rawData = response.data;
  final items = rawData is List
      ? rawData
      : (rawData as Map<String, dynamic>)['data'] as List? ?? [];
  return items
      .map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList();
});

final merchantByIdProvider =
    FutureProvider.family<Merchant, String>((ref, merchantId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/merchants/$merchantId');
  return Merchant.fromJson(response.data as Map<String, dynamic>);
});

final merchantProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, merchantId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(
    '/products',
    queryParameters: {'merchant_id': merchantId},
  );
  final rawData = response.data;
  final items = rawData is List
      ? rawData
      : (rawData as Map<String, dynamic>)['data'] as List? ?? [];
  return items
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .where((p) => p.isPublished)
      .toList();
});

/// The owner's own view of their business's products — unlike
/// `merchantProductsProvider` (the public storefront view), this includes
/// unpublished/draft products, since the owner needs to see and manage
/// everything, not just what's live.
final myMerchantProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, merchantId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/merchants/$merchantId/products');
  final rawData = response.data;
  final items = rawData is List
      ? rawData
      : (rawData as Map<String, dynamic>)['data'] as List? ?? [];
  return items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
});

Future<Product> createMyProduct(
  WidgetRef ref, {
  required String merchantId,
  required String title,
  required String description,
  required int price,
  required int stock,
  List<String> imageUrls = const [],
  bool isPublished = false,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/merchants/$merchantId/products',
    data: {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'image_urls': imageUrls,
      'is_published': isPublished,
    },
  );
  return Product.fromJson(response.data as Map<String, dynamic>);
}

Future<Product> updateMyProduct(
  WidgetRef ref, {
  required String merchantId,
  required String productId,
  required String title,
  required String description,
  required int price,
  required int stock,
  List<String> imageUrls = const [],
  required bool isPublished,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put(
    '/my/merchants/$merchantId/products/$productId',
    data: {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'image_urls': imageUrls,
      'is_published': isPublished,
    },
  );
  return Product.fromJson(response.data as Map<String, dynamic>);
}

Future<void> deleteMyProduct(WidgetRef ref, {required String merchantId, required String productId}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/my/merchants/$merchantId/products/$productId');
}

/// A user may own more than one business (e.g. a food stall and a tutoring
/// service), so this returns every merchant profile they've applied for.
final myMerchantsProvider = FutureProvider<List<Merchant>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/merchants');
  final rawData = response.data;
  final items = rawData is List
      ? rawData
      : (rawData as Map<String, dynamic>)['data'] as List? ?? [];
  return items.map((e) => Merchant.fromJson(e as Map<String, dynamic>)).toList();
});

final addressesProvider = FutureProvider<List<Address>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/addresses');
  final data = response.data as List;
  return data.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
});

Future<Merchant> applyForMerchant(
  WidgetRef ref, {
  required String businessName,
  required String description,
  String? logoUrl,
  String? businessType,
  String? phone,
  String? email,
  String? website,
  String? socialMediaLink,
  String? studentIdProofUrl,
  String? nidProofUrl,
  String? payoutMethod,
  String? payoutAccount,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/merchant/apply',
    data: {
      'business_name': businessName,
      'description': description,
      'logo_url': logoUrl,
      'business_type': businessType,
      'phone': phone,
      'email': email,
      'website': website,
      'social_media_link': socialMediaLink,
      'student_id_proof_url': studentIdProofUrl,
      'nid_proof_url': nidProofUrl,
      'payout_method': payoutMethod,
      'payout_account': payoutAccount,
    },
  );
  return Merchant.fromJson(response.data as Map<String, dynamic>);
}

Future<Merchant> updateMerchant(
  WidgetRef ref, {
  required String merchantId,
  required String businessName,
  required String description,
  String? logoUrl,
  String? businessType,
  String? phone,
  String? email,
  String? website,
  String? socialMediaLink,
  String? studentIdProofUrl,
  String? nidProofUrl,
  String? payoutMethod,
  String? payoutAccount,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put(
    '/my/merchants/$merchantId',
    data: {
      'business_name': businessName,
      'description': description,
      'logo_url': logoUrl,
      'business_type': businessType,
      'phone': phone,
      'email': email,
      'website': website,
      'social_media_link': socialMediaLink,
      'student_id_proof_url': studentIdProofUrl,
      'nid_proof_url': nidProofUrl,
      'payout_method': payoutMethod,
      'payout_account': payoutAccount,
    },
  );
  return Merchant.fromJson(response.data as Map<String, dynamic>);
}

Future<void> deleteMerchant(WidgetRef ref, {required String merchantId}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/my/merchants/$merchantId');
}

Future<Address> createAddress(WidgetRef ref, {required Address address}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post('/my/addresses', data: address.toJson());
  return Address.fromJson(response.data as Map<String, dynamic>);
}

Future<Address> updateAddress(WidgetRef ref, {required Address address}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put(
    '/my/addresses/${address.id}',
    data: address.toJson(),
  );
  return Address.fromJson(response.data as Map<String, dynamic>);
}

Future<void> deleteAddress(WidgetRef ref, {required String addressId}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/my/addresses/$addressId');
}

Future<void> setDefaultAddress(WidgetRef ref,
    {required String addressId}) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put('/my/addresses/$addressId/default');
}
