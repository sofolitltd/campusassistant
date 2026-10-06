import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/core/theme/app_colors.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  const YoutubePlayerPage({
    super.key,
    required this.videoId,
    this.title = 'Video Player',
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(mute: false, enableCaption: true),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: .bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: primaryColor,
        ),
      ),
      body: Column(
        children: [
          // Fullscreen, orientation and system UI are handled by the player.
          YoutubePlayer(controller: _controller),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
