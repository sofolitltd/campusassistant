import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/routes/app_route.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';

/// Lets a student apply to become a marketplace merchant. Submits with
/// status "pending" server-side; an admin reviews and approves/rejects it
/// in the admin panel before the merchant can list products. A student may
/// run more than one business, so this screen shows every business they
/// already own as a card and lets them apply for another.
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

const _payoutMethods = [
  ('bkash', 'bKash'),
  ('nagad', 'Nagad'),
  ('bank', 'Bank Transfer'),
];

class _MerchantApplyScreenState extends ConsumerState<MerchantApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _payoutAccountController = TextEditingController();
  String? _businessType;
  String? _payoutMethod;

  File? _logoFile;
  File? _studentIdFile;
  File? _nidFile;
  bool _submitting = false;
  bool _addingNew = false;

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

  Future<File?> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    return picked == null ? null : File(picked.path);
  }

  Future<String?> _uploadIfPicked(File? file, String folder) async {
    if (file == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': folder},
    );
    return response.data['file_url'] as String?;
  }

  /// Verification documents (Student ID / NID) go through the authenticated,
  /// private upload path instead — the server never returns a public URL
  /// for these, only an attachment id to store; viewing them later requires
  /// resolving a short-lived signed URL, ownership- or admin-checked.
  Future<String?> _uploadPrivateIfPicked(File? file, String folder) async {
    if (file == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadFile(
      '/my/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': folder},
    );
    return response.data['id'] as String?;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentIdFile == null || _nidFile == null) {
      Fluttertoast.showToast(msg: 'Please upload both your Student ID and NID for verification.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final logoUrl = await _uploadIfPicked(_logoFile, 'merchants');
      final studentIdUrl = await _uploadPrivateIfPicked(_studentIdFile, 'merchant-verification');
      final nidUrl = await _uploadPrivateIfPicked(_nidFile, 'merchant-verification');
      await applyForMerchant(
        ref,
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: logoUrl,
        businessType: _businessType,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
        socialMediaLink: _socialMediaController.text.trim(),
        studentIdProofUrl: studentIdUrl,
        nidProofUrl: nidUrl,
        payoutMethod: _payoutMethod,
        payoutAccount: _payoutAccountController.text.trim(),
      );

      ref.invalidate(myMerchantsProvider);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Application submitted. Thanks!');
      setState(() => _addingNew = false);
    } on DioException catch (e) {
      final message = (e.response?.data is Map) ? e.response?.data['error'] as String? : null;
      Fluttertoast.showToast(msg: message ?? 'Could not submit. Please try again.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not submit. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchantsAsync = ref.watch(myMerchantsProvider);

    return CustomHeaderLayout(
      title: 'Become a Merchant',
      showSearchBar: false,
      body: merchantsAsync.when(
        data: (merchants) => merchants.isEmpty || _addingNew
            ? _buildForm(context, showBackButton: merchants.isNotEmpty)
            : _buildMerchantList(context, merchants),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => _buildForm(context, showBackButton: false),
      ),
    );
  }

  Widget _buildMerchantList(BuildContext context, List<Merchant> merchants) {
    final colors = Theme.of(context).appColors;
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        const Text('Your Businesses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: Spacing.md),
        ...merchants.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.md),
            child: _MerchantCard(
              merchant: m,
              onTap: () => context.pushNamed(
                AppRoute.merchantManage.name,
                pathParameters: {'merchantId': m.id},
                extra: m,
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        OutlinedButton.icon(
          onPressed: () => setState(() => _addingNew = true),
          icon: const Icon(LucideIcons.plus, size: 18),
          label: const Text('Add Another Business'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: colors.primaryColor),
            foregroundColor: colors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.md)),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, {required bool showBackButton}) {
    final colors = Theme.of(context).appColors;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          if (showBackButton) ...[
            InkWell(
              onTap: () => setState(() => _addingNew = false),
              borderRadius: RadiusToken.circular(RadiusToken.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.arrowLeft, size: 16, color: colors.primaryColor),
                    const SizedBox(width: Spacing.xs),
                    Text('Back to My Businesses', style: TextStyle(color: colors.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
          ],
          _IntroBanner(colors: colors),
          const SizedBox(height: Spacing.xl),
          Center(
            child: _LogoPicker(
              file: _logoFile,
              onTap: () async {
                final picked = await _pickImage();
                if (picked != null) setState(() => _logoFile = picked);
              },
              onClear: () => setState(() => _logoFile = null),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          _SectionCard(
            title: 'Business Details',
            icon: LucideIcons.store,
            children: [
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          _SectionCard(
            title: 'Contact Information',
            icon: LucideIcons.phone,
            children: [
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
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.infoColor.withValues(alpha: 0.08),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.shield, size: 14, color: colors.infoColor),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Only visible to admins — never shown on your public storefront.',
                        style: TextStyle(fontSize: 11.5, color: colors.infoColor, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          _SectionCard(
            title: 'Payout Information',
            icon: LucideIcons.wallet,
            children: [
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
                decoration: const InputDecoration(labelText: 'Account / Wallet Number'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.infoColor.withValues(alpha: 0.08),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.shield, size: 14, color: colors.infoColor),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Where your commission-adjusted earnings are sent. Only visible to admins.',
                        style: TextStyle(fontSize: 11.5, color: colors.infoColor, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          _SectionCard(
            title: 'Online Presence (Optional)',
            icon: LucideIcons.globe,
            children: [
              TextFormField(
                controller: _websiteController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              const SizedBox(height: Spacing.md),
              TextFormField(
                controller: _socialMediaController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(labelText: 'Facebook / Social Media Link'),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          _SectionCard(
            title: 'Verification Documents',
            icon: LucideIcons.idCard,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                margin: const EdgeInsets.only(bottom: Spacing.md),
                decoration: BoxDecoration(
                  color: colors.warningColor.withValues(alpha: 0.1),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.triangleAlert, size: 14, color: colors.warningColor),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Required so an admin can confirm you\'re a genuine student before approving.',
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              _DocumentPicker(
                label: 'Student ID Card',
                file: _studentIdFile,
                onTap: () async {
                  final picked = await _pickImage();
                  if (picked != null) setState(() => _studentIdFile = picked);
                },
                onClear: () => setState(() => _studentIdFile = null),
              ),
              const SizedBox(height: Spacing.md),
              _DocumentPicker(
                label: 'National ID (NID)',
                file: _nidFile,
                onTap: () async {
                  final picked = await _pickImage();
                  if (picked != null) setState(() => _nidFile = picked);
                },
                onClear: () => setState(() => _nidFile = null),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),
          ElevatedButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CupertinoActivityIndicator(color: Colors.white),
                  )
                : const Icon(LucideIcons.send, size: 18),
            label: Text(_submitting ? 'Submitting...' : 'Submit Application'),
          ),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  final Merchant merchant;
  final VoidCallback onTap;

  const _MerchantCard({required this.merchant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).appColors;
    final (icon, color, label) = switch (merchant.status) {
      'approved' => (LucideIcons.circleCheck, colors.successColor, 'Approved'),
      'rejected' => (LucideIcons.circleX, colors.destructiveColor, 'Rejected'),
      _ => (LucideIcons.clock, colors.warningColor, 'Pending'),
    };

    return Material(
      color: isDark ? Theme.of(context).cardColor : Colors.white,
      borderRadius: RadiusToken.circular(RadiusToken.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            borderRadius: RadiusToken.circular(RadiusToken.lg),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: RadiusToken.circular(RadiusToken.md),
                child: merchant.logoUrl.isNotEmpty
                    ? Image.network(
                        merchant.logoUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _fallbackLogo(colors),
                      )
                    : _fallbackLogo(colors),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant.businessName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 12, color: color),
                        const SizedBox(width: 4),
                        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackLogo(AppColors colors) => Container(
        width: 52,
        height: 52,
        color: colors.surfaceAltBg,
        child: Icon(LucideIcons.store, size: 22, color: colors.primaryColor.withValues(alpha: 0.6)),
      );
}

class _IntroBanner extends StatelessWidget {
  final AppColors colors;

  const _IntroBanner({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.primaryColor.withValues(alpha: 0.08),
        borderRadius: RadiusToken.circular(RadiusToken.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colors.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.rocket, size: 20, color: colors.primaryColor),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              'Sell your own products in the Campus Marketplace. An admin will '
              'review your application before you can start listing products.',
              style: TextStyle(color: Colors.grey.shade700, height: 1.4, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colors.primaryColor),
              const SizedBox(width: Spacing.xs),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _LogoPicker extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _LogoPicker({required this.file, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
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
            child: file != null
                ? ClipOval(child: Image.file(file!, fit: BoxFit.cover))
                : Icon(LucideIcons.store, size: 32, color: colors.primaryColor.withValues(alpha: 0.6)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: file != null ? onClear : onTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  file != null ? LucideIcons.x : LucideIcons.camera,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentPicker extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DocumentPicker({required this.label, required this.file, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: RadiusToken.circular(RadiusToken.md),
          color: colors.surfaceAltBg,
          border: Border.all(color: file != null ? colors.primaryColor.withValues(alpha: 0.5) : Colors.grey.shade300),
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(file!, fit: BoxFit.cover),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.x, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.upload, color: colors.primaryColor.withValues(alpha: 0.6)),
                  const SizedBox(height: Spacing.xs),
                  Text(label, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Tap to upload', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade400)),
                ],
              ),
      ),
    );
  }
}
