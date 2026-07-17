// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '/features/auth/presentation/providers/user_profile_provider.dart';

// class DBMigration extends ConsumerWidget {
//   const DBMigration({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profile = ref.watch(userProvider).value;

//     if (profile == null) {
//       return const Center(child: CupertinoActivityIndicator());
//     }
//     return Scaffold(
//       appBar: AppBar(title: const Text('DB Migration')),
//       body: Padding(
//         padding: EdgeInsetsGeometry.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             spacing: 12,
//             children: [
//               // questions title
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Fix Questions Title'),
//                 subtitle: Text('Either Questions or Questions Analysis '),

//                 onTap: () async {
//                   final firestore = FirebaseFirestore.instance;
//                   final snapshot = await firestore
//                       .collection('questions')
//                       .get();

//                   for (final doc in snapshot.docs) {
//                     final data = doc.data();
//                     final title = (data['contentTitle'] ?? '')
//                         .toString()
//                         .toLowerCase();

//                     final newTitle = title.contains('analysis')
//                         ? 'Questions Analysis'
//                         : 'Questions';

//                     await doc.reference.update({'contentTitle': newTitle});
//                     print('✅ Updated ${doc.id} -> $newTitle');
//                   }

//                   print('🎉 All question titles normalized successfully!');
//                 },
//               ),

//               // question year
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Fix Questions Year'),
//                 subtitle: Text('Either 20-21 or [2020,2021] '),
//                 onTap: () async {
//                   final firestore = FirebaseFirestore.instance;
//                   final snapshot = await firestore
//                       .collection('questions')
//                       .get();

//                   for (final doc in snapshot.docs) {
//                     final data = doc.data();
//                     String subtitle = (data['contentSubtitle'] ?? '')
//                         .toString()
//                         .trim();

//                     if (subtitle.isEmpty) continue;

//                     // Match range like 14-19, 2020-24 etc.
//                     final rangeRegex = RegExp(r'(\d{2,4})\s*-\s*(\d{2,4})');
//                     final match = rangeRegex.firstMatch(subtitle);

//                     String normalized = '';

//                     if (match != null) {
//                       int start = int.parse(match.group(1)!);
//                       int end = int.parse(match.group(2)!);

//                       // Normalize 2-digit years to 2000+
//                       if (start < 100) start += 2000;
//                       if (end < 100) end += 2000;

//                       normalized = '$start-$end';
//                     } else {
//                       // If single year like 2021 or 21
//                       final singleYearRegex = RegExp(r'\b(\d{2,4})\b');
//                       final singleMatch = singleYearRegex.firstMatch(subtitle);
//                       if (singleMatch != null) {
//                         int year = int.parse(singleMatch.group(1)!);
//                         if (year < 100) year += 2000;
//                         normalized =
//                             '$year-${year + 1}'; // make it like 2020-2021
//                       } else {
//                         normalized = subtitle; // fallback
//                       }
//                     }

//                     await doc.reference.update({'contentSubtitle': normalized});
//                     print('✅ Updated ${doc.id}: $normalized');
//                   }

//                   print('🎉 All subtitles normalized!');
//                 },
//               ),

//               // halls/transports/emergency
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Halls/Transports/Emergency'),
//                 subtitle: Text('university/"Halls" -> "halls"'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Transports');

//                     final target = FirebaseFirestore.instance.collection(
//                       'transports',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add universityId and departmentId fields
//                       data['university'] = profile.university; // or slug/id

//                       // Add the document to the flat collection with a new random ID
//                       await target.add(data);

//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // Cr - cr
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('university/department/Cr → cr'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('Cr');

//                     final target = FirebaseFirestore.instance.collection('cr');

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // ✅ Add/override new fields
//                       data['university'] = profile
//                           .university; // e.g., "University of Chittagong"
//                       data['department'] =
//                           profile.department; // e.g., "Psychology"
//                       data['isCurrent'] =
//                           true; // you can change manually later if needed
//                       data['year'] = DateTime.now().year.toString();
//                       data['createdAt'] = FieldValue.serverTimestamp();
//                       data['id'] = '';

//                       // ✅ Add to flat collection
//                       await target.add(data);
//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // batches
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/batches → batches)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('batches');

