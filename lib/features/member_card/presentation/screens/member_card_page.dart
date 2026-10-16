import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/app_update/presentation/providers/app_update_provider.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/referral/referral_provider.dart';
import '/features/student/domain/entities/student.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '../../save_image/save_image.dart';
import '../widgets/member_card.dart';

const _fallbackStoreUrl =
    'https://play.google.com/store/apps/details?id=com.sofolit.campusassistant';

/// Play Store link the card's QR points at. The `referrer` param is read by
/// Play's install-referrer, so installs from shared cards show up per
/// university under Play Console → acquisition (utm_source=member_card).
/// The only personal value embedded is the public invite code (utm_content).
String memberCardInstallUrl(
  String? configuredUrl,
  String universityId, {
  String? referralCode,
}) {
  final base = Uri.parse(
    (configuredUrl == null || configuredUrl.isEmpty)
        ? _fallbackStoreUrl
        : configuredUrl,
  );
  return base
      .replace(
        queryParameters: {
          ...base.queryParameters,
          'referrer':
              'utm_source=member_card&utm_medium=social&utm_campaign=$universityId'
              '${referralCode == null ? '' : '&utm_content=$referralCode'}',
        },
      )
      .toString();
}

class MemberCardPage extends ConsumerWidget {
  const MemberCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProfileProvider);
    final user = ref.watch(currentUserProvider).value;

    return CustomHeaderLayout(
      title: 'Member Card',
      showSearchBar: false,
      body: studentAsync.when(
        data: (student) {
          if (student == null || user == null || !student.isClaimed) {
            return const _NotEligible();
          }
          return _MemberCardEditor(user: user, student: student);
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Could not load your profile: $e')),
      ),
    );
  }
}

class _NotEligible extends StatelessWidget {
  const _NotEligible();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.idCard,
              size: 48,
              color: context.colors.textSubtle,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Member cards are for verified students',
              textAlign: TextAlign.center,
              style: text.titleMedium,
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Once your student profile is verified, you can create and share your Campus Assistant card here.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: context.colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCardEditor extends ConsumerStatefulWidget {
  const _MemberCardEditor({required this.user, required this.student});
  final User user;
  final Student student;

  @override
  ConsumerState<_MemberCardEditor> createState() => _MemberCardEditorState();
}

class _MemberCardEditorState extends ConsumerState<_MemberCardEditor> {
  final _captureKey = GlobalKey();
  final _shareButtonKey = GlobalKey();

  var _format = MemberCardFormat.story;
  var _memberType = MemberType.student;
  var _showSession = true;
  var _showStudentId = false;
  var _photoReady = false;
  _CardAction? _busy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precachePhoto();
  }

  /// The capture must not happen before the avatar has decoded, otherwise the
  /// exported image shows the placeholder.
  Future<void> _precachePhoto() async {
    if (_photoReady) return;
    final url = widget.user.profileImage;
    if (url != null && url.isNotEmpty) {
      await precacheImage(
        CachedNetworkImageProvider(ApiEndpoints.resolveImageUrl(url)),
        context,
        onError: (_, _) {},
      );
    }
    if (mounted) setState(() => _photoReady = true);
  }

  MemberCardData _buildData() {
    final s = widget.student;
    final config = ref.watch(appUpdateConfigProvider).value;
    final code = ref.watch(referralSummaryProvider).value?.code;
    return MemberCardData(
      name: widget.user.fullName.trim(),
      memberType: _memberType,
      universityName: s.universityName ?? '',
      departmentName: s.departmentName ?? '',
      photoUrl: widget.user.profileImage,
      batch: s.batchName,
      session: _showSession ? s.sessionName : null,
      studentId: _showStudentId ? s.studentId : null,
      referralCode: code,
      installUrl: memberCardInstallUrl(
        config?.playStoreUrl,
        s.universityId,
        referralCode: code,
      ),
    );
  }

