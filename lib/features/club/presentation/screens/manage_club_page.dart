import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '/core/di.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/club/data/models/club_event.dart';
import '/features/club/data/models/club_user_summary.dart';
import '/features/club/domain/entities/club.dart';
import '/features/club/presentation/providers/club_event_provider.dart';
import '/features/club/presentation/providers/club_management_provider.dart';
import '/features/club/presentation/providers/club_provider.dart';
import '/features/club/presentation/widgets/contact_admin_banner.dart';
import 'suggest_club_page.dart' show clubCategories;
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Self-service club management: a club's owner/manager edits its info and
/// posts events/updates from here, no admin panel needed. Gated server-side
/// by ClubManager role — this screen assumes the caller has access (reached
/// only from "My Clubs", which only lists clubs the user manages).
class ManageClubPage extends ConsumerStatefulWidget {
  final String clubId;

  const ManageClubPage({super.key, required this.clubId});

  @override
  ConsumerState<ManageClubPage> createState() => _ManageClubPageState();
}

class _ManageClubPageState extends ConsumerState<ManageClubPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubAsync = ref.watch(clubByIdProvider(widget.clubId));

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              clubAsync.maybeWhen(data: (c) => c.name, orElse: () => null) ??
                  'Manage Club',
              overflow: .ellipsis,
            ),
          ),
          body: clubAsync.when(
            data: (club) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.md,
                    Spacing.lg,
                    Spacing.sm,
                  ),
                  child: SectionTabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Events'),
                      Tab(text: 'Posts'),
                      Tab(text: 'Managers'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _InfoTab(club: club),
                      _EventsTab(clubId: club.id),
                      _PostsTab(clubId: club.id),
                      _ManagersTab(clubId: club.id),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Info tab
// ---------------------------------------------------------------------

class _InfoTab extends ConsumerStatefulWidget {
  final Club club;

  const _InfoTab({required this.club});

  @override
  ConsumerState<_InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends ConsumerState<_InfoTab> {
  late final _nameController = TextEditingController(text: widget.club.name);
  late final _descriptionController = TextEditingController(
    text: widget.club.description,
  );
  late final _foundedYearController = TextEditingController(
    text: widget.club.foundedYear?.toString() ?? '',
  );
  late final _contactEmailController = TextEditingController(
    text: widget.club.contactEmail ?? '',
  );
  late final _contactPhoneController = TextEditingController(
    text: widget.club.contactPhone ?? '',
  );
  late final _facebookController = TextEditingController(
    text: widget.club.socialLinks?['facebook']?.toString() ?? '',
  );
  late final _instagramController = TextEditingController(
    text: widget.club.socialLinks?['instagram']?.toString() ?? '',
  );
  late final _linkedinController = TextEditingController(
    text: widget.club.socialLinks?['linkedin']?.toString() ?? '',
  );

  late String? _category = widget.club.category?.isEmpty ?? true
      ? null
      : widget.club.category;
  File? _logoFile;
  File? _bannerFile;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _foundedYearController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isLogo) {
        _logoFile = File(picked.path);
      } else {
        _bannerFile = File(picked.path);
      }
    });
  }

  Future<String?> _uploadIfPicked(File? file) async {
    if (file == null) return null;
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.uploadFile(
      '/upload',
      filePath: file.path,
      fieldName: 'image',
      data: {'folder': 'clubs'},
    );
    return response.data['file_url'] as String?;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final logoUrl = await _uploadIfPicked(_logoFile) ?? widget.club.logoUrl;
      final bannerUrl =
          await _uploadIfPicked(_bannerFile) ?? widget.club.bannerUrl;

      final socialLinks = <String, dynamic>{
        if (_facebookController.text.trim().isNotEmpty)
          'facebook': _facebookController.text.trim(),
        if (_instagramController.text.trim().isNotEmpty)
          'instagram': _instagramController.text.trim(),
        if (_linkedinController.text.trim().isNotEmpty)
          'linkedin': _linkedinController.text.trim(),
      };

      await updateMyClub(ref, widget.club.id, {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'logo_url': logoUrl,
        'banner_url': bannerUrl,
        'founded_year': int.tryParse(_foundedYearController.text.trim()),
        'category': _category,
        'contact_email': _contactEmailController.text.trim(),
        'contact_phone': _contactPhoneController.text.trim(),
        'social_links': socialLinks,
      });

      ref.invalidate(clubByIdProvider(widget.club.id));
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Saved');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to save changes');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        if (!widget.club.isActive) ...[
          const ContactAdminBanner(),
          const SizedBox(height: Spacing.md),
        ],
        Row(
          children: [
            Expanded(
              child: _ImageTile(
                label: 'Logo',
                file: _logoFile,
                existingUrl: widget.club.logoUrl,
                onTap: () => _pickImage(true),
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: _ImageTile(
                label: 'Banner',
                file: _bannerFile,
                existingUrl: widget.club.bannerUrl,
                onTap: () => _pickImage(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Club Name'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: Spacing.md),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'Category'),
          items: clubCategories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _category = v),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _foundedYearController,
          keyboardType: .number,
          decoration: const InputDecoration(labelText: 'Founded Year'),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          'Contact',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.sm),
        TextField(
          controller: _contactEmailController,
          decoration: const InputDecoration(labelText: 'Contact Email'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _contactPhoneController,
          decoration: const InputDecoration(labelText: 'Contact Phone'),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          'Social Links',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.sm),
        TextField(
          controller: _facebookController,
          decoration: const InputDecoration(labelText: 'Facebook'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _instagramController,
          decoration: const InputDecoration(labelText: 'Instagram'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _linkedinController,
          decoration: const InputDecoration(labelText: 'LinkedIn'),
        ),
        const SizedBox(height: Spacing.xl),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(),
          child: _saving
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CupertinoActivityIndicator(
                    color: context.colors.onPrimary,
                  ),
                )
              : const Text('Save changes'),
        ),
        const SizedBox(height: Spacing.xxxl),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String label;
  final File? file;
  final String? existingUrl;
  final VoidCallback onTap;

  const _ImageTile({
    required this.label,
    required this.file,
    required this.existingUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (file != null) {
      content = Image.file(file!, fit: .cover);
    } else if (existingUrl != null && existingUrl!.isNotEmpty) {
      content = CachedNetworkImage(
        imageUrl: ApiEndpoints.resolveImageUrl(existingUrl),
        fit: .cover,
      );
    } else {
      content = Icon(Icons.image, color: context.colors.textSubtle);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.borderStrong),
          color: context.colors.surfaceAlt,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              child: content,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(Spacing.xs),
                decoration: BoxDecoration(
                  color: context.colors.textMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 12,
                  color: context.colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Events tab
// ---------------------------------------------------------------------

class _EventsTab extends ConsumerStatefulWidget {
  final String clubId;

  const _EventsTab({required this.clubId});

  @override
  ConsumerState<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends ConsumerState<_EventsTab> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _startAt;
  bool _publishNow = false;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickStartAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _startAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty || _startAt == null) {
      Fluttertoast.showToast(msg: 'Title and start date/time are required.');
      return;
    }
    if (_publishNow) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Publish & Notify?'),
          content: const Text(
            'This will immediately push a notification to everyone '
            'following this club.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Publish'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _submitting = true);
    try {
      await createMyClubEvent(
        ref,
        widget.clubId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        startAt: _startAt!,
        isPublished: _publishNow,
      );
      ref.invalidate(clubEventsProvider(widget.clubId));
      if (!mounted) return;
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      setState(() {
        _startAt = null;
        _publishNow = false;
      });
      Fluttertoast.showToast(msg: 'Event added');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add event');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(clubEventsProvider(widget.clubId));

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(labelText: 'Location'),
        ),
        const SizedBox(height: Spacing.md),
        OutlinedButton.icon(
          onPressed: _pickStartAt,
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            _startAt == null
                ? 'Pick start date & time'
                : DateFormat('MMM d, yyyy · h:mm a').format(_startAt!),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Publish & notify followers'),
          subtitle: const Text('Cannot be undone once sent.'),
          value: _publishNow,
          onChanged: (v) => setState(() => _publishNow = v),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CupertinoActivityIndicator(),
                )
              : const Text('Add event'),
        ),
        const Divider(height: 32),
        Text(
          'Upcoming Published Events',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.sm),
        eventsAsync.when(
          data: (events) => events.isEmpty
              ? Text(
                  'No upcoming published events yet.',
                  style: TextStyle(color: context.colors.textMuted),
                )
              : Column(
                  children: events
                      .map((e) => _EventRow(event: e))
                      .toList(growable: false),
                ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: CupertinoActivityIndicator(),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  final ClubEvent event;

  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event),
      title: Text(event.title),
      subtitle: Text(DateFormat('MMM d, h:mm a').format(event.startAt)),
    );
  }
}

// ---------------------------------------------------------------------
// Posts tab
// ---------------------------------------------------------------------

class _PostsTab extends ConsumerStatefulWidget {
  final String clubId;

  const _PostsTab({required this.clubId});

  @override
  ConsumerState<_PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends ConsumerState<_PostsTab> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Title is required.');
      return;
    }
    setState(() => _submitting = true);
    try {
      await createClubPost(
        ref,
        widget.clubId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
      ref.invalidate(clubPostsProvider(widget.clubId));
      if (!mounted) return;
      _titleController.clear();
      _bodyController.clear();
      Fluttertoast.showToast(msg: 'Posted — followers notified.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to post');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(clubPostsProvider(widget.clubId));

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Text(
          'Posting here notifies every follower of this club immediately.',
          style: TextStyle(
            fontSize: FontSizeToken.sm,
            color: context.colors.textMuted,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _bodyController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Body',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: Spacing.md),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CupertinoActivityIndicator(),
                )
              : const Text('Post update'),
        ),
        const Divider(height: 32),
        postsAsync.when(
          data: (posts) => posts.isEmpty
              ? Text(
                  'No updates posted yet.',
                  style: TextStyle(color: context.colors.textMuted),
                )
              : Column(
                  children: posts
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.md),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.campaign_outlined),
                            title: Text(p.title),
                            subtitle: Text(
                              p.body,
                              maxLines: 2,
                              overflow: .ellipsis,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: CupertinoActivityIndicator(),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// Managers tab
// ---------------------------------------------------------------------

class _ManagersTab extends ConsumerStatefulWidget {
  final String clubId;

  const _ManagersTab({required this.clubId});

  @override
  ConsumerState<_ManagersTab> createState() => _ManagersTabState();
}

class _ManagersTabState extends ConsumerState<_ManagersTab> {
  List<ClubUserSummary>? _managers;
  List<ClubUserSummary>? _followers;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final managers = await getManagers(ref, widget.clubId);
      final followers = await getFollowersForPromotion(ref, widget.clubId);
      if (!mounted) return;
      setState(() {
        _managers = managers;
        _followers = followers;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load managers');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _promote(String userId) async {
    try {
      await promoteManager(ref, widget.clubId, userId, 'manager');
      Fluttertoast.showToast(msg: 'Promoted to manager');
      _load();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed — only the club owner can promote managers.',
      );
    }
  }

  Future<void> _remove(String userId) async {
    try {
      await removeManager(ref, widget.clubId, userId);
      Fluttertoast.showToast(msg: 'Removed');
      _load();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to remove manager');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final managers = _managers ?? [];
    final managerIds = managers.map((m) => m.userId).toSet();
    final promotable = (_followers ?? [])
        .where((f) => !managerIds.contains(f.userId))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Text(
          'Current Managers',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
        ),
        const SizedBox(height: Spacing.sm),
        if (managers.isEmpty)
          Text(
            'No managers yet.',
            style: TextStyle(color: context.colors.textMuted),
          )
        else
          ...managers.map(
            (m) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: m.avatarUrl.isNotEmpty
                    ? NetworkImage(ApiEndpoints.resolveImageUrl(m.avatarUrl))
                    : null,
                child: m.avatarUrl.isEmpty
                    ? Text(m.fullName.isNotEmpty ? m.fullName[0] : '?')
                    : null,
              ),
              title: Text(m.fullName),
              subtitle: Text(m.role),
              trailing: m.role == 'owner'
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _remove(m.userId),
                    ),
            ),
          ),
        const Divider(height: 32),
        Text(
          'Promote a Follower',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
        ),
        Text(
          'Only people already following this club can be promoted. '
          'Only the club owner can do this.',
          style: TextStyle(
            fontSize: FontSizeToken.sm,
            color: context.colors.textMuted,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        if (promotable.isEmpty)
          Text(
            'No eligible followers yet.',
            style: TextStyle(color: context.colors.textMuted),
          )
        else
          ...promotable.map(
            (f) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: f.avatarUrl.isNotEmpty
                    ? NetworkImage(ApiEndpoints.resolveImageUrl(f.avatarUrl))
                    : null,
                child: f.avatarUrl.isEmpty
                    ? Text(f.fullName.isNotEmpty ? f.fullName[0] : '?')
                    : null,
              ),
              title: Text(f.fullName),
              trailing: TextButton(
                onPressed: () => _promote(f.userId),
                child: const Text('Promote'),
              ),
            ),
          ),
      ],
    );
  }
}
