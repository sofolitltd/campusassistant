import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../syllabus/domain/entities/syllabus.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

class SyllabusCard extends StatefulWidget {
  const SyllabusCard({super.key, required this.syllabus});

  final Syllabus syllabus;

  @override
  State<SyllabusCard> createState() => _SyllabusCardState();
}

class _SyllabusCardState extends State<SyllabusCard> {
  bool _isLoading = false;
  double? _downloadProgress = 0;

  @override
  Widget build(BuildContext context) {
    final fileName = '${widget.syllabus.title}.pdf';
    final fileUrl = widget.syllabus.fileUrl;

    return GestureDetector(
      onTap: () async {
        if (kIsWeb) {
          final uri = Uri.parse(fileUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }

        final filePath =
            '/storage/emulated/0/Download/Campus Assistant/$fileName';
        final file = File(filePath);

        if (!file.existsSync()) {
          setState(() => _isLoading = true);
          await downloadFileAndroid(url: fileUrl, fileName: fileName);
          setState(() => _isLoading = false);
        }

        await openFileAndroid(fileName: fileName, url: fileUrl);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Syllabus',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    widget.syllabus.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.clock,
                          color: Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.syllabus.createdAt != null
                              ? '${widget.syllabus.createdAt!.year}-${widget.syllabus.createdAt!.month.toString().padLeft(2, '0')}-${widget.syllabus.createdAt!.day.toString().padLeft(2, '0')}'
                              : 'N/A',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _handleShare(fileName),
                        icon: const Icon(LucideIcons.share2, size: 20),
                      ),

                      if (kIsWeb)
                        IconButton(
                          onPressed: () async {
                            final uri = Uri.parse(fileUrl);
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          icon: const Icon(
                            LucideIcons.externalLink,
                            color: Colors.blueAccent,
                          ),
                        )
                      else if (File(
                        '/storage/emulated/0/Download/Campus Assistant/$fileName',
                      ).existsSync())
                        IconButton(
                          onPressed: () async {
                            await openFileAndroid(
                              fileName: fileName,
                              url: fileUrl,
                            );
                          },
                          icon: const Icon(
                            LucideIcons.circleCheck,
                            color: Colors.green,
                          ),
                        )
                      else if (!_isLoading)
                        IconButton(
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            await downloadFileAndroid(
                              url: fileUrl,
                              fileName: fileName,
                            );
                            setState(() => _isLoading = false);
                          },
                          icon: const Icon(
                            LucideIcons.circleArrowDown,
                            color: Colors.red,
                          ),
                        )
                      else
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                (_downloadProgress! * 100).toStringAsFixed(0),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                value: _downloadProgress,
                                strokeWidth: 2,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleShare(String fileName) async {
    try {
      final directory = Platform.isAndroid
          ? Directory("/storage/emulated/0/Download/Campus Assistant")
          : await getTemporaryDirectory();

      await directory.create(recursive: true);
      final file = File('${directory.path}/$fileName');

      if (!file.existsSync()) {
        setState(() => _isLoading = true);
        await downloadFileAndroid(
          url: widget.syllabus.fileUrl,
          fileName: fileName,
        );
        setState(() => _isLoading = false);
      }

      final text = 'Syllabus: ${widget.syllabus.title}';
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: text, subject: 'Syllabus'),
      );
    } catch (e) {
      log('Share error: $e');
      Fluttertoast.showToast(msg: 'Error sharing: $e');
    }
  }

  Future<void> downloadFileAndroid({
    required String url,
    required String fileName,
  }) async {
    if (kIsWeb) {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Fluttertoast.showToast(msg: 'Could not open download link.');
      } else {
        Fluttertoast.showToast(msg: 'Opening download link...');
      }
      return;
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();

    Directory directory = Platform.isAndroid
        ? Directory("/storage/emulated/0/Download/Campus Assistant")
        : await getApplicationDocumentsDirectory();

    await directory.create(recursive: true);
    final file = File('${directory.path}/$fileName');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
        onReceiveProgress: (received, total) {
          _downloadProgress = received / total;
          setState(() {});
        },
      );

      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();

      Fluttertoast.showToast(
        msg: 'File saved in Download/Campus Assistant',
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      log('Download error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> openFileAndroid({
    required String fileName,
    required String url,
  }) async {
    if (kIsWeb) {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    final path = '/storage/emulated/0/Download/Campus Assistant/$fileName';
    await OpenFilex.open(path);
  }
}
