import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/cache/cache_manager.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/tokens/app_radius.dart';

class CacheManagementPage extends ConsumerStatefulWidget {
  const CacheManagementPage({super.key});

  @override
  ConsumerState<CacheManagementPage> createState() =>
      _CacheManagementPageState();
}

class _CacheManagementPageState extends ConsumerState<CacheManagementPage> {
  List<CacheStat>? _stats;
  bool _loading = true;
  bool _clearing = false;
  String? _error;
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final manager = ref.read(cacheManagerProvider);
      final stats = await manager.getStats();
      setState(() {
        _stats = stats;
        _error = null;
        _loading = false;
        _selected.clear();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _clearEntity(String entityType) async {
    setState(() => _clearing = true);
    try {
      final db = ref.read(offlineDatabaseProvider);
      await db.clearEntityCache(entityType);
      await _loadStats();
    } finally {
      if (mounted) setState(() => _clearing = false);
    }
  }

  Future<void> _clearSelected() async {
    setState(() => _clearing = true);
    try {
      final db = ref.read(offlineDatabaseProvider);
      for (final key in _selected) {
        await db.clearEntityCache(key);
      }
      await _loadStats();
    } finally {
      if (mounted) setState(() => _clearing = false);
    }
  }

  Future<void> _clearAll() async {
    setState(() => _clearing = true);
    try {
      final manager = ref.read(cacheManagerProvider);
      await manager.clearAll();
      await _loadStats();
    } finally {
      if (mounted) setState(() => _clearing = false);
    }
  }

  void _toggleSelection(String entityType) {
    setState(() {
      if (_selected.contains(entityType)) {
        _selected.remove(entityType);
      } else {
        _selected.add(entityType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasSelection = _selected.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(hasSelection ? '${_selected.length} selected' : 'Manage Cache'),
        actions: [
          if (_stats != null && _stats!.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  if (_selected.length == _stats!.length) {
                    _selected.clear();
                  } else {
                    _selected.addAll(_stats!.map((s) => s.entityType));
                  }
                });
              },
              icon: Icon(
                _selected.length == (_stats?.length ?? 0)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              tooltip: _selected.length == (_stats?.length ?? 0)
                  ? 'Deselect All'
                  : 'Select All',
            ),
        ],
      ),
      body: Stack(
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Failed to load cache: $_error'))
                  : _stats == null || _stats!.isEmpty
                      ? const Center(child: Text('No cached data'))
                      : _buildContent(isDark, hasSelection),
          if (_clearing)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: hasSelection
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _clearing
                        ? null
                        : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Clear ${_selected.length} Items'),
                          content: const Text(
                            'This will remove the selected cached data. '
                            'It will be re-fetched when needed.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) await _clearSelected();
                    },
                    icon: const Icon(LucideIcons.trash2, size: 18),
                    label: Text('Clear Selected (${_selected.length})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildContent(bool isDark, bool hasSelection) {
    final totalEntries = _stats!.fold<int>(0, (sum, s) => sum + s.entryCount);
    final totalBytes = _stats!.fold<int>(0, (sum, s) => sum + s.totalBytes);
    final formattedTotal = CacheStat(entityType: '', entryCount: 0, totalBytes: totalBytes).formattedSize;

    return RefreshIndicator(
      onRefresh: _loadStats,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(isDark, totalEntries, formattedTotal),
          const SizedBox(height: 16),
          for (final stat in _stats!) _buildEntityCard(isDark, stat),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _clearing
                  ? null
                  : () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All Cache'),
                    content: const Text(
                      'This will remove all cached data. It will be re-fetched when needed.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await _clearAll();
              },
              icon: const Icon(LucideIcons.trash2, size: 18),
              label: const Text('Clear All Cache'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark, int totalEntries, String formattedTotal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(LucideIcons.database, '$totalEntries', 'Entries'),
          Container(
            height: 40,
            width: 1,
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
          _summaryItem(LucideIcons.hardDrive, formattedTotal, 'Data Stored'),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildEntityCard(bool isDark, CacheStat stat) {
    final icon = _iconForType(stat.entityType);
    final name = _displayName(stat.entityType);
    final selected = _selected.contains(stat.entityType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _toggleSelection(stat.entityType),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05))
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            border: Border.all(
              color: selected
                  ? Colors.blue
                  : (isDark ? Colors.white10 : Colors.grey.shade200),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: selected ? Colors.blue : Colors.grey,
            ),
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: selected ? Colors.blue : null,
              ),
            ),
            subtitle: Text(
              '${stat.entryCount} entries · ${stat.formattedSize}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            trailing: selected
                ? const Icon(LucideIcons.checkCircle, color: Colors.blue, size: 22)
                : SizedBox(
                    height: 32,
                    child: TextButton(
                      onPressed: _clearing ? null : () => _clearEntity(stat.entityType),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Clear', style: TextStyle(fontSize: 12)),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _displayName(String entityType) {
    if (entityType.startsWith('student_user_')) return 'Student Profile';
    if (entityType == 'student_detail') return 'Student Detail';
    if (entityType.startsWith('student_')) return 'Students';
    if (entityType.startsWith('hall_')) return 'Halls';
    if (entityType.startsWith('batch_')) return 'Batches';
    if (entityType.startsWith('session_')) return 'Sessions';
    if (entityType.startsWith('departments_')) return 'Departments';
    if (entityType.startsWith('notice_')) return 'Notices';
    if (entityType.startsWith('resource_')) return 'Resources';
    if (entityType.startsWith('course_')) return 'Courses';
    if (entityType == 'course_detail') return 'Course Detail';
    if (entityType.startsWith('subject_')) return 'Subjects';
    if (entityType.startsWith('routine_')) return 'Routines';
    if (entityType.startsWith('exam_')) return 'Exams';
    if (entityType == 'banners_admin') return 'Admin Banners';
    if (entityType.startsWith('banner')) return 'Banners';
    if (entityType == 'all_universities') return 'Universities';
    if (entityType.startsWith('syllabus_')) return 'Syllabi';
    if (entityType.startsWith('chapter_')) return 'Chapters';
    if (entityType.startsWith('teacher_')) return 'Teachers';
    if (entityType == 'teacher_detail') return 'Teacher Detail';
    if (entityType.startsWith('emergency_')) return 'Emergency Contacts';
    if (entityType.startsWith('community_')) return 'Community Posts';
    if (entityType.startsWith('bookmark_')) return 'Bookmarks';
    if (entityType.startsWith('transport_')) return 'Transport';
    if (entityType.startsWith('semester_')) return 'Semesters';
    if (entityType.startsWith('club_')) return 'Clubs';
    if (entityType == 'profile') return 'User Profile';
    return entityType;
  }

  IconData _iconForType(String type) {
    if (type.startsWith('banner')) return LucideIcons.image;
    if (type.startsWith('notice_')) return LucideIcons.megaphone;
    if (type.startsWith('resource_')) return LucideIcons.fileText;
    if (type.startsWith('departments_')) return LucideIcons.building2;
    if (type.startsWith('student_')) return LucideIcons.graduationCap;
    if (type.startsWith('hall_')) return LucideIcons.home;
    if (type.startsWith('batch_')) return LucideIcons.users;
    if (type.startsWith('session_')) return LucideIcons.calendar;
    if (type.startsWith('course_') || type.startsWith('subject_')) {
      return LucideIcons.bookOpen;
    }
    if (type.startsWith('routine_')) return LucideIcons.calendar;
    if (type.startsWith('exam_')) return LucideIcons.scrollText;
    if (type.startsWith('all_universities') || type.startsWith('university')) {
      return LucideIcons.landmark;
    }
    if (type.startsWith('syllabus_')) return LucideIcons.fileText;
    if (type.startsWith('chapter_')) return LucideIcons.bookMarked;
    if (type.startsWith('teacher_')) return LucideIcons.user;
    if (type.startsWith('emergency_')) return LucideIcons.phoneCall;
    if (type.startsWith('community_')) return LucideIcons.messageCircle;
    if (type.startsWith('bookmark_')) return LucideIcons.bookmark;
    if (type.startsWith('transport_')) return LucideIcons.bus;
    if (type.startsWith('semester_')) return LucideIcons.calendarDays;
    if (type.startsWith('club_')) return LucideIcons.heart;
    if (type == 'profile') return LucideIcons.user;
    return LucideIcons.archive;
  }
}