//                     final target = FirebaseFirestore.instance.collection(
//                       'batches',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // ✅ Add/override new fields
//                       data['university'] = profile
//                           .university; // e.g., "University of Chittagong"
//                       data['department'] =
//                           profile.department; // e.g., "Psychology"

//                       // ✅ Add to flat collection
//                       await target.add(data);
//                       count++;
//                       print('$count / $total');
//                       Fluttertoast.showToast(
//                         msg: ' $count / $total migrated.',
//                         backgroundColor: Colors.green,
//                       );
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //sessions
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/sessions → sessions)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('sessions');

//                     final target = FirebaseFirestore.instance.collection(
//                       'sessions',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // ✅ Add/override new fields
//                       data['university'] = profile
//                           .university; // e.g., "University of Chittagong"
//                       data['department'] =
//                           profile.department; // e.g., "Psychology"

//                       // ✅ Add to flat collection
//                       await target.add(data);
//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //semesters
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/semesters → semesters)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('semesters');

//                     final target = FirebaseFirestore.instance.collection(
//                       'semesters',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // ✅ Add/override new fields
//                       data['university'] = profile
//                           .university; // e.g., "University of Chittagong"
//                       data['department'] =
//                           profile.department; // e.g., "Psychology"

//                       // ✅ Add to flat collection
//                       await target.add(data);
//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // researches
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text(
//                   'Migration (uni/dept/researches → researches)',
//                 ),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('researches');

//                     final target = FirebaseFirestore.instance.collection(
//                       'researches',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // ✅ Add/override new fields
//                       data['university'] = profile
//                           .university; // e.g., "University of Chittagong"
//                       data['department'] =
//                           profile.department; // e.g., "Psychology"
//                       data['fileUrl'] = [];
//                       data['webUrl'] = [data['webUrl']];

//                       // ✅ Add to flat collection
//                       await target.add(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //courses
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/courses → courses)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('courses');

//                     final target = FirebaseFirestore.instance.collection(
//                       'courses',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Use a new doc ref with auto ID
//                       final newDocRef = target.doc(); // auto-generated ID

//                       // Add contentId directly
//                       data['contentId'] = newDocRef.id;

//                       // Set the document
//                       await newDocRef.set(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //chapters
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/chapters → chapters)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('chapters');

//                     // todo
//                     final target = FirebaseFirestore.instance.collection(
//                       'chapters',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Set the document
//                       await target.add(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //notes
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/notes → notes)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('notes');

//                     final target = FirebaseFirestore.instance.collection(
//                       'notes',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Use a new doc ref with auto ID
//                       final newDocRef = target.doc(); // auto-generated ID

//                       // Add contentId directly
//                       data['contentId'] = newDocRef.id;

//                       // Set the document
//                       await newDocRef.set(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //books
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/books → books)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('books');

//                     final target = FirebaseFirestore.instance.collection(
//                       'books',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Use a new doc ref with auto ID
//                       final newDocRef = target.doc(); // auto-generated ID

//                       // Add contentId directly
//                       data['contentId'] = newDocRef.id;

//                       // Set the document
//                       await newDocRef.set(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //questions
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migration (uni/dept/questions → questions)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('questions');

//                     final target = FirebaseFirestore.instance.collection(
//                       'questions',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Use a new doc ref with auto ID
//                       final newDocRef = target.doc(); // auto-generated ID

//                       // Add contentId directly
//                       data['contentId'] = newDocRef.id;

//                       // Set the document
//                       await newDocRef.set(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //full syllabus
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Full Syllabus'),
//                 subtitle: const Text(
//                   'university/department/syllabusFull → syllabus_full)',
//                 ),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('syllabusFull');

//                     final target = FirebaseFirestore.instance.collection(
//                       'syllabus_full',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add/override university and department
//                       data['university'] = profile.university;
//                       data['department'] = profile.department;

//                       // Use a new doc ref with auto ID
//                       final newDocRef = target.doc(); // auto-generated ID

//                       // Add contentId directly
//                       data['contentId'] = newDocRef.id;

//                       // Set the document
//                       await newDocRef.set(data);

//                       count++;
//                       print('$count / $total');
//                     }

