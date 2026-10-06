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
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/routes/app_route.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';
import '../providers/seller_provider.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

/// Lets a student apply to become a marketplace merchant. Submits with
/// status "pending" server-side; an admin reviews and approves/rejects it
/// in the admin panel before the merchant can list products. A student may
/// run more than one business, so this screen shows every business they
/// already own as a card and lets them apply for another.
class MerchantApplyScreen extends ConsumerStatefulWidget {
  const MerchantApplyScreen({super.key});

  @override
  ConsumerState<MerchantApplyScreen> createState() =>
      _MerchantApplyScreenState();
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
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
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
      Fluttertoast.showToast(
        msg: 'Please upload both your Student ID and NID for verification.',
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final logoUrl = await _uploadIfPicked(_logoFile, 'merchants');
      final studentIdUrl = await _uploadPrivateIfPicked(
        _studentIdFile,
        'merchant-verification',
      );
      final nidUrl = await _uploadPrivateIfPicked(
        _nidFile,
        'merchant-verification',
      );
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
      final message = (e.response?.data is Map)
          ? e.response?.data['error'] as String?
          : null;
      Fluttertoast.showToast(
        msg: message ?? 'Could not submit. Please try again.',
      );
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
        const Text(
          'Your Businesses',
          style: TextStyle(fontWeight: .bold, fontSize: FontSizeToken.lg),
        ),
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
          label: const Text('Add another business'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, ControlToken.height),
            side: BorderSide(color: colors.primary),
            foregroundColor: colors.primary,
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
          const _PromoBanner(),
          if (showBackButton) ...[
            InkWell(
              onTap: () => setState(() => _addingNew = false),
              borderRadius: RadiusToken.circular(RadiusToken.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      LucideIcons.arrowLeft,
                      size: 16,
                      color: colors.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      'Back to My Businesses',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: .w600,
                        fontSize: FontSizeToken.md,
                      ),
                    ),
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
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              DropdownButtonFormField<String>(
                initialValue: _businessType,
                decoration: const InputDecoration(
                  labelText: 'Type of Business',
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
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                keyboardType: .phone,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              TextFormField(
                controller: _emailController,
                keyboardType: .emailAddress,
                decoration: const InputDecoration(labelText: 'Contact Email'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.info.withValues(alpha: 0.08),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(LucideIcons.shield, size: 14, color: colors.info),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Only visible to admins — never shown on your public storefront.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.info,
                          height: 1.3,
                        ),
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
                items: _payoutMethods
                    .map(
                      (m) => DropdownMenuItem(value: m.$1, child: Text(m.$2)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _payoutMethod = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              TextFormField(
                controller: _payoutAccountController,
                keyboardType: .phone,
                decoration: const InputDecoration(
                  labelText: 'Account / Wallet Number',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.info.withValues(alpha: 0.08),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(LucideIcons.shield, size: 14, color: colors.info),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Where your commission-adjusted earnings are sent. Only visible to admins.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.info,
                          height: 1.3,
                        ),
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
                keyboardType: .url,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              const SizedBox(height: Spacing.md),
              TextFormField(
                controller: _socialMediaController,
                keyboardType: .url,
                decoration: const InputDecoration(
                  labelText: 'Facebook / Social Media Link',
                ),
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
                  color: colors.warning.withValues(alpha: 0.1),
                  borderRadius: RadiusToken.circular(RadiusToken.sm),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(
                      LucideIcons.triangleAlert,
                      size: 14,
                      color: colors.warning,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        'Required so an admin can confirm you\'re a genuine student before approving.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: context.colors.textMuted,
                          height: 1.3,
                        ),
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
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CupertinoActivityIndicator(
                      color: context.colors.onPrimary,
                    ),
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
    final colors = Theme.of(context).appColors;
    final (icon, color, label) = switch (merchant.status) {
      'approved' => (LucideIcons.circleCheck, colors.success, 'Approved'),
      'rejected' => (LucideIcons.circleX, colors.danger, 'Rejected'),
      _ => (LucideIcons.clock, colors.warning, 'Pending'),
    };

    return Material(
      color: context.colors.surface,
      borderRadius: RadiusToken.circular(RadiusToken.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            borderRadius: RadiusToken.circular(RadiusToken.lg),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: RadiusToken.circular(RadiusToken.md),
                child: merchant.logoUrl.isNotEmpty
                    ? Image.network(
                        ApiEndpoints.resolveImageUrl(merchant.logoUrl),
                        width: 52,
                        height: 52,
                        fit: .cover,
                        errorBuilder: (_, _, _) => _fallbackLogo(colors),
                      )
                    : _fallbackLogo(colors),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      merchant.businessName,
                      style: const TextStyle(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.base,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(icon, size: 12, color: color),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: FontSizeToken.xs,
                            fontWeight: .w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: context.colors.textSubtle,
              ),
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
    child: Icon(
      LucideIcons.store,
      size: 22,
      color: colors.primary.withValues(alpha: 0.6),
    ),
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
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: RadiusToken.circular(RadiusToken.lg),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.rocket, size: 20, color: colors.primary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              'Sell your own products in the Campus Marketplace. An admin will '
              'review your application before you can start listing products.',
              style: TextStyle(
                color: context.colors.textMuted,
                height: 1.4,
                fontSize: FontSizeToken.md,
              ),
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

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colors.primary),
              const SizedBox(width: Spacing.xs),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: .bold,
                  fontSize: FontSizeToken.base,
                ),
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

  const _LogoPicker({
    required this.file,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: .none,
        children: [
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceAltBg,
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: file != null
                ? ClipOval(child: Image.file(file!, fit: .cover))
                : Icon(
                    LucideIcons.store,
                    size: 32,
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: file != null ? onClear : onTap,
              child: Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.onPrimary, width: 2),
                ),
                child: Icon(
                  file != null ? LucideIcons.x : LucideIcons.camera,
                  size: 14,
                  color: context.colors.onPrimary,
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

  const _DocumentPicker({
    required this.label,
    required this.file,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: double.infinity,
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          borderRadius: RadiusToken.circular(RadiusToken.md),
          color: colors.surfaceAltBg,
          border: Border.all(
            color: file != null
                ? colors.primary.withValues(alpha: 0.5)
                : context.colors.borderStrong,
          ),
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(file!, fit: .cover),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.xs),
                        decoration: BoxDecoration(
                          color: context.colors.textMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 14,
                          color: context.colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    LucideIcons.upload,
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: context.colors.textMuted,
                      fontWeight: .w600,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    'Tap to upload',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: context.colors.textSubtle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Invites applicants with the running new-seller promotion, if there is one.
class _PromoBanner extends ConsumerWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promo = ref.watch(sellerPromoProvider).value;
    if (promo == null || !promo.active) return const SizedBox.shrink();
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.lg),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: c.successSubtle,
        borderRadius: RadiusToken.circular(RadiusToken.lg),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.sparkles, size: 20, color: c.success),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              'New seller offer: pay only ${formatPercent(promo.rate)} commission for your first ${promo.days} days after approval.',
              style: TextStyle(
                fontSize: 13,
                color: c.text,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
