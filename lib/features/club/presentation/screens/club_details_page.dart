import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/club/data/models/club_event.dart';
import '/features/club/data/models/club_post.dart';
import '/features/club/data/models/club_user_summary.dart';
import '/features/club/domain/entities/club.dart';
import '/features/club/presentation/providers/club_event_provider.dart';
import '/features/club/presentation/providers/club_management_provider.dart';
import '/features/club/presentation/providers/club_provider.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

/// [club], if provided (a list-card tap), is rendered immediately with no
/// network round-trip. If null (a deep link, e.g. a club-event push
/// notification tap), the club is fetched by [clubId] instead.
class ClubDetailsPage extends ConsumerWidget {
  final String clubId;
  final Club? club;

  const ClubDetailsPage({super.key, required this.clubId, this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final club = this.club;
    if (club != null) return _ClubDetailsView(club: club);

    final clubAsync = ref.watch(clubByIdProvider(clubId));
    return clubAsync.when(
      data: (club) => _ClubDetailsView(club: club),
      loading: () => const CustomHeaderLayout(
        title: 'Club Details',
        showSearchBar: false,
        body: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => const CustomHeaderLayout(
        title: 'Club Details',
        showSearchBar: false,
        body: Center(child: Text('Club not found.')),
      ),
    );
  }
}

class _ClubDetailsView extends ConsumerStatefulWidget {
  final Club club;

  const _ClubDetailsView({required this.club});

  @override
  ConsumerState<_ClubDetailsView> createState() => _ClubDetailsViewState();
}

class _ClubDetailsViewState extends ConsumerState<_ClubDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 5,
    vsync: this,
  );

  late bool isFollowing = widget.club.isFollowing;
  late int followersCount = widget.club.followersCount;
  bool _followPending = false;