//                     Fluttertoast.showToast(
//                       msg: 'Migration completed! $count / $total migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               //staff
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Migration (uni/dept/Staff -> staff)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('Staff');

//                     final target = FirebaseFirestore.instance.collection(
//                       'staff',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add universityId and departmentId fields
//                       data['university'] = profile.university; // or slug/id
//                       data['department'] = profile.department; // or slug/id

//                       // Add the document to the flat collection with a new random ID
//                       await target.add(data);

//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg:
//                           'Migration completed! $count / $total teachers migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // routines
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Migration (uni/dept/routines -> routines)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('routines');

//                     final target = FirebaseFirestore.instance.collection(
//                       'routines',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add universityId and departmentId fields
//                       data['university'] = profile.university; // or slug/id
//                       data['department'] = profile.department; // or slug/id

//                       // Add the document to the flat collection with a new random ID
//                       await target.add(data);

//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg:
//                           'Migration completed! $count / $total teachers migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // student
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: const Text('Migrate Students'),
//                 onTap: () async {
//                   try {
//                     final firestore = FirebaseFirestore.instance;
//                     final university = profile.university;
//                     final department = profile.department;

//                     final List<String> batchNames = [
//                       // 'Batch 01',
//                       'Batch 08',
//                       'Batch 09',
//                       'Batch 10',
//                       'Batch 11',
//                       'Batch 12',
//                       'Batch 13',
//                       'Batch 14',
//                       'Batch 15',
//                       'Batch 16',
//                       'Batch 17',
//                       'Batch 18',
//                       'Batch 19',
//                       'Batch 20',
//                     ];

//                     int totalMigrated = 0;

//                     for (final batchName in batchNames) {
//                       final batchRef = firestore
//                           .collection('Universities')
//                           .doc(university)
//                           .collection('Departments')
//                           .doc(department)
//                           .collection('students')
//                           .doc('batches')
//                           .collection(batchName);

//                       final batchSnapshot = await batchRef.get();

//                       for (final studentDoc in batchSnapshot.docs) {
//                         final data = studentDoc.data();

//                         // Add metadata
//                         data['university'] = university;
//                         data['department'] = department;
//                         data['batch'] = batchName;

//                         // Save to flat 'students' collection
//                         await firestore.collection('students').add(data);

//                         totalMigrated++;
//                         print('$totalMigrated migrated');
//                       }
//                     }

//                     Fluttertoast.showToast(
//                       msg:
//                           'Migration completed! $totalMigrated students migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // teachers
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Migration (uni/dpt/teachers -> teachers)'),
//                 onTap: () async {
//                   try {
//                     final source = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department)
//                         .collection('teachers');

//                     final target = FirebaseFirestore.instance.collection(
//                       'teachers',
//                     );

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add universityId and departmentId fields
//                       data['university'] = profile.university; // or slug/id
//                       data['department'] = profile.department; // or slug/id

//                       // Add the document to the flat collection with a new random ID
//                       await target.add(data);

//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg:
//                           'Migration completed! $count / $total teachers migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),

//               // teachers
//               ListTile(
//                 dense: true,
//                 visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                 tileColor: Colors.white,
//                 title: Text('Migration (uni/dpt/Teachers - teachers)'),
//                 onTap: () async {
//                   try {
//                     var ref = FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(profile.university)
//                         .collection('Departments')
//                         .doc(profile.department);

//                     final source = ref.collection('Teachers');
//                     final target = ref.collection('teachers');

//                     final snapshot = await source.get();
//                     final total = snapshot.docs.length;
//                     int count = 0;

//                     for (final doc in snapshot.docs) {
//                       final data = doc.data();

//                       // Add document to generate new ID
//                       final newDocRef = await target.add(data);

//                       // Update the 'id' field with the new document ID
//                       await newDocRef.update({'id': newDocRef.id});

//                       count++;
//                     }

//                     Fluttertoast.showToast(
//                       msg:
//                           'Migration completed! $count / $total teachers migrated.',
//                       backgroundColor: Colors.green,
//                     );
//                   } catch (e) {
//                     Fluttertoast.showToast(
//                       msg: 'Migration failed: $e',
//                       backgroundColor: Colors.red,
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
