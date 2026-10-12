import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/batch/presentation/providers/batch_provider.dart'
    as new_batch;
import '/features/cr/presentation/providers/cr_provider.dart';
import '/core/network/api_endpoints.dart';
import '/utils/constants.dart';
import 'package:go_router/go_router.dart';
import '/routes/app_route.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/widgets/inline_search_bar.dart';
import '/core/widgets/not_added_notice.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/widgets/open_app.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

enum _VerifyRole { student, teacher, staff }

class GetVerificationCodeScreen extends StatefulWidget {
  const GetVerificationCodeScreen({super.key});

  @override
  State<GetVerificationCodeScreen> createState() =>
      _GetVerificationCodeScreenState();
}

class _GetVerificationCodeScreenState extends State<GetVerificationCodeScreen> {
  // Deliberately independent of the role toggle on the "I have a code" OTP
  // step one screen back — that selection is scoped to the OTP flow, not to
  // this fallback, so carrying it here silently could show a student the
  // teacher/staff path (or vice versa) without them ever having chosen it.
  // Defaults to student (the common case) rather than forcing an explicit
  // tap before any content shows; teacher/staff switch it themselves.
  _VerifyRole _role = _VerifyRole.student;

  Widget _roleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
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
        crossAxisAlignment: .stretch,
        children: [
          Text(
            'Which Describes You?',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: .w600),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            "So we show you the right next step.",
            style: TextStyle(color: context.colors.textMuted),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<_VerifyRole>(
                  segments: const [
                    ButtonSegment(
                      value: _VerifyRole.student,
                      label: Text('Student'),
                    ),
                    ButtonSegment(
                      value: _VerifyRole.teacher,
                      label: Text('Teacher'),
                    ),
                    ButtonSegment(
                      value: _VerifyRole.staff,
                      label: Text('Staff'),
                    ),
                  ],
                  selected: {_role},
                  onSelectionChanged: (s) => setState(() => _role = s.first),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teacherStaffCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.primarySubtle,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            'Contact An Admin Or Moderator',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: .w600,
              color: context.colors.text,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          const Text(
            "Teacher and staff accounts aren't verified by document upload — "
            "message us on Facebook or WhatsApp with your name, university "
            "and department, and we'll set up your verification code.",
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => OpenApp.withUrl(kFbGroup),
                  icon: Icon(
                    Icons.facebook_outlined,
                    color: context.colors.info,
                  ),
                  label: const Text('Facebook'),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => OpenApp.withUrl(kRegistrationWhatsAppUrl),
                  icon: Icon(
                    Icons.chat_outlined,
                    color: context.colors.success,
                  ),
                  label: const Text('WhatsApp'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          title: Text(
            'Get Verification Code',
            style: TextStyle(
              fontWeight: .bold,
              color: context.colors.onPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxxl),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Spacing.xl,
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .3
                    : Spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  _roleCard(context),
                  const SizedBox(height: Spacing.xxl),
                  if (_role == _VerifyRole.student) ...[
                    Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: context.colors.primarySubtle,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Text(
                            'No code? Verify with your documents',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: .w600,
                                  color: context.colors.text,
                                ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          const Text(
                            "Create an account, then upload your student ID card and "
                            "your registration card or certificate. An admin will "
                            "verify you — no CR needed.",
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(height: Spacing.lg),
                          ElevatedButton.icon(
                            clipBehavior: Clip.antiAlias,
                            onPressed: () => context.push(
                              AppRoute.studentVerificationPlacement.path,
                            ),
                            icon: const Icon(Icons.badge_outlined),
                            label: const Text('Verify with Documents'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),
                    Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? context.colors.border
                              : context.colors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Text(
                            'Get Verification Code from CR',

                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(fontWeight: .w600),
                          ),
                          const Text(
                            "Connect with your class representative",
                            style: TextStyle(fontWeight: .w100),
                          ),
                          const SizedBox(height: Spacing.lg),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.push(AppRoute.contactWithCR.path);
                            },
                            icon: Icon(
                              Icons.play_circle_fill_outlined,
                              color: context.colors.success,
                            ),
                            label: Text(
                              'Contact With CR/Moderator',
                              style: const TextStyle(
                                letterSpacing: .5,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),
                    Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? context.colors.border
                              : context.colors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Text(
                            'Register with Social Media',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(fontWeight: .w600),
                          ),
                          const Text(
                            "Message on Facebook or WhatsApp ",
                            style: TextStyle(fontWeight: .w100),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            "Requirements:",
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(
                                  color: context.colors.warning,
                                  letterSpacing: .4,
                                  fontWeight: .bold,
                                ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          const Text(
                            "1. Full Name (as per certificate)."
                            "\n2. University, Department & Student ID."
                            "\n3. Photo of Student ID (Clear photo).",
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(height: Spacing.lg),
                          const Text(
                            "We will register your email as soon as possible.",
                          ),
                          const SizedBox(height: Spacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    OpenApp.withUrl(kFbGroup);
                                  },
                                  icon: Icon(
                                    Icons.facebook_outlined,
                                    color: context.colors.info,
                                  ),
                                  label: const Text(
                                    'Facebook',
                                    style: TextStyle(
                                      letterSpacing: .5,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    OpenApp.withUrl(kRegistrationWhatsAppUrl);
                                  },
                                  icon: Icon(
                                    Icons.chat_outlined,
                                    color: context.colors.success,
                                  ),
                                  label: const Text(
                                    'WhatsApp',
                                    style: TextStyle(
                                      letterSpacing: .5,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else
                    _teacherStaffCard(context),
                  const SizedBox(height: Spacing.xxl),
                  Text(
                    'Contact the developer',
                    textAlign: .center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(fontWeight: .w600),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(RadiusToken.xl),
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
                      crossAxisAlignment: .center,
                      children: [
                        Container(
                          height: 88,
                          width: 88,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.primarySubtle,
                          ),
                          child: const ClipOval(
                            child: Image(
                              image: AssetImage('assets/images/reyad.jpg'),
                              fit: .cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Text(
                          kDeveloperName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
                        ),
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          'UI/UX Designer, App Developer',
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Wrap(
                          alignment: .center,
                          spacing: Spacing.sm,
                          runSpacing: Spacing.xs,
                          children: [
                            _Chip(
                              label: kDeveloperBatch,
                              background: context.colors.warningSubtle,
                              foreground: context.colors.warning,
                            ),
                            _Chip(
                              label: kDeveloperSession,
                              background: context.colors.successSubtle,
                              foreground: context.colors.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          'Department of Psychology',
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                        Text(
                          'University of Chittagong',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(fontWeight: .bold),
                        ),
                        const SizedBox(height: Spacing.lg),
                        const Divider(),
                        const SizedBox(height: Spacing.md),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            _ContactIconButton(
                              icon: Icons.call_outlined,
                              color: context.colors.success,
                              onTap: () => OpenApp.withNumber(kDeveloperMobile),
                            ),
                            const SizedBox(width: Spacing.md),
                            _ContactIconButton(
                              icon: Icons.mail_outline,
                              color: context.colors.danger,
                              onTap: () => OpenApp.withEmail(kAppEmail),
                            ),
                            const SizedBox(width: Spacing.md),
                            _ContactIconButton(
                              icon: Icons.facebook_outlined,
                              color: context.colors.info,
                              onTap: () => OpenApp.withUrl(kDeveloperFb),
                            ),
                            const SizedBox(width: Spacing.md),
                            _ContactIconButton(
                              icon: Icons.chat_outlined,
                              color: context.colors.success,
                              onTap: () =>
                                  OpenApp.withUrl(kRegistrationWhatsAppUrl),
                            ),
                          ],
                        ),
                      ],
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

class _Chip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.xs),
        color: background,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: FontSizeToken.sm,
          fontWeight: .w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _ContactIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      minWidth: 40,
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(Spacing.md),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class ContactWithCR extends ConsumerStatefulWidget {
  const ContactWithCR({super.key});

  @override
  ConsumerState<ContactWithCR> createState() => _ContactWithCRState();
}

class _ContactWithCRState extends ConsumerState<ContactWithCR> {
  String? _selectedUniversityId;
  String? _selectedUniversityName;
  String? _selectedDepartmentId;
  String? _selectedDepartmentName;
  String? _selectedBatchId;
  String? _selectedBatchName;

  Widget _actionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 14, color: color),
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
      ),
    );
  }

  List<({String id, String name})> _sortedPickerItems(
    Iterable<({String id, String name})> items,
  ) {
    final list = items.toList();
    list.sort((a, b) {
      final an = int.tryParse(
        RegExp(r'\d+').firstMatch(a.name)?.group(0) ?? '',
      );
      final bn = int.tryParse(
        RegExp(r'\d+').firstMatch(b.name)?.group(0) ?? '',
      );
      if (an != null && bn != null) return bn.compareTo(an);
      return b.name.compareTo(a.name);
    });
    return list;
  }

  Widget _pickerOptionTile({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                overflow: .ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? .w600 : .normal,
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.text,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: context.colors.primary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showPickerSheet({
    required String title,
    required String searchHint,
    required String notFoundWhat,
    required List<({String id, String name})> items,
    required String? selectedId,
    required void Function(String id, String name) onSelected,
    bool asGrid = false,
  }) {
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = searchText.isEmpty
                ? items
                : items
                      .where(
                        (i) => i.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.md),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.colors.borderStrong,
                          borderRadius: BorderRadius.circular(RadiusToken.xs),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xl,
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: FontSizeToken.xl,
                              fontWeight: .bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              LucideIcons.x,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xl,
                      ),
                      child: InlineSearchBar(
                        hintText: searchHint,
                        onChanged: (v) => setSheetState(() => searchText = v),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Expanded(
                      child: filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.xl,
                              ),
                              child: NotAddedNotice(what: notFoundWhat),
                            )
                          : asGrid
                          ? GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.xl,
                                0,
                                Spacing.xl,
                                Spacing.xl,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: Spacing.sm,
                                    crossAxisSpacing: Spacing.sm,
                                    childAspectRatio: 3.2,
                                  ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = item.id == selectedId;
                                return _pickerOptionTile(
                                  name: item.name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    onSelected(item.id, item.name);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.xl,
                                0,
                                Spacing.xl,
                                Spacing.xl,
                              ),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: Spacing.xs),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = item.id == selectedId;
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      RadiusToken.md,
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? context.colors.primary
                                          : context.colors.border,
                                    ),
                                  ),
                                  title: Text(item.name),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: context.colors.primary,
                                          size: 18,
                                        )
                                      : null,
                                  onTap: () {
                                    onSelected(item.id, item.name);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _pickerField({
    required String label,
    required String? value,
    required VoidCallback onTap,
    bool enabled = true,
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: (enabled && !loading) ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? Theme.of(context).cardColor
              : context.colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                overflow: .ellipsis,
                style: TextStyle(
                  color: !enabled
                      ? context.colors.textSubtle
                      : value == null
                      ? context.colors.textSubtle
                      : context.colors.text,
                  fontWeight: value == null ? .normal : .w600,
                ),
              ),
            ),
            if (loading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.textMuted,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: context.colors.textMuted,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final universitiesAsync = ref.watch(allUniversitiesProvider);

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
          title: Text(
            'Contact with CR/Moderator',
            style: TextStyle(
              fontWeight: .bold,
              color: context.colors.onPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxxl),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .3
                    : Spacing.lg,
                vertical: Spacing.xl,
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  universitiesAsync.when(
                    data: (universities) => _pickerField(
                      label: 'Select your university',
                      value: _selectedUniversityName,
                      onTap: () => _showPickerSheet(
                        title: 'Select University',
                        searchHint: 'Search university...',
                        notFoundWhat: 'your university',
                        items: universities
                            .map((u) => (id: u.id, name: u.name))
                            .toList(),
                        selectedId: _selectedUniversityId,
                        onSelected: (id, name) {
                          setState(() {
                            _selectedUniversityId = id;
                            _selectedUniversityName = name;
                            _selectedDepartmentId = null;
                            _selectedDepartmentName = null;
                            _selectedBatchId = null;
                            _selectedBatchName = null;
                          });
                        },
                      ),
                    ),
                    loading: () => _pickerField(
                      label: 'Select your university',
                      value: null,
                      enabled: false,
                      loading: true,
                      onTap: () {},
                    ),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: Spacing.sm),
                  _selectedUniversityId == null
                      ? _pickerField(
                          label: 'Select your department',
                          value: null,
                          enabled: false,
                          onTap: () {},
                        )
                      : ref
                            .watch(
                              departmentsByUniversityProvider(
                                _selectedUniversityId!,
                              ),
                            )
                            .when(
                              data: (departments) => _pickerField(
                                label: 'Select your department',
                                value: _selectedDepartmentName,
                                onTap: () => _showPickerSheet(
                                  title: 'Select Department',
                                  searchHint: 'Search department...',
                                  notFoundWhat: 'your department',
                                  items: departments
                                      .map((d) => (id: d.id, name: d.name))
                                      .toList(),
                                  selectedId: _selectedDepartmentId,
                                  onSelected: (id, name) {
                                    setState(() {
                                      _selectedDepartmentId = id;
                                      _selectedDepartmentName = name;
                                      _selectedBatchId = null;
                                      _selectedBatchName = null;
                                    });
                                  },
                                ),
                              ),
                              loading: () => _pickerField(
                                label: 'Select your department',
                                value: null,
                                enabled: false,
                                loading: true,
                                onTap: () {},
                              ),
                              error: (e, _) => Text('Error: $e'),
                            ),
                  const SizedBox(height: Spacing.sm),
                  _selectedDepartmentId == null
                      ? _pickerField(
                          label: 'Select your batch',
                          value: null,
                          enabled: false,
                          onTap: () {},
                        )
                      : ref
                            .watch(
                              new_batch.batchesByDepartmentProvider(
                                _selectedDepartmentId!,
                              ),
                            )
                            .when(
                              data: (batches) => _pickerField(
                                label: 'Select your batch',
                                value: _selectedBatchName,
                                onTap: () => _showPickerSheet(
                                  title: 'Select Batch',
                                  searchHint: 'Search batch...',
                                  notFoundWhat: 'your batch',
                                  asGrid: true,
                                  items: _sortedPickerItems(
                                    batches.map(
                                      (b) => (id: b.id, name: b.name),
                                    ),
                                  ),
                                  selectedId: _selectedBatchId,
                                  onSelected: (id, name) {
                                    setState(() {
                                      _selectedBatchId = id;
                                      _selectedBatchName = name;
                                    });
                                  },
                                ),
                              ),
                              loading: () => _pickerField(
                                label: 'Select your batch',
                                value: null,
                                enabled: false,
                                loading: true,
                                onTap: () {},
                              ),
                              error: (e, _) => Text('Error: $e'),
                            ),
                  const SizedBox(height: Spacing.xxl),
                  Text(
                    'CR/Moderator List',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
                  ),
                  SizedBox(height: Spacing.sm),
                  const Divider(),
                  SizedBox(height: Spacing.sm),

                  if (_selectedDepartmentId != null)
                    ref
                        .watch(
                          crsByDepartmentAdminProvider((
                            universityId: _selectedUniversityId!,
                            departmentId: _selectedDepartmentId!,
                          )),
                        )
                        .when(
                          data: (allCrs) {
                            final crs = allCrs
                                .where(
                                  (c) =>
                                      c.isCurrent &&
                                      (_selectedBatchId == null ||
                                          c.batchId == _selectedBatchId),
                                )
                                .toList();

                            if (crs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Spacing.lg,
                                ),
                                child: Text('No CR/Moderator found!'),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: crs.length,
                              itemBuilder: (context, index) {
                                final cr = crs[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: context.colors.surface,
                                    borderRadius: BorderRadius.circular(
                                      RadiusToken.md,
                                    ),
                                    border: Border.all(
                                      color: context.colors.border,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.colors.shadow,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Spacing.md),
                                    child: Row(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              RadiusToken.md,
                                            ),
                                            border: Border.all(
                                              color: context.colors.surfaceAlt,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              RadiusToken.sm,
                                            ),
                                            child: cr.imageUrl.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        ApiEndpoints.resolveImageUrl(
                                                          cr.imageUrl,
                                                        ),
                                                    fit: .cover,
                                                    placeholder: (_, _) =>
                                                        const Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                                radius: 6,
                                                              ),
                                                        ),
                                                    errorWidget: (_, _, _) =>
                                                        Icon(
                                                          LucideIcons.user,
                                                          color: context
                                                              .colors
                                                              .borderStrong,
                                                          size: 24,
                                                        ),
                                                  )
                                                : Image.asset(
                                                    'assets/images/pp_placeholder.png',
                                                    fit: .cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: Spacing.md),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              Text(
                                                cr.name,
                                                maxLines: 1,
                                                overflow: .ellipsis,
                                                style: TextStyle(
                                                  fontWeight: .w700,
                                                  fontSize: FontSizeToken.base,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: Spacing.xs,
                                              ),
                                              Wrap(
                                                spacing: Spacing.xs,
                                                runSpacing: Spacing.xs,
                                                children: [
                                                  if (cr.batch.isNotEmpty)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal:
                                                                Spacing.sm,
                                                            vertical:
                                                                Spacing.xxs,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: context
                                                            .colors
                                                            .surfaceAlt,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              RadiusToken.sm,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        cr.batch,
                                                        style: TextStyle(
                                                          color: context
                                                              .colors
                                                              .textMuted,
                                                          fontSize:
                                                              FontSizeToken.xxs,
                                                          fontWeight: .w600,
                                                        ),
                                                      ),
                                                    ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal:
                                                              Spacing.sm,
                                                          vertical: Spacing.xxs,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .colors
                                                          .primarySubtle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            RadiusToken.sm,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'CR',
                                                      style: TextStyle(
                                                        color: context
                                                            .colors
                                                            .primary,
                                                        fontSize:
                                                            FontSizeToken.xxs,
                                                        fontWeight: .w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (cr.phone.isNotEmpty) ...[
                                                const SizedBox(
                                                  height: Spacing.sm,
                                                ),
                                                Row(
                                                  children: [
                                                    _actionChip(
                                                      icon: Icons.call_outlined,
                                                      label: 'Call',
                                                      color: context
                                                          .colors
                                                          .success,
                                                      onTap: () =>
                                                          OpenApp.withNumber(
                                                            cr.phone,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      width: Spacing.sm,
                                                    ),
                                                    _actionChip(
                                                      icon: Icons.sms_outlined,
                                                      label: 'Message',
                                                      color:
                                                          context.colors.info,
                                                      onTap: () =>
                                                          OpenApp.withSms(
                                                            cr.phone,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Spacing.sm),
                            );
                          },
                          loading: () =>
                              const Center(child: CupertinoActivityIndicator()),
                          error: (e, _) => Text('Error: $e'),
                        )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: Spacing.lg),
                      child: Text(
                        'Select University and Department to see CRs',
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
