import 'package:campusassistant/widgets/open_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/profile_data.dart';
import '/screens/study/archive/research/research_add.dart';

class Research extends StatelessWidget {
  const Research({super.key, required this.profileData, required this.batches});

  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (profileData.information.status!.admin == true)
          ? FloatingActionButton(
              onPressed: () {
                //
                {}
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddResearch(
                            university: profileData.university,
                            department: profileData.department,
                            profileData: profileData)));
              },
              child: const Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        title: const Text('Research'),
        centerTitle: true,
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(profileData.university)
              .collection('Departments')
              .doc(profileData.department)
              .collection('researches')
              // .doc('batches')
              // .doc('Archive')
              // .collection('Research')
              .orderBy('title')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFoldingCube(
                  size: 64,
                  color: Colors.deepOrange.shade100,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data Found!'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                String title = data[index].get('title');
                String author = data[index].get('author');
                String type = data[index].get('type');
                String webUrl = data[index].get('webUrl');
                String fileUrl = data[index].get('fileUrl');

                //
                return GestureDetector(
                  onTap: () {
                    if (fileUrl.isNotEmpty) {
                      // todo: add download to see pdf
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         PdfViewerWeb(title: title, fileUrl: fileUrl),
                      //   ),
                      // );
                    } else {
                      //
                      OpenApp.withUrl(webUrl);
                    }
                  },
                  onLongPress: (profileData.information.status!.admin == true)
                      ? () async {
                          //
                          await data[index].reference.delete().then((_) async {
                            if (fileUrl.isNotEmpty) {
                              FirebaseStorage.instance.refFromURL(fileUrl);
                            }
                            //
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: 'Delete Successful');
                          });
                        }
                      : null,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          const SizedBox(height: 12),
                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(author),

                              //
                              Container(
                                decoration: BoxDecoration(
                                  color: type == 'Project'
                                      ? Colors.grey.shade200
                                      : type == 'Thesis'
                                          ? Colors.blue.shade200
                                          : Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
