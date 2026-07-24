import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';

const _businessTypes = [
  'Food & Beverage',
  'Fashion & Apparel',
  'Electronics',
  'Books & Stationery',
  'Handicrafts',
  'Services',
  'Other',
];

const _payoutMethods = [
  ('bkash', 'bKash'),
  ('nagad', 'Nagad'),
  ('bank', 'Bank Transfer'),
];

/// Lets an owner edit their existing business's public/contact details.
/// Verification documents (student ID / NID) submitted at application time
/// aren't editable here — they stay fixed once uploaded.
class MerchantEditScreen extends ConsumerStatefulWidget {
  final Merchant merchant;
  const MerchantEditScreen({super.key, required this.merchant});

  @override
  ConsumerState<MerchantEditScreen> createState() => _MerchantEditScreenState();
}

class _MerchantEditScreenState extends ConsumerState<MerchantEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _businessNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _socialMediaController;
  late final TextEditingController _payoutAccountController;
  String? _businessType;
  String? _payoutMethod;

  File? _logoFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.merchant;
    _businessNameController = TextEditingController(text: m.businessName);
    _descriptionController = TextEditingController(text: m.description);
    _phoneController = TextEditingController(text: m.phone);
    _emailController = TextEditingController(text: m.email);
    _websiteController = TextEditingController(text: m.website ?? '');
    _socialMediaController = TextEditingController(text: m.socialMediaLink ?? '');
    _payoutAccountController = TextEditingController(text: m.payoutAccount ?? '');
    _businessType = m.businessType.isNotEmpty ? m.businessType : null;
    _payoutMethod = m.payoutMethod;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _socialMediaController.dispose();
    _payoutAccountController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() => _logoFile = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      String? logoUrl = widget.merchant.logoUrl;
      final logoFile = _logoFile;
      if (logoFile != null) {
        final apiClient = ref.read(apiClientProvider);
        final response = await apiClient.uploadFile(
          '/upload',
          filePath: logoFile.path,
          fieldName: 'image',
          data: {'folder': 'merchants'},
        );
        logoUrl = response.data['file_url'] as String? ?? logoUrl;
      }

      await updateMerchant(
        ref,
        merchantId: widget.merchant.id,
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: logoUrl,
        businessType: _businessType,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
        socialMediaLink: _socialMediaController.text.trim(),
        // Verification documents aren't edited here — round-trip the
        // existing values so this save never wipes them.
        studentIdProofUrl: widget.merchant.studentIdProofUrl,
        nidProofUrl: widget.merchant.nidProofUrl,
        payoutMethod: _payoutMethod,
        payoutAccount: _payoutAccountController.text.trim(),
      );

      ref.invalidate(myMerchantsProvider);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Business updated.');
      Navigator.of(context).pop();
    } on DioException catch (e) {
      final message = (e.response?.data is Map) ? e.response?.data['error'] as String? : null;
      Fluttertoast.showToast(msg: message ?? 'Could not save changes. Please try again.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not save changes. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Business')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickLogo,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surfaceAltBg,
                        border: Border.all(color: colors.primaryColor.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: _buildLogoPreview(colors),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(LucideIcons.camera, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<String>(
              initialValue: _businessType,
              decoration: const InputDecoration(labelText: 'Type of Business'),
              items: _businessTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _businessType = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Phone'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Contact Email'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Website (Optional)'),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _socialMediaController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Facebook / Social Media Link (Optional)'),
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<String>(
              initialValue: _payoutMethod,
              decoration: const InputDecoration(labelText: 'Payout Method'),
              items: _payoutMethods.map((m) => DropdownMenuItem(value: m.$1, child: Text(m.$2))).toList(),
              onChanged: (v) => setState(() => _payoutMethod = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _payoutAccountController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Payout Account / Wallet Number'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.xxl),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(height: 16, width: 16, child: CupertinoActivityIndicator(color: Colors.white))
                  : const Icon(LucideIcons.save, size: 18),
              label: Text(_saving ? 'Saving...' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPreview(AppColors colors) {
    final logoFile = _logoFile;
    if (logoFile != null) {
      return ClipOval(child: Image.file(logoFile, fit: BoxFit.cover));
    }
    if (widget.merchant.logoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          widget.merchant.logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(LucideIcons.store, size: 32, color: colors.primaryColor.withValues(alpha: 0.6)),
        ),
      );
    }
    return Icon(LucideIcons.store, size: 32, color: colors.primaryColor.withValues(alpha: 0.6));
  }
}