  /// The data the preview was last built with — read from [_run], where
  /// `ref.watch` isn't allowed.
  late MemberCardData _data;

  String _shareText() {
    final data = _data;
    final code = data.referralCode;
    return 'I\'m on Campus Assistant — the app for everything at '
        '${widget.student.universityName ?? 'campus'}. '
        '${code == null ? '' : 'Use my code $code when you sign up. '}'
        'Join here: ${data.installUrl}';
  }

  /// Renders the card at 1080px wide and encodes it as PNG.
  Future<Uint8List> _capture() async {
    final boundary =
        _captureKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 1080 / MemberCard.logicalWidth,
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (bytes == null) throw StateError('Could not encode image');
    return bytes.buffer.asUint8List();
  }

  String get _fileName => 'campus-assistant-member-card-${_format.name}.png';

  Future<void> _run(_CardAction action) async {
    setState(() => _busy = action);
    try {
      final bytes = await _capture();
      switch (action) {
        case _CardAction.share:
          final box =
              _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile.fromData(bytes, mimeType: 'image/png')],
              fileNameOverrides: [_fileName],
              text: _shareText(),
              sharePositionOrigin: box == null
                  ? null
                  : box.localToGlobal(Offset.zero) & box.size,
            ),
          );
        case _CardAction.download:
          await saveImageBytes(bytes, _fileName);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                kIsWeb ? 'Card downloaded' : 'Card saved to your gallery',
              ),
            ),
          );
      }
    } catch (e) {
      if (!mounted) return;
      final verb = action == _CardAction.share ? 'share' : 'save';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not $verb card: $e')));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data = _buildData();
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              Center(
                child: ConstrainedBox(
                  // Story cards are tall; cap the preview so the controls
                  // stay on screen.
                  constraints: BoxConstraints(
                    maxHeight: _format == MemberCardFormat.story ? 480 : 360,
                  ),
                  child: AspectRatio(
                    aspectRatio: _format.aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusToken.lg),
                      child: FittedBox(
                        child: RepaintBoundary(
                          key: _captureKey,
                          child: MemberCard(data: data, format: _format),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              Text('Format', style: text.titleSmall),
              const SizedBox(height: Spacing.sm),
              SegmentedButton<MemberCardFormat>(
                segments: [
                  for (final f in MemberCardFormat.values)
                    ButtonSegment(value: f, label: Text(f.label)),
                ],
                selected: {_format},
                onSelectionChanged: (s) => setState(() => _format = s.first),
              ),
              const SizedBox(height: Spacing.lg),
              Text('I am', style: text.titleSmall),
              const SizedBox(height: Spacing.sm),
              SegmentedButton<MemberType>(
                segments: [
                  for (final t in MemberType.values)
                    ButtonSegment(value: t, label: Text(t.label)),
                ],
                selected: {_memberType},
                onSelectionChanged: (s) =>
                    setState(() => _memberType = s.first),
              ),
              const SizedBox(height: Spacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show session'),
                value: _showSession,
                onChanged: (v) => setState(() => _showSession = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show student ID'),
                subtitle: const Text('Off by default — the card is public'),
                value: _showStudentId,
                onChanged: (v) => setState(() => _showStudentId = v),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (_photoReady && _busy == null)
                        ? () => _run(_CardAction.download)
                        : null,
                    icon: _busy == _CardAction.download
                        ? const _ButtonSpinner()
                        : const Icon(LucideIcons.download),
                    label: const Text('Download PNG'),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: FilledButton.icon(
                    key: _shareButtonKey,
                    onPressed: (_photoReady && _busy == null)
                        ? () => _run(_CardAction.share)
                        : null,
                    icon: _busy == _CardAction.share
                        ? const _ButtonSpinner()
                        : const Icon(LucideIcons.share2),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _CardAction { share, download }

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) =>
      const SizedBox.square(dimension: 16, child: CupertinoActivityIndicator());
}
