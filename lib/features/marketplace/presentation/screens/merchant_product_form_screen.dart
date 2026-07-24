import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';

/// Create or edit a single product for one of the current user's own
/// businesses. Pass `product` to edit an existing one, or omit it to create
/// a new one for `merchantId`.
class MerchantProductFormScreen extends ConsumerStatefulWidget {
  final String merchantId;
  final Product? product;
  const MerchantProductFormScreen({super.key, required this.merchantId, this.product});

  @override
  ConsumerState<MerchantProductFormScreen> createState() => _MerchantProductFormScreenState();
}

class _MerchantProductFormScreenState extends ConsumerState<MerchantProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late bool _isPublished;

  File? _imageFile;
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toString() : '');
    _stockController = TextEditingController(text: p != null ? p.stock.toString() : '');
    _isPublished = p?.isPublished ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      var imageUrls = widget.product?.imageUrls ?? const <String>[];
      final imageFile = _imageFile;
      if (imageFile != null) {
        final apiClient = ref.read(apiClientProvider);
        final response = await apiClient.uploadFile(
          '/upload',
          filePath: imageFile.path,
          fieldName: 'image',
          data: {'folder': 'products'},
        );
        final url = response.data['file_url'] as String?;
        if (url != null) imageUrls = [url];
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
        );
      }

      ref.invalidate(myMerchantProductsProvider(widget.merchantId));
      ref.invalidate(merchantProductsProvider(widget.merchantId));
      if (!mounted) return;
      Fluttertoast.showToast(msg: _isEditing ? 'Product updated.' : 'Product added.');
      Navigator.of(context).pop();
    } on DioException catch (e) {
      final message = (e.response?.data is Map) ? e.response?.data['error'] as String? : null;
      Fluttertoast.showToast(msg: message ?? 'Could not save product. Please try again.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not save product. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingImage = widget.product?.imageUrls.isNotEmpty == true ? widget.product!.imageUrls.first : null;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Product' : 'Add Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: RadiusToken.circular(RadiusToken.md),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : existingImage != null
                        ? Image.network(existingImage, fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.imagePlus, color: Colors.grey.shade400),
                              const SizedBox(height: Spacing.xs),
                              Text('Add a photo', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Product Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (৳)'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (int.tryParse(v.trim()) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (int.tryParse(v.trim()) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Published', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Visible to buyers on the marketplace', style: TextStyle(fontSize: 12)),
              value: _isPublished,
              onChanged: (v) => setState(() => _isPublished = v),
            ),
            const SizedBox(height: Spacing.xxl),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(height: 16, width: 16, child: CupertinoActivityIndicator(color: Colors.white))
                  : const Icon(LucideIcons.save, size: 18),
              label: Text(_saving ? 'Saving...' : (_isEditing ? 'Save Changes' : 'Add Product')),
            ),
          ],
        ),
      ),
    );
  }
}