  late bool isMember = widget.club.isMember;
  late int membersCount = widget.club.membersCount;
  bool _memberPending = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow() async {
    if (_followPending) return;
    setState(() {
      _followPending = true;
      isFollowing = !isFollowing;
      followersCount += isFollowing ? 1 : -1;
    });
    try {
      if (isFollowing) {
        await followClub(ref, widget.club.id);
      } else {
        await unfollowClub(ref, widget.club.id);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isFollowing = !isFollowing;
        followersCount += isFollowing ? 1 : -1;
      });
      Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _followPending = false);
    }
  }

  Future<void> _toggleMembership() async {
    if (_memberPending) return;
    setState(() {
      _memberPending = true;
      isMember = !isMember;
      membersCount += isMember ? 1 : -1;
    });
    try {
      if (isMember) {
        await joinClub(ref, widget.club.id);
      } else {
        await leaveClub(ref, widget.club.id);
      }
      ref.invalidate(clubMembersProvider(widget.club.id));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isMember = !isMember;
        membersCount += isMember ? 1 : -1;
      });
      Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _memberPending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final club = widget.club;

    return CustomHeaderLayout(
      title: 'Club Details',
      showSearchBar: false,
      body: Column(
        children: [
          if (club.bannerUrl != null && club.bannerUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              child: CachedNetworkImage(
                imageUrl: ApiEndpoints.resolveImageUrl(club.bannerUrl),
                height: 160,
                width: double.infinity,
                fit: .cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              0,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceAlt,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.border, width: 2),
                  ),
                  child: club.logoUrl != null && club.logoUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.xxxl),
                          child: CachedNetworkImage(
                            imageUrl: ApiEndpoints.resolveImageUrl(
                              club.logoUrl,
                            ),
                            fit: .cover,
                          ),
                        )
                      : Icon(Icons.groups, color: context.colors.textSubtle),
                ),
                const SizedBox(width: Spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              club.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: .bold),
                            ),
                          ),
                          if (club.isVerified) ...[
                            const SizedBox(width: Spacing.sm),
                            Icon(
                              Icons.verified,
                              size: 18,
                              color: context.colors.info,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        [
                          if (club.foundedYear != null)
                            'Founded ${club.foundedYear}',
                          '$followersCount following',
                          '$membersCount members',
                        ].join(' · '),
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.md,
              Spacing.lg,
              Spacing.sm,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _followPending ? null : _toggleFollow,
                icon: Icon(
                  isFollowing ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFollowing
                      ? AccentToken.pink
                      : Theme.of(context).primaryColor,
                ),
                label: Text(isFollowing ? 'Following' : 'Follow'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isFollowing
                      ? AccentToken.pink
                      : Theme.of(context).primaryColor,
                  side: BorderSide(
                    color: isFollowing
                        ? AccentToken.pink
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              0,
              Spacing.lg,
              Spacing.sm,
            ),
            child: SectionTabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Contact'),
                Tab(text: 'Members'),
                Tab(text: 'Events'),
                Tab(text: 'Notifications'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AboutTab(club: club),
                _ContactTab(club: club),
                _MembersTab(
                  club: club,
                  isMember: isMember,
                  memberPending: _memberPending,
                  onToggleMembership: _toggleMembership,
                ),
                _EventsTab(clubId: club.id),
                _NotificationsTab(clubId: club.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Club club;

  const _AboutTab({required this.club});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Text(
          club.description.isEmpty ? 'No description yet.' : club.description,
          style: TextStyle(
            fontSize: FontSizeToken.base,
            height: 1.5,
            color: context.colors.textMuted,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        _InfoRow(
          icon: Icons.category_outlined,
          label: 'Category',
          value: (club.category?.isEmpty ?? true)
              ? 'Uncategorized'
              : club.category!,
        ),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Founded',
          value: club.foundedYear?.toString() ?? 'N/A',
        ),
        _InfoRow(
          icon: Icons.corporate_fare,
          label: 'Scope',
          value: club.clubType == 'university'
              ? 'University-wide'
              : 'Department Club',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: Spacing.md),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: FontSizeToken.md,
              color: context.colors.textMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizeToken.md,
              fontWeight: .w600,
              color: context.colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTab extends StatelessWidget {
  final Club club;

  const _ContactTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final hasContact =
        club.contactPhone != null ||
        club.contactEmail != null ||
        (club.socialLinks != null && club.socialLinks!.isNotEmpty);

    if (!hasContact) {
      return Center(
        child: Text(
          'No contact information provided.',
          style: TextStyle(color: context.colors.textMuted),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        if (club.contactPhone != null)
          _buildContactRow(
            context,
            Icons.phone_rounded,
            club.contactPhone!,
            () => OpenApp.withNumber(club.contactPhone!),
          ),
        if (club.contactEmail != null)
          _buildContactRow(
            context,
            Icons.email_rounded,
            club.contactEmail!,
            () => OpenApp.withEmail(club.contactEmail!),
          ),
        if (club.socialLinks != null)
          ...club.socialLinks!.entries.map(
            (e) => _buildSocialRow(context, e.key, e.value.toString()),
          ),
      ],
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: FontSizeToken.base,
                  decoration: .underline,
                  color: context.colors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialRow(BuildContext context, String platform, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: GestureDetector(
        onTap: () => OpenApp.withUrl(value),
        child: Row(
          children: [
            Icon(
              Icons.link_rounded,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                '$platform: $value',
                style: TextStyle(
                  fontSize: FontSizeToken.base,
                  decoration: .underline,
                  color: context.colors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MembersTab extends ConsumerWidget {
  final Club club;
  final bool isMember;
  final bool memberPending;
  final VoidCallback onToggleMembership;

  const _MembersTab({
    required this.club,
    required this.isMember,
    required this.memberPending,
    required this.onToggleMembership,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(clubMembersProvider(club.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: memberPending ? null : onToggleMembership,
            icon: Icon(
              isMember ? Icons.check_circle : Icons.group_add,
              size: 18,
            ),
            label: Text(isMember ? 'Joined' : 'Join Club'),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        membersAsync.when(
          data: (members) {
            if (members.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
                  child: Text(
                    'No members yet — be the first to join!',
                    style: TextStyle(color: context.colors.textMuted),
                  ),
                ),
              );
            }
            return Column(
              children: members
                  .map((m) => _MemberRow(member: m, isDark: isDark))
                  .toList(growable: false),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final ClubUserSummary member;
  final bool isDark;

  const _MemberRow({required this.member, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: member.avatarUrl.isNotEmpty
            ? NetworkImage(ApiEndpoints.resolveImageUrl(member.avatarUrl))
            : null,
        child: member.avatarUrl.isEmpty
            ? Text(member.fullName.isNotEmpty ? member.fullName[0] : '?')
            : null,
      ),
      title: Text(
        member.fullName.isEmpty ? 'Member' : member.fullName,
        style: TextStyle(color: context.colors.text),
      ),
    );
  }
}

class _EventsTab extends ConsumerWidget {
  final String clubId;

  const _EventsTab({required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(clubEventsProvider(clubId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Text(
              'No upcoming events.',
              style: TextStyle(color: context.colors.textMuted),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: events
              .map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.md),
                  child: _EventCard(event: event, isDark: isDark),
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (_, _) => Center(
        child: Text(
          'Failed to load events.',
          style: TextStyle(color: context.colors.textMuted),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final ClubEvent event;
  final bool isDark;

  const _EventCard({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('MMM').format(event.startAt).toUpperCase(),
                  style: TextStyle(
                    fontSize: FontSizeToken.xxs,
                    fontWeight: .bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('d').format(event.startAt),
                  style: TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: .bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.base,
                    color: context.colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  DateFormat('MMM d, h:mm a').format(event.startAt),
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textMuted,
                  ),
                ),
                if (event.location.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.xxs),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 12,
                          color: context.colors.textMuted,
                        ),
                        const SizedBox(width: Spacing.xxs),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              color: context.colors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsTab extends ConsumerWidget {
  final String clubId;

  const _NotificationsTab({required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(clubPostsProvider(clubId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text(
              'No updates posted yet.',
              style: TextStyle(color: context.colors.textMuted),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(Spacing.lg),
          itemCount: posts.length,
          separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
          itemBuilder: (context, i) =>
              _PostCard(post: posts[i], isDark: isDark),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (_, _) => Center(
        child: Text(
          'Failed to load updates.',
          style: TextStyle(color: context.colors.textMuted),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final ClubPost post;
  final bool isDark;

  const _PostCard({required this.post, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  post.title,
                  style: TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.base,
                    color: context.colors.text,
                  ),
                ),
              ),
              Text(
                DateFormat('MMM d').format(post.createdAt),
                style: TextStyle(
                  fontSize: FontSizeToken.xs,
                  color: context.colors.textSubtle,
                ),
              ),
            ],
          ),
          if (post.body.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              post.body,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                height: 1.4,
                color: context.colors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
