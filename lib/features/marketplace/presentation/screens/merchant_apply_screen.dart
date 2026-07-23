import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '/core/di.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';

/// Lets a student apply to become a marketplace merchant. Submits with
/// status "pending" server-side; an admin reviews and approves/rejects it
/// in the admin panel before the merchant can list products.
class MerchantApplyScreen extends ConsumerStatefulWidget {
  const MerchantApplyScreen({super.key});

  @override
  ConsumerState<MerchantApplyScreen> createState() => _MerchantApplyScreenState();
}

const _businessTypes = [
  'Food & Beverage',
  'Fashion & Apparel',
  'Electronics',
  'Books & Stationery',
  'Handicrafts',
  'Services',
  'Other',
];

class _MerchantApplyScreenState extends ConsumerState<MerchantApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _businessType;

  File? _logoFile;
  bool _submitting = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() => _logoFile = File(picked.path));
  }

  Future<String?> _uploadLogoIfPicked() async {
    final file = _logoFile;
    if (file == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': 'merchants'},
    );
    return response.data['file_url'] as String?;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final logoUrl = await _uploadLogoIfPicked();
      await applyForMerchant(
        ref,
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: logoUrl,
        businessType: _businessType,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      ref.invalidate(myMerchantProvider);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Application submitted. Thanks!');
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not submit. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myMerchantAsync = ref.watch(myMerchantProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Become a Merchant')),
      body: myMerchantAsync.when(
        data: (merchant) => merchant != null
            ? _StatusView(merchant: merchant)
            : _buildForm(context),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Sell your own products in the Campus Marketplace. An admin will '
            'review your application before you can start listing products.',
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: Spacing.lg),
          _LogoPickerBox(
            file: _logoFile,
            onTap: _pickLogo,
            onClear: () => setState(() => _logoFile = null),
          ),
          const SizedBox(height: Spacing.md),
          TextFormField(
            controller: _businessNameController,
            decoration: const InputDecoration(
              labelText: 'Business Name',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: Spacing.md),
          DropdownButtonFormField<String>(
            initialValue: _businessType,
            decoration: const InputDecoration(
              labelText: 'Type of Business',
              border: OutlineInputBorder(),
            ),
            items: _businessTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _businessType = v),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: Spacing.md),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: Spacing.md),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Contact Phone',
              helperText: 'Only visible to admins, not shown publicly',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: Spacing.md),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Contact Email',
              helperText: 'Only visible to admins, not shown publicly',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: Spacing.xl),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CupertinoActivityIndicator(),
                  )
                : const Text('Submit Application'),
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  final Merchant merchant;

  const _StatusView({required this.merchant});

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (merchant.status) {
      'approved' => (Icons.check_circle, Colors.green, 'Approved'),
      'rejected' => (Icons.cancel, Colors.red, 'Rejected'),
      _ => (Icons.hourglass_top, Colors.orange, 'Pending review'),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: color),
            const SizedBox(height: Spacing.md),
            Text(
              merchant.businessName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            if (merchant.status == 'rejected' &&
                merchant.rejectionReason != null &&
                merchant.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              Text(
                'Reason: ${merchant.rejectionReason}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoPickerBox extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _LogoPickerBox({required this.file, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade50,
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text('Logo', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
      ),
    );
  }
}
