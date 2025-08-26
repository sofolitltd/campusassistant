// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:excel/excel.dart' as xl; // Using alias here
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
//
// class ExportStudentInfo extends StatefulWidget {
//   const ExportStudentInfo({super.key});
//
//   @override
//   State<ExportStudentInfo> createState() => _ExportStudentInfoState();
// }
//
// class _ExportStudentInfoState extends State<ExportStudentInfo> {
//   List<Map<String, dynamic>> students = [];
//   List<String> batchNames = [];
//   String? selectedBatch;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBatches();
//   }
//
//   //
//   Future<void> fetchBatches() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection(
//             '/Universities/University of Chittagong/Departments/Department of Psychology/batches')
//         .get();
//
//     final names = snapshot.docs.map((doc) => doc['name'] as String).toList()
//       ..sort((a, b) => a.compareTo(b));
//
//     if (names.isNotEmpty) {
//       setState(() {
//         batchNames = names;
//         selectedBatch = names.last;
//       });
//       await fetchStudents(names.last);
//     }
//   }
//
//   //
//
//   Future<void> fetchStudents(String batchName) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection(
//           '/Universities/University of Chittagong/Departments/Department of Psychology/students/batches/$batchName',
//         )
//         .get(); // Remove .orderBy() so we can sort in Dart
//
//     final allStudents = snapshot.docs.map((doc) => doc.data()).toList();
//
//     allStudents.sort((a, b) {
//       final idA = a['id']?.toString() ?? '';
//       final idB = b['id']?.toString() ?? '';
//
//       final prefixA = idA.length >= 2 ? idA.substring(0, 2) : '';
//       final prefixB = idB.length >= 2 ? idB.substring(0, 2) : '';
//
//       final prefixCompare = prefixB.compareTo(prefixA); // descending
//       if (prefixCompare != 0) return prefixCompare;
//
//       return idA.compareTo(idB); // ascending
//     });
//
//     setState(() {
//       students = allStudents;
//     });
//   }
//
//   //
//   Future<void> exportAllBatchesToExcel() async {
//     final excel = xl.Excel.createExcel();
//
//     for (final batch in batchNames) {
//       final sheetName =
//           batch.replaceAll(RegExp(r'[\\/*?\[\]:]'), '_'); // sanitize name
//       final sheet = excel[sheetName];
//       // Delete the default sheet once
//       excel.delete('Sheet1');
//
//       // Add headers
//       final headers = ['ID', 'Name', 'Phone', 'Email', 'Blood', 'Hall'];
//       sheet.appendRow(headers.map((h) => xl.TextCellValue(h)).toList());
//
//       // Fetch student data
//       final snapshot = await FirebaseFirestore.instance
//           .collection(
//             '/Universities/University of Chittagong/Departments/Department of Psychology/students/batches/$batch',
//           )
//           .get();
//
//       // Convert to list and sort by ID prefix descending, then full ID ascending
//       final studentList = snapshot.docs.map((doc) => doc.data()).toList();
//
//       studentList.sort((a, b) {
//         final idA = a['id']?.toString() ?? '';
//         final idB = b['id']?.toString() ?? '';
//
//         final prefixA = idA.length >= 2 ? idA.substring(0, 2) : '';
//         final prefixB = idB.length >= 2 ? idB.substring(0, 2) : '';
//
//         final prefixCompare = prefixB.compareTo(prefixA); // Descending
//         if (prefixCompare != 0) return prefixCompare;
//
//         return idA.compareTo(idB); // Ascending
//       });
//
//       // Add rows
//       for (var student in studentList) {
//         final row = [
//           student['id']?.toString() ?? '',
//           student['name'] ?? '',
//           student['phone']?.toString() ?? '',
//           student['email'] ?? '',
//           student['blood'] ?? '',
//           student['hall'] ?? '',
//         ];
//         sheet.appendRow(row.map((val) => xl.TextCellValue(val)).toList());
//       }
//     }
//
//     const fileName = 'All Batches.xlsx';
//
//     if (kIsWeb) {
//       excel.save(fileName: fileName);
//     } else {
//       var fileBytes = excel.save();
//       var directory = await getApplicationDocumentsDirectory();
//       File(p.join(directory.path, fileName))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes!);
//     }
//   }
//
//   //
//   Future<void> exportToExcelWeb() async {
//     final excel = xl.Excel.createExcel();
//
//     // Accessing the sheet of the selected batch using the alias
//     final sheet = excel[selectedBatch ?? 'Students'];
//     excel.delete('Sheet1');
//
//     // Add headers to the selected sheet
//     sheet.appendRow([
//       xl.TextCellValue('ID'),
//       xl.TextCellValue('Name'),
//       xl.TextCellValue('Phone'),
//       xl.TextCellValue('Email'),
//       xl.TextCellValue('Blood'),
//       xl.TextCellValue('Hall'),
//     ]);
//
//     // Add student data to the selected sheet
//     for (var student in students) {
//       sheet.appendRow([
//         xl.TextCellValue(student['id']?.toString() ?? ''),
//         xl.TextCellValue(student['name'] ?? ''),
//         xl.TextCellValue(student['phone']?.toString() ?? ''),
//         xl.TextCellValue(student['email'] ?? ''),
//         xl.TextCellValue(student['blood'] ?? ''),
//         xl.TextCellValue(student['hall'] ?? ''),
//       ]);
//     }
//
//     final fileName = '${selectedBatch ?? "students"}.xlsx';
//
//     // Save the Excel file
//     if (kIsWeb) {
//       // For web, save the file
//       excel.save(fileName: fileName);
//     } else {
//       // For mobile, save the file locally
//       var fileBytes = excel.save();
//       var directory = await getApplicationDocumentsDirectory();
//
//       File(p.join(directory.path, fileName))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes!);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Students Table')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Dropdown for batch selection
//             Row(
//               children: [
//                 const Text('Select Batch:'),
//                 const SizedBox(width: 12),
//                 DropdownButton<String>(
//                   value: selectedBatch,
//                   items: batchNames
//                       .map((batch) => DropdownMenuItem(
//                             value: batch,
//                             child: Text(batch),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() => selectedBatch = value);
//                       fetchStudents(value);
//                     }
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: students.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: DataTable(
//                           columns: const [
//                             DataColumn(label: Text('ID')),
//                             DataColumn(label: Text('Name')),
//                             DataColumn(label: Text('Phone')),
//                             DataColumn(label: Text('Email')),
//                             DataColumn(label: Text('Blood')),
//                             DataColumn(label: Text('Hall')),
//                           ],
//                           rows: students.map((s) {
//                             return DataRow(cells: [
//                               DataCell(Text(s['id']?.toString() ?? '')),
//                               DataCell(Text(s['name'] ?? '')),
//                               DataCell(Text(s['phone']?.toString() ?? '')),
//                               DataCell(Text(s['email'] ?? '')),
//                               DataCell(Text(s['blood'] ?? '')),
//                               DataCell(Text(s['hall'] ?? '')),
//                             ]);
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           FloatingActionButton.extended(
//             onPressed: exportAllBatchesToExcel,
//             icon: const Icon(Icons.download),
//             label: const Text('All Batches'),
//           ),
//           const SizedBox(height: 12),
//           FloatingActionButton(
//             onPressed: exportToExcelWeb,
//             tooltip: 'Export current batch',
//             child: const Icon(Icons.download),
//           ),
//         ],
//       ),
//     );
//   }
// }
