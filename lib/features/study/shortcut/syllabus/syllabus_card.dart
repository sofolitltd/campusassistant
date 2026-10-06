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
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

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
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          boxShadow: [
            BoxShadow(
              color: context.colors.textSubtle.withValues(alpha: 0.05),
              blurRadius: 8,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.md,
            Spacing.md,
            Spacing.md,
            0,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'Syllabus',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    widget.syllabus.title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(fontWeight: .bold),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),

              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.sm,
                      Spacing.xs,
                      Spacing.md,
                      Spacing.xs,
                    ),
                    margin: const EdgeInsets.only(bottom: Spacing.sm),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(RadiusToken.xs),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          color: context.colors.text,
                          size: 16,
                        ),
                        const SizedBox(width: Spacing.xs),
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
                            color: AccentToken.blue,
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
                          icon: Icon(
                            LucideIcons.circleCheck,
                            color: context.colors.success,
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
                          icon: Icon(
                            LucideIcons.circleArrowDown,
                            color: context.colors.danger,
                          ),
                        )
                      else
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Spacing.lg),
                              child: Text(
                                (_downloadProgress! * 100).toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: FontSizeToken.sm,
                                ),
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
