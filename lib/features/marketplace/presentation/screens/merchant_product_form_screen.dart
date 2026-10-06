import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

/// Create or edit a single product for one of the current user's own
/// businesses. Pass `product` to edit an existing one, or omit it to create
/// a new one for `merchantId`.
class MerchantProductFormScreen extends ConsumerStatefulWidget {
  final String merchantId;
  final Product? product;

  /// Start a new listing pre-filled from [product] instead of editing it.
  final bool duplicate;
  const MerchantProductFormScreen({
    super.key,
    required this.merchantId,
    this.product,
    this.duplicate = false,
  });

  @override
  ConsumerState<MerchantProductFormScreen> createState() =>
      _MerchantProductFormScreenState();
}

class _MerchantProductFormScreenState
    extends ConsumerState<MerchantProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late bool _isPublished;

  static const _maxImages = 5;

  // Photos already uploaded (kept as URLs) and newly picked ones, in order.
  late final List<String> _existingImages;
  final List<File> _newImages = [];
  String? _categoryId;
  bool _saving = false;

  bool get _isEditing => widget.product != null && !widget.duplicate;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleController = TextEditingController(
      text: p == null ? '' : (widget.duplicate ? '${p.title} (copy)' : p.title),
    );
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toString() : '',
    );
    _stockController = TextEditingController(
      text: p != null ? p.stock.toString() : '',
    );
    _isPublished = widget.duplicate ? false : (p?.isPublished ?? false);
    _existingImages = [...?p?.imageUrls];
    final cat = p?.category?.id;
    _categoryId = (cat == null || cat.isEmpty) ? null : cat;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  int get _imageCount => _existingImages.length + _newImages.length;

  Future<void> _pickImages() async {
    final room = _maxImages - _imageCount;
    if (room <= 0) return;
    final picked = await ImagePicker().pickMultiImage(
      imageQuality: 85,
      limit: room,
    );
    if (picked.isEmpty) return;
    setState(
      () => _newImages.addAll(picked.take(room).map((x) => File(x.path))),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final imageUrls = [..._existingImages];
      final apiClient = ref.read(apiClientProvider);
      for (final file in _newImages) {
        final response = await apiClient.uploadFile(
          '/upload',
          filePath: file.path,
          fieldName: 'image',
          data: {'folder': 'products'},
        );
        final url = response.data['file_url'] as String?;
        if (url != null) imageUrls.add(url);
      }

      final price = int.parse(_priceController.text.trim());
      final stock = int.parse(_stockController.text.trim());

      if (_isEditing) {
        await updateMyProduct(
          ref,
          merchantId: widget.merchantId,
          productId: widget.product!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          stock: stock,
          imageUrls: imageUrls,
          isPublished: _isPublished,
          categoryId: _categoryId,
        );
      } else {
        await createMyProduct(
          ref,
          merchantId: widget.merchantId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          stock: stock,
          imageUrls: imageUrls,
          isPublished: _isPublished,
          categoryId: _categoryId,
        );
      }

      ref.invalidate(myMerchantProductsProvider(widget.merchantId));
      ref.invalidate(merchantProductsProvider(widget.merchantId));
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: _isEditing ? 'Product updated.' : 'Product added.',
      );
      Navigator.of(context).pop();
    } on DioException catch (e) {
      final message = (e.response?.data is Map)
          ? e.response?.data['error'] as String?
          : null;
      Fluttertoast.showToast(
        msg: message ?? 'Could not save product. Please try again.',
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not save product. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesListProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Duplicate listing',
              icon: const Icon(LucideIcons.copy),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => MerchantProductFormScreen(
                    merchantId: widget.merchantId,
                    product: widget.product,
                    duplicate: true,
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(Spacing.lg),
                children: [
                  SizedBox(
                    height: 104,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var i = 0; i < _existingImages.length; i++)
                          _PhotoTile(
                            image: Image.network(
                              ApiEndpoints.resolveImageUrl(_existingImages[i]),
                              fit: BoxFit.cover,
                            ),
                            isCover: i == 0,
                            onRemove: () =>
                                setState(() => _existingImages.removeAt(i)),
                          ),
                        for (var i = 0; i < _newImages.length; i++)
                          _PhotoTile(
                            image: Image.file(_newImages[i], fit: BoxFit.cover),
                            isCover: _existingImages.isEmpty && i == 0,
                            onRemove: () =>
                                setState(() => _newImages.removeAt(i)),
                          ),
                        if (_imageCount < _maxImages)
                          GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 104,
                              decoration: BoxDecoration(
                                borderRadius: RadiusToken.circular(
                                  RadiusToken.md,
                                ),
                                color: context.colors.surfaceAlt,
                                border: Border.all(
                                  color: context.colors.borderStrong,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.imagePlus,
                                    color: context.colors.textSubtle,
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    'Add photos',
                                    style: TextStyle(
                                      fontSize: FontSizeToken.sm,
                                      color: context.colors.textSubtle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    'Up to $_maxImages photos. The first one is the cover. Listings with clear photos sell faster.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: context.colors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Product Title',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: Spacing.md),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: .number,
                          decoration: const InputDecoration(
                            labelText: 'Price (৳)',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Required';
                            if (int.tryParse(v.trim()) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _stockController,
                          keyboardType: .number,
                          decoration: const InputDecoration(labelText: 'Stock'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Required';
                            if (int.tryParse(v.trim()) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          setState(() => _stockController.text = '0'),
                      icon: const Icon(LucideIcons.packageX, size: 16),
                      label: const Text('Mark As Sold Out'),
                    ),
                  ),
                  if (categories.isNotEmpty) ...[
                    const SizedBox(height: Spacing.sm),
                    DropdownButtonFormField<String?>(
                      initialValue: categories.any((c) => c.id == _categoryId)
                          ? _categoryId
                          : null,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('No category'),
                        ),
                        for (final c in categories)
                          DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                      ],
                      onChanged: (v) => setState(() => _categoryId = v),
                    ),
                  ],
                  const SizedBox(height: Spacing.md),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Published',
                      style: TextStyle(fontWeight: .w600),
                    ),
                    subtitle: const Text(
                      'Visible to buyers on the marketplace',
                      style: TextStyle(fontSize: FontSizeToken.sm),
                    ),
                    value: _isPublished,
                    onChanged: (v) => setState(() => _isPublished = v),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CupertinoActivityIndicator(
                              color: context.colors.onPrimary,
                            ),
                          )
                        : const Icon(LucideIcons.save, size: 18),
                    label: Text(
                      _saving
                          ? 'Saving...'
                          : (_isEditing ? 'Save Changes' : 'Add Product'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final Widget image;
  final bool isCover;
  final VoidCallback onRemove;
  const _PhotoTile({
    required this.image,
    required this.isCover,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 104,
      margin: const EdgeInsets.only(right: Spacing.sm),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: RadiusToken.circular(RadiusToken.md),
        border: Border.all(color: c.border),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (isCover)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xxs,
                ),
                color: c.surfaceInverse,
                child: Text(
                  'Cover',
                  style: TextStyle(
                    fontSize: FontSizeToken.xxs,
                    fontWeight: FontWeight.w700,
                    color: c.textInverse,
                  ),
                ),
              ),
            ),
          Positioned(
            right: 2,
            top: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(Spacing.xs),
                decoration: BoxDecoration(
                  color: c.surfaceInverse,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.x, size: 12, color: c.textInverse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
