// import 'dart:developer';
// import 'dart:io';
//
// import 'package:campusassistant/screens/study/syllabus/syllabus_edit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '/models/profile_data.dart';
//
// class SyllabusCard extends StatefulWidget {
//   const SyllabusCard({
//     super.key,
//     required this.university,
//     required this.department,
//     required this.profileData,
//     required this.contentModel,
//   });
//
//   final String university;
//   final String department;
//   final ProfileData profileData;
//   final DocumentSnapshot contentModel;
//
//   @override
//   State<SyllabusCard> createState() => _SyllabusCardState();
// }
//
// class _SyllabusCardState extends State<SyllabusCard> {
//   bool _isLoading = false;
//   double? _downloadProgress = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     // String fileName =
//     //     '${widget.contentModel.get('courseCode')}-${widget.contentModel.get('lessonNo')} ${widget.contentModel.get('contentTitle').replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentModel.contentSubtitle}_${widget.contentModel.contentId.toString().substring(0, 5)}.pdf';
//
//     String fileName = '${widget.contentModel.get('contentTitle')}.pdf';
//
//     //
//     return GestureDetector(
//       onTap: () async {
//         if (!File('/storage/emulated/0/Download/Campus Assistant/$fileName')
//             .existsSync()) {
//           setState(() => _isLoading = true);
//
//           //
//           await downloadFileAndroid(
//             url: widget.contentModel.get('fileUrl'),
//             fileName: fileName,
//           );
//
//           //
//           setState(() => _isLoading = false);
//         }
//
//         //
//         await openFileAndroid(fileName: fileName);
//       },
//       onLongPress: () {
//         if (widget.profileData.information.status!.moderator!) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => EditSyllabus(
//                         university: widget.university,
//                         department: widget.department,
//                         profileData: widget.profileData,
//                         docId: widget.contentModel.id,
//                         contentTitle: widget.contentModel.get('contentTitle'),
//                         fileUrl: widget.contentModel.get('fileUrl'),
//                       )));
//         }
//       },
//
//       //
//       child: Card(
//         margin: EdgeInsets.zero,
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
//           child: Column(
//             children: [
//               //
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   //title
//                   Text(
//                     'Syllabus',
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//
//                   //
//                   Text(
//                     widget.contentModel.get('contentTitle'),
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               //
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   //time
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
//                     margin: const EdgeInsets.only(bottom: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.shade50,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.watch_later_outlined,
//                           color: Colors.black,
//                           size: 16,
//                         ),
//
//                         const SizedBox(width: 5),
//
//                         // time
//                         Text(
//                           widget.contentModel.get('uploadDate'),
//                           style:
//                               Theme.of(context).textTheme.titleSmall!.copyWith(
//                                     color: Colors.black,
//                                   ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // btn
//                   if (widget.profileData.information.status!.moderator! ||
//                       widget.profileData.information.status!.cr!)
//                     Row(
//                       children: [
//                         //if already download
//                         if (File(
//                                 '/storage/emulated/0/Download/Campus Assistant/$fileName')
//                             .existsSync())
//                           SizedBox(
//                             height: 40,
//                             width: 40,
//                             child: IconButton(
//                               onPressed: () async {
//                                 //open file
//                                 await openFileAndroid(fileName: fileName);
//                               },
//                               icon: const Icon(
//                                 Icons.check_circle_outline,
//                                 color: Colors.green,
//                                 // size: 30,
//                               ),
//                             ),
//                           )
//                         else
//                           (_isLoading == false)
//                               ? SizedBox(
//                                   height: 40,
//                                   width: 40,
//                                   child: IconButton(
//                                     onPressed: () async {
//                                       setState(() => _isLoading = true);
//
//                                       //
//                                       await downloadFileAndroid(
//                                         url: widget.contentModel.get('fileUrl'),
//                                         fileName: fileName,
//                                       );
//
//                                       //
//                                       setState(() => _isLoading = false);
//                                     },
//                                     icon: const Icon(
//                                       Icons.downloading_rounded,
//                                       color: Colors.red,
//                                       // size: 30,
//                                     ),
//                                   ),
//                                 )
//                               : SizedBox(
//                                   height: 40,
//                                   width: 40,
//                                   child: IconButton(
//                                     onPressed: () async {},
//                                     icon: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         //text
//                                         Text(
//                                           (_downloadProgress! * 100)
//                                               .toStringAsFixed(0),
//                                           style: const TextStyle(fontSize: 12),
//                                         ),
//                                         SizedBox(
//                                           height: 20,
//                                           width: 20,
//                                           child: _downloadProgress == 0
//                                               ? const CircularProgressIndicator(
//                                                   strokeWidth: 2,
//                                                 )
//                                               : CircularProgressIndicator(
//                                                   value: _downloadProgress,
//                                                   strokeWidth: 2,
//                                                 ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//                         //
//                         // SizedBox(
//                         //   height: 40,
//                         //   width: 40,
//                         //   child: IconButton(
//                         //     tooltip: 'Preview file',
//                         //     onPressed: () {
//                         //       //
//                         //       Navigator.push(
//                         //         context,
//                         //         MaterialPageRoute(
//                         //           builder: (context) => PdfViewerWeb(
//                         //             title:
//                         //                 widget.contentModel.get('contentTitle'),
//                         //             fileUrl: widget.contentModel.get('fileUrl'),
//                         //           ),
//                         //         ),
//                         //       );
//                         //     },
//                         //     icon: const Icon(
//                         //       Icons.visibility_outlined,
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // download file
//   downloadFileAndroid({required String url, required String fileName}) async {
//     //per
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       // If not, request permission
//       await Permission.storage.request();
//     }
//
//     //
//     Directory directory = Directory("");
//     if (Platform.isAndroid) {
//       // Redirects it to download folder in android
//       directory = Directory("/storage/emulated/0/Download/Campus Assistant");
//     } else {
//       directory = await getApplicationDocumentsDirectory();
//     }
//
//     final exPath = directory.path;
//     print("Saved Path: $exPath");
//     await Directory(exPath).create(recursive: true);
//
//     final file = File('$exPath/$fileName');
//
//     // download file with dio
//     try {
//       final response = await Dio().get(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//         ),
//         onReceiveProgress: (received, total) {
//           double progress = received / total;
//           _downloadProgress = progress;
//           setState(() {});
//         },
//       );
//
//       // store on file system
//       final ref = file.openSync(mode: FileMode.write);
//       ref.writeFromSync(response.data);
//       await ref.close();
//       await Fluttertoast.showToast(
//           msg: 'File save on: \nDownload/Campus Assistant',
//           toastLength: Toast.LENGTH_LONG);
//     } catch (e) {
//       log('error: $e');
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
// //open file
//   Future<void> openFileAndroid({required String fileName}) async {
//     Directory? downloadDir =
//         Directory('/storage/emulated/0/Download/Campus Assistant');
//     String filePath = '${downloadDir.path}/$fileName';
//     await OpenFilex.open(filePath);
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:campusassistant/screens/study/syllabus/syllabus_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '/models/profile_data.dart';

