import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/app_network_image.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_card.dart';

/// One entry of the player's video list. Pass the whole list (skill or
/// course videos) through go_router `extra` so the player can step through it.
class YoutubePlaylistItem {
  final String videoId;
  final String title;

  const YoutubePlaylistItem({required this.videoId, required this.title});
}

/// Lesson-style player: the video stays pinned at the top while the info and
/// the list of videos scroll beneath it, and picking a video swaps it in place.
class YoutubePlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  /// Optional: the list this video belongs to. Shown under the player, and
  /// playback moves on to the next entry when a video ends.
  final List<YoutubePlaylistItem> playlist;

  const YoutubePlayerPage({
    super.key,
    required this.videoId,
    this.title = 'Video Player',
    this.playlist = const [],
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late final YoutubePlayerController _controller;
  late final StreamSubscription<YoutubePlayerValue> _sub;
  late String _videoId = widget.videoId;
  late String _title = widget.title;
  PlayerState _lastState = PlayerState.unknown;

  /// Finished this session — ticked in the list.
  final _watched = <String>{};
  final _tileKeys = <String, GlobalKey>{};

  List<YoutubePlaylistItem> get _list => widget.playlist;
  int get _index => _list.indexWhere((v) => v.videoId == _videoId);
  bool get _hasList => _list.length > 1;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(mute: false, enableCaption: true),
    );
    _sub = _controller.stream.listen(_onPlayerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealCurrent());
  }

  @override
  void dispose() {
    _sub.cancel();
    _controller.close();
    super.dispose();
  }

  void _onPlayerChanged(YoutubePlayerValue value) {
    final ended =
        value.playerState == PlayerState.ended &&
        _lastState != PlayerState.ended;
    _lastState = value.playerState;
    if (!ended) return;

    setState(() => _watched.add(_videoId));
    // Auto-advance through the list.
    if (_index >= 0 && _index + 1 < _list.length) _play(_list[_index + 1]);
  }

  void _play(YoutubePlaylistItem item) {
    if (item.videoId == _videoId) return;
    setState(() {
      _videoId = item.videoId;
      _title = item.title;
    });
    _controller.loadVideoById(videoId: item.videoId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealCurrent());
  }

  /// Scrolls the list so the playing video's tile is in view.
  void _revealCurrent() {
    final ctx = _tileKeys[_videoId]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final index = _index;

    return CustomHeaderLayout(
      title: 'Video',
      showSearchBar: false,
      body: Column(
        children: [
          // Pinned: stays put while the list scrolls. Fullscreen, rotation and
          // system UI are handled by the player itself (it lifts into an
          // overlay), so it can live inside a card.
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              0,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(RadiusToken.lg),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.lg),
                border: Border.all(color: colors.border),
              ),
              child: YoutubePlayer(controller: _controller),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                Spacing.xxl + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                _VideoInfo(controller: _controller, title: _title),
                if (_hasList && index >= 0) ...[
                  const SizedBox(height: Spacing.lg),
                  _LessonNav(
                    index: index,
                    total: _list.length,
                    onPrevious: index > 0
                        ? () => _play(_list[index - 1])
                        : null,
                    onNext: index + 1 < _list.length
                        ? () => _play(_list[index + 1])
                        : null,
                  ),
                ],
                if (_hasList) ...[
                  const SizedBox(height: Spacing.lg),
                  Divider(height: 1, color: colors.border),
                  const SizedBox(height: Spacing.lg),
                  Row(
                    children: [
                      Text(
                        'All videos',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: .bold),
                      ),
                      const Spacer(),
                      Text(
                        '${_list.length} videos',
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  for (final (i, item) in _list.indexed)
                    Padding(
                      key: _tileKeys.putIfAbsent(item.videoId, GlobalKey.new),
                      padding: const EdgeInsets.only(bottom: Spacing.sm),
                      child: _PlaylistTile(
                        item: item,
                        number: i + 1,
                        playing: item.videoId == _videoId,
                        watched: _watched.contains(item.videoId),
                        onTap: () => _play(item),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Title, plus channel and length once the player has loaded them.
class _VideoInfo extends StatelessWidget {
  final YoutubePlayerController controller;
  final String title;

  const _VideoInfo({required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return YoutubeValueBuilder(
      controller: controller,
      buildWhen: (o, n) => o.metaData != n.metaData,
      builder: (context, value) {
        final meta = value.metaData;
        final details = [
          if (meta.author.isNotEmpty) meta.author,
          if (meta.duration > Duration.zero) _formatDuration(meta.duration),
        ];
        return Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: .bold, height: 1.3),
            ),
            if (details.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Text(
                details.join('  ·  '),
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  fontSize: FontSizeToken.sm,
                  color: colors.textMuted,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(h > 0 ? 2 : 1, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

/// "Video 3 of 12" with a progress bar and previous / next buttons.
class _LessonNav extends StatelessWidget {
  final int index;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _LessonNav({
    required this.index,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SectionCard(
      radius: RadiusToken.lg,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.sm,
        Spacing.xs,
        Spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Video ${index + 1} of $total',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    fontWeight: .w600,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusToken.full),
                  child: LinearProgressIndicator(
                    value: (index + 1) / total,
                    minHeight: 4,
                    color: colors.primary,
                    backgroundColor: colors.surfaceAlt,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          IconButton(
            tooltip: 'Previous video',
            onPressed: onPrevious,
            icon: const Icon(LucideIcons.skipBack, size: 20),
            color: colors.text,
            disabledColor: colors.textSubtle,
          ),
          IconButton(
            tooltip: 'Next video',
            onPressed: onNext,
            icon: const Icon(LucideIcons.skipForward, size: 20),
            color: colors.primary,
            disabledColor: colors.textSubtle,
          ),
        ],
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final YoutubePlaylistItem item;
  final int number;
  final bool playing;
  final bool watched;
  final VoidCallback onTap;

  const _PlaylistTile({
    required this.item,
    required this.number,
    required this.playing,
    required this.watched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final thumb = YoutubePlayerController.getThumbnail(videoId: item.videoId);

    return SectionCard(
      radius: RadiusToken.md,
      shadow: false,
      color: playing ? colors.primarySubtle : null,
      borderColor: playing ? colors.primary : null,
      padding: const EdgeInsets.all(Spacing.sm),
      onTap: playing ? null : onTap,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Center(
              child: playing
                  ? Icon(
                      LucideIcons.audioLines,
                      size: 16,
                      color: colors.primary,
                    )
                  : watched
                  ? Icon(
                      LucideIcons.circleCheck,
                      size: 16,
                      color: colors.success,
                    )
                  : Text(
                      '$number',
                      style: TextStyle(
                        fontSize: FontSizeToken.sm,
                        fontWeight: .w600,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            child: SizedBox(
              width: 96,
              height: 54,
              child: AppNetworkImage(
                ApiEndpoints.resolveImageUrl(thumb),
                fit: .cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colors.surfaceAlt,
                  child: Icon(LucideIcons.video, color: colors.textSubtle),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontWeight: playing ? .bold : .w500,
                    height: 1.25,
                    color: colors.text,
                  ),
                ),
                if (playing) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    'Now playing',
                    style: TextStyle(
                      fontSize: FontSizeToken.xs,
                      fontWeight: .bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
