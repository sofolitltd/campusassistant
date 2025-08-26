import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/models/profile_data.dart';
import '../../widgets/progress_dialog.dart';

class AddResearch extends StatefulWidget {
  const AddResearch({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final String university;
  final String department;
  final ProfileData profileData;

  @override
  State<AddResearch> createState() => _AddResearchState();
}

class _AddResearchState extends State<AddResearch> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _webLinkController = TextEditingController();

  String? _selectedType;
  String _selectedUploadOption = 'Web Link';

  String? fileName;
  File? _selectedMobileFile;
  Uint8List _selectedWebFile = Uint8List(8);
  UploadTask? task;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Add Research'),
      ),

      //
      body: Form(
        key: _formState,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            // title
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Research Title',
                hintText: 'Introduction',
              ),
              validator: (value) => value!.isEmpty ? "Enter Title" : null,
            ),

            const SizedBox(height: 16),

            // author
            TextFormField(
              controller: _authorController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              minLines: 1,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Author Name',
                hintText: 'Introduction',
              ),
              validator: (value) => value!.isEmpty ? "Enter Author Name" : null,
            ),

            const SizedBox(height: 16),

            //
            Row(
              //
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: DropdownButton<String>(
                        hint: const Text('Research Type'),
                        items: ['Project', 'Thesis', 'Publications']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedType = newValue;
                          });
                        },
                        value: _selectedType,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                //
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: DropdownButton<String>(
                        items: ['Web Link', 'Pdf File']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUploadOption = newValue!;
                          });
                        },
                        value: _selectedUploadOption,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // choose file
            if (_selectedUploadOption == 'Web Link')
              // author
              TextFormField(
                controller: _webLinkController,
                keyboardType: TextInputType.url,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Web Link ',
                  hintText: 'Web Link',
                ),
                // validator: (value) => value!.isEmpty ? "Enter Link" : null,
              ),

            //
            if (_selectedUploadOption == 'Pdf File')
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: ListTile(
                  onTap: pickFile,
                  contentPadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                  horizontalTitleGap: 0,
                  shape: const RoundedRectangleBorder(),
                  leading: const Icon(Icons.file_copy_outlined),
                  title: (fileName == null || _selectedWebFile.isEmpty)
                      ? const Text('No File Selected',
                          style: TextStyle(color: Colors.red))
                      : SelectableText(
                          fileName!,
                          style: const TextStyle(),
                        ),
                  trailing: InkWell(
                    onTap: pickFile,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4)),
                      child: const Icon(
                        Icons.attach_file_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            //
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  onPressed: () async {
                    if (_formState.currentState!.validate() &&
                        _selectedType != null) {
                      // put file
                      String docId =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      //
                      if (_selectedUploadOption == 'Web Link') {
                        if (_webLinkController.text.isEmpty) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(msg: 'No Web Link Found !');
                        } else {
                          // fire store
                          await uploadFileToFireStore(
                              docId: docId,
                              fileUrl: '',
                              webUrl: _webLinkController.text.trim());
                        }
                      } else {
                        //
                        if (_selectedMobileFile == null) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(msg: 'No File Selected !');
                        } else {
                          task = putContentOnStorage(docId);
                          setState(() {});
                          if (task == null) return;
                          progressDialog(context, task!);

                          // download link
                          final snapshot = await task!.whenComplete(() {});
                          String downloadedUrl =
                              await snapshot.ref.getDownloadURL();

                          // fire store
                          await uploadFileToFireStore(
                              docId: docId, fileUrl: downloadedUrl, webUrl: '');
                        }
                      }
                    } else if (_selectedType == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                          msg: 'No Research Type Selected !');
                    }
                  },
                  label: const Text('Upload')),
            ),
          ],
        ),
      ),
    );
  }

  // pick file
  pickFile() async {
    //open file manager
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    //
    if (result != null) {
      fileName = result.files.first.name;

      if (!kIsWeb) {
        final path = result.files.first.path!;
        var selectedMobileFile = File(path);
        setState(() {
          _selectedMobileFile = selectedMobileFile;
        });
      } else if (kIsWeb) {
        var selectedWebFile = result.files.first.bytes;
        setState(() {
          _selectedWebFile = selectedWebFile!;
          _selectedMobileFile = File('');
        });
      }
    } else {
      // User canceled the picker
    }
  }

  // upload file to storage
  UploadTask? putContentOnStorage(String docId) {
    var fileName = '$docId.pdf';

    ///Universities/University of Chittagong/Departments/Department of Psychology
    final ref = FirebaseStorage.instance
        .ref('Universities')
        .child(widget.university)
        .child(widget.department)
        .child('researches')
        .child(fileName);

    try {
      if (kIsWeb) {
        return ref.putData(
          _selectedWebFile,
          SettableMetadata(
            contentType: 'application/pdf',
          ),
        );
      } else {
        return ref.putFile(_selectedMobileFile!);
      }
    } on FirebaseException catch (e) {
      log('Content upload error: ${e.message!}');
      return null;
    }
  }

  // upload file to fire store
  uploadFileToFireStore(
      {required String docId,
      required String fileUrl,
      required String webUrl}) async {
    //time
    String uploadDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    // model
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection("researches")
        .doc(docId);
    log(ref.toString());

    // add to /notes
    await ref.set({
      'title': _titleController.text.trim(),
      'author': _authorController.text.trim(),
      'type': _selectedType,
      'webUrl': _webLinkController.text.trim(),
      'fileUrl': fileUrl,
      'uploadDate': uploadDate,
    }).then((value) {
      Navigator.pop(context);
      if (fileUrl.isNotEmpty) {
        Navigator.pop(context);
      }
    });
  }
}