class SyllabusCard extends StatefulWidget {
  const SyllabusCard({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
    required this.contentModel,
  });

  final String university;
  final String department;
  final ProfileData profileData;
  final DocumentSnapshot contentModel;

  @override
  State<SyllabusCard> createState() => _SyllabusCardState();
}

class _SyllabusCardState extends State<SyllabusCard> {
  bool _isLoading = false;
  double? _downloadProgress = 0;

  @override
  Widget build(BuildContext context) {
    String fileName = '${widget.contentModel.get('contentTitle')}.pdf';
    String fileUrl = widget.contentModel.get('fileUrl');

    return GestureDetector(
      onTap: () async {
        if (kIsWeb) {
          // ✅ Open PDF directly in new browser tab (WASM safe)
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
      onLongPress: () {
        if (widget.profileData.information.status!.moderator!) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditSyllabus(
                university: widget.university,
                department: widget.department,
                profileData: widget.profileData,
                docId: widget.contentModel.id,
                contentTitle: widget.contentModel.get('contentTitle'),
                fileUrl: fileUrl,
              ),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
          child: Column(
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Syllabus',
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    widget.contentModel.get('contentTitle'),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Upload date
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.watch_later_outlined,
                            color: Colors.black, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          widget.contentModel.get('uploadDate'),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  if (widget.profileData.information.status!.moderator! ||
                      widget.profileData.information.status!.cr!)
                    Row(
                      children: [
                        if (kIsWeb)
                          IconButton(
                            onPressed: () async {
                              final uri = Uri.parse(fileUrl);
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            },
                            icon: const Icon(Icons.open_in_new,
                                color: Colors.blueAccent),
                          )
                        else if (File(
                                '/storage/emulated/0/Download/Campus Assistant/$fileName')
                            .existsSync())
                          IconButton(
                            onPressed: () async {
                              await openFileAndroid(
                                  fileName: fileName, url: fileUrl);
                            },
                            icon: const Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          )
                        else if (!_isLoading)
                          IconButton(
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              await downloadFileAndroid(
                                  url: fileUrl, fileName: fileName);
                              setState(() => _isLoading = false);
                            },
                            icon: const Icon(Icons.downloading_rounded,
                                color: Colors.red),
                          )
                        else
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                (_downloadProgress! * 100).toStringAsFixed(0),
                                style: const TextStyle(fontSize: 12),
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

  // ✅ WASM-safe + Android download
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
        options:
            Options(responseType: ResponseType.bytes, followRedirects: false),
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
          toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      log('Download error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ✅ WASM-safe file opener
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
