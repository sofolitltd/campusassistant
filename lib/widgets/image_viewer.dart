import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;
import '/core/network/api_endpoints.dart';

class ImageViewer extends StatelessWidget {
  final String title;
  final String time;
  final String image;
  const ImageViewer({
    super.key,
    required this.title,
    required this.time,
    required this.image,
  });

  //
  Future<void> _shareRoutine(BuildContext context) async {
    // 1. Define the custom share message
    final shareMessage = '"$title" - $time!';

    // Optional loading indicator feedback
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Preparing image for sharing...')),
    );

    try {
      // 2. Download the image bytes using http
      final resolvedUrl = ApiEndpoints.resolveImageUrl(image);
      
      final dio = Dio();
      final response = await dio.get(
        resolvedUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 3. Get the temporary directory path
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/routine_image.jpg';
      final file = File(filePath);

      // 4. Write the downloaded bytes to the temporary file
      await file.writeAsBytes(response.data);

      // 5. Share the file along with the custom message
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: shareMessage,
          subject: title,
        ),
      );

      messenger.hideCurrentSnackBar();

      // Note: The temporary file will be cleaned up by the system eventually,
      // but you can uncomment the line below if immediate cleanup is desired.
      // await file.delete();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during sharing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            // Call the share function when pressed
            onPressed: () => _shareRoutine(context),
            icon: const Icon(Icons.share),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Image Container
          Container(
            width: double.infinity, // Ensures full width for responsiveness
            height: double.infinity, // Ensures full height
            alignment: Alignment.center,
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit
                  .cover, // Ensures the image covers the entire screen, regardless of orientation/platform
              imageUrl: ApiEndpoints.resolveImageUrl(image),
              fadeInDuration: const Duration(milliseconds: 500),
              // InteractiveViewer allows pinch-to-zoom (mobile) and mouse wheel zoom (web/desktop)
              imageBuilder: (context, imageProvider) => InteractiveViewer(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const CupertinoActivityIndicator(
                    color: Colors.white,
                  ), // Added color for visibility
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade800,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white70,
                  size: 50,
                ),
              ),
            ),
          ),

          // Content Overlay (Bottom Gradient/Text)
          Container(
            width: double.infinity,
            // Using withOpacity is the standard way to set alpha
            color: Colors.black.withValues(alpha: .4),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Time
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white54,
                    fontWeight: FontWeight.w100,
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
