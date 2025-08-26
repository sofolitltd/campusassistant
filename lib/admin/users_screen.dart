// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<UsersScreen> createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   String search = "";
//   String total = "";
//
//   List universityList = [];
//   String? _selectedUniversity;
//   String? _selectedDepartment;
//
//   @override
//   void initState() {
//     getUniversityList();
//     super.initState();
//   }
//
//   // get university
//   getUniversityList() {
//     FirebaseFirestore.instance.collection('Universities').get().then(
//       (QuerySnapshot querySnapshot) {
//         for (var doc in querySnapshot.docs) {
//           setState(() => universityList.add(doc.id));
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(centerTitle: true, title: Text('All Users$total')),
//         body: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             //
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width > 800
//                     ? MediaQuery.of(context).size.width * .2
//                     : 16,
//                 vertical: 8,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField(
//                     isExpanded: true,
//                     hint: const Text('Select your university'),
//                     value: _selectedUniversity,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 13, horizontal: 13),
//                       labelText: 'University',
//                     ),
//                     items: universityList
//                         .map((item) => DropdownMenuItem<String>(
//                             value: item,
//                             child: Text(item, overflow: TextOverflow.ellipsis)))
//                         .toList(),
//                     onChanged: (String? value) {
//                       setState(() {
//                         _selectedUniversity = null;
//                         _selectedDepartment = null;
//                         _selectedUniversity = value!;
//                       });
//                     },
//                     validator: (value) =>
//                         value == null ? 'please select a university' : null,
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Departments
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(_selectedUniversity)
//                         .collection('Departments')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return const Text('Some thing went wrong');
//                       }
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         // loading state
//                         return DropdownButtonFormField(
//                           hint: const Text('Select your department'),
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 13, horizontal: 13),
//                             labelText: 'Department',
//                           ),
//                           items: [].map((item) {
//                             // university name
//                             return DropdownMenuItem<String>(
//                                 value: item, child: Text(item));
//                           }).toList(),
//                           onChanged: (String? value) {},
//                           validator: (value) => value == null
//                               ? 'please select a department'
//                               : null,
//                         );
//                       }
//
//                       var docs = snapshot.data!.docs;
//                       // select department
//                       return DropdownButtonFormField(
//                         hint: const Text('Select your department'),
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 13, horizontal: 13),
//                           labelText: 'Department',
//                         ),
//                         value: _selectedDepartment,
//                         items: docs.map((item) {
//                           // university name
//                           return DropdownMenuItem<String>(
//                               value: item.id, child: Text(item.id));
//                         }).toList(),
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedDepartment = value!;
//                           });
//                         },
//                         validator: (value) =>
//                             value == null ? 'please select a department' : null,
//                       );
//                     },
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   //roll
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 13,
//                           vertical: 13,
//                         ),
//                         border: OutlineInputBorder(),
//                         suffixIcon: Icon(Icons.search),
//                         hintText: 'Search by Student ID'),
//                     onChanged: (val) {
//                       setState(() {
//                         search = val;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 4),
//
//             //
//             Flexible(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .where('university', isEqualTo: _selectedUniversity)
//                     .where('department', isEqualTo: _selectedDepartment)
//                     // .orderBy('name')
//                     .snapshots(),
//                 builder: (context, snapshots) {
//                   if ((snapshots.connectionState == ConnectionState.waiting)) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else {
//                     total = '(${snapshots.data!.size})';
//                     //
//                     return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width > 800
//                               ? MediaQuery.of(context).size.width * .2
//                               : 16,
//                           vertical: 0,
//                         ),
//                         itemCount: snapshots.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           //
//                           Map<String, dynamic> data =
//                               snapshots.data!.docs[index].data()
//                                   as Map<String, dynamic>;
//
//                           if (search.isEmpty) {
//                             return card(data);
//                           }
//                           if (data['information']['id']
//                               .toString()
//                               .toLowerCase()
//                               .startsWith(search.toLowerCase())) {
//                             return card(data);
//                           }
//                           return Container();
//                         });
//                   }
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
//
//   //
//   card(Map<String, dynamic> profile) {
//     return Container(
//       // height: 86,
//       padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: .5, color: Colors.blueGrey.shade100),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // image & badge
//           Column(
//             children: [
//               //image
//               CachedNetworkImage(
//                 imageUrl: profile['image'],
//                 fadeInDuration: const Duration(milliseconds: 500),
//                 imageBuilder: (context, imageProvider) => CircleAvatar(
//                   backgroundImage: imageProvider,
//                   radius: 24,
//                 ),
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     const CircleAvatar(
//                   radius: 24,
//                   backgroundImage:
//                       AssetImage('assets/images/pp_placeholder.png'),
//                   child: CupertinoActivityIndicator(),
//                 ),
//                 errorWidget: (context, url, error) => const CircleAvatar(
//                     radius: 24,
//                     backgroundImage:
//                         AssetImage('assets/images/pp_placeholder.png')),
//               ),
//
//               //badge
//               if (profile['information']['status']['subscriber'] == 'pro')
//                 const Row(
//                   children: [
//                     //
//                     Icon(
//                       Icons.check_circle,
//                       size: 16,
//                       color: Colors.blue,
//                     ),
//                     //
//                     Text(
//                       'PRO',
//                       style: TextStyle(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//
//           const SizedBox(width: 12),
//
//           //name , status
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   profile['name'],
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 2),
//
//                 //
//                 Row(
//                   children: [
//                     Text(profile['information']['batch']),
//                     const Text(' | '),
//                     Text(
//                       profile['information']['id'],
//                       style: const TextStyle(
//                         color: Colors.redAccent,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Text(' | '),
//                     Text(profile['information']['session']),
//                   ],
//                 ),
//
//                 //
//                 const SizedBox(height: 2),
//                 Text('~ ${profile['email']}'),
//
//                 //
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     // is admin
//                     if (profile['information']['status']['admin']) ...[
//                       Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             // border: Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(4),
//                             color: Colors.greenAccent.shade100,
//                           ),
//                           child: const Text('Admin')),
//                       const SizedBox(width: 8),
//                     ],
//
//                     // is moderator
//                     if (profile['information']['status']['moderator']) ...[
//                       Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             // border: Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(4),
//                             color: Colors.blue.shade100,
//                           ),
//                           child: const Text('Moderator')),
//                       const SizedBox(width: 8),
//                     ],
//
//                     // is cr
//                     if (profile['information']['status']['cr']) ...[
//                       Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             // border: Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(4),
//                             color: Colors.orange.shade100,
//                           ),
//                           child: const Text('CR')),
//                       const SizedBox(width: 8),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           //
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               //admin
//               PopupMenuItem(
//                 value: 1,
//                 onTap: () async {
//                   //
//                   if (profile['information']['status']['admin']) {
//                     //remove as moderator
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': false,
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   } else {
//                     //add as admin
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': true,
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   }
//                 },
//                 child: (profile['information']['status']['admin'])
//                     ? const Text('Remove as Admin')
//                     : const Text('Add as Admin'),
//               ),
//
//               //moderator
//               PopupMenuItem(
//                 value: 2,
//                 onTap: () async {
//                   //
//                   if (profile['information']['status']['moderator']) {
//                     //remove as moderator
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': false,
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   } else {
//                     //add as admin
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': true,
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   }
//                 },
//                 child: (profile['information']['status']['moderator'])
//                     ? const Text('Remove as Moderator')
//                     : const Text('Add as Moderator'),
//               ),
//
//               //cr
//               PopupMenuItem(
//                 value: 3,
//                 onTap: () async {
//                   // cr
//                   if (profile['information']['status']['cr']) {
//                     //remove as moderator
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': false,
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   } else {
//                     //add as admin
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': true,
//                           'subscriber': profile['information']['status']
//                               ['subscriber'],
//                         }
//                       },
//                     });
//                   }
//                 },
//                 child: (profile['information']['status']['cr'])
//                     ? const Text('Remove as CR')
//                     : const Text('Add as CR'),
//               ),
//
//               //pro/basic
//               PopupMenuItem(
//                 value: 4,
//                 onTap: () async {
//                   // cr
//                   if (profile['information']['status']['subscriber'] == 'pro') {
//                     //remove as moderator
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': 'basic',
//                         }
//                       },
//                     });
//                   } else {
//                     //add as admin
//                     FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(profile['uid'])
//                         .update({
//                       'information': {
//                         'batch': profile['information']['batch'],
//                         'id': profile['information']['id'],
//                         'session': profile['information']['session'],
//                         'hall': profile['information']['hall'],
//                         'blood': profile['information']['blood'],
//                         'status': {
//                           'admin': profile['information']['status']['admin'],
//                           'moderator': profile['information']['status']
//                               ['moderator'],
//                           'cr': profile['information']['status']['cr'],
//                           'subscriber': 'pro',
//                         }
//                       },
//                     });
//                   }
//                 },
//                 child: (profile['information']['status']['subscriber'] == 'pro')
//                     ? const Text('Remove as Pro')
//                     : const Text('Add as Pro'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

//// ========

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UsersScreen> createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   String search = "";
//   String total = "";
//
//   List universityList = [];
//   String? _selectedUniversity;
//   String? _selectedDepartment;
//
//   // Pagination
//   final int _limit = 20;
//   bool _hasMore = true;
//   bool _isLoading = false;
//   DocumentSnapshot? _lastDocument;
//   List<DocumentSnapshot> _users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getUniversityList();
//     _loadUsers(reset: true); // load default users
//   }
//
//   getUniversityList() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('Universities').get();
//     setState(() {
//       universityList = snapshot.docs.map((doc) => doc.id).toList();
//     });
//   }
//
//   Future<void> _loadUsers({bool reset = false}) async {
//     if (_isLoading) return;
//
//     if (reset) {
//       _lastDocument = null;
//       _users.clear();
//       _hasMore = true;
//     }
//
//     if (!_hasMore) return;
//
//     setState(() => _isLoading = true);
//
//     Query query = FirebaseFirestore.instance.collection('users');
//
//     if (_selectedUniversity != null) {
//       query = query.where('university', isEqualTo: _selectedUniversity);
//     }
//     if (_selectedDepartment != null) {
//       query = query.where('department', isEqualTo: _selectedDepartment);
//     }
//
//     query = query.orderBy('name').limit(_limit);
//
//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }
//
//     final snapshot = await query.get();
//
//     if (snapshot.docs.length < _limit) {
//       _hasMore = false;
//     }
//
//     if (snapshot.docs.isNotEmpty) {
//       _lastDocument = snapshot.docs.last;
//       _users.addAll(snapshot.docs);
//     }
//
//     setState(() {
//       _isLoading = false;
//       total = '(${_users.length})';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: Text('All Users$total')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // University filter
//                 DropdownButtonFormField(
//                   isExpanded: true,
//                   hint: const Text('Select your university'),
//                   value: _selectedUniversity,
//                   items: universityList
//                       .map((item) =>
//                           DropdownMenuItem(value: item, child: Text(item)))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       _selectedUniversity = val as String?;
//                       _selectedDepartment = null;
//                     });
//                     _loadUsers(reset: true);
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 // Department filter
//                 if (_selectedUniversity != null)
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('Universities')
//                         .doc(_selectedUniversity)
//                         .collection('Departments')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) return const SizedBox();
//                       final docs = snapshot.data!.docs;
//                       return DropdownButtonFormField(
//                         isExpanded: true,
//                         hint: const Text('Select your department'),
//                         value: _selectedDepartment,
//                         items: docs
//                             .map((doc) => DropdownMenuItem(
//                                 value: doc.id, child: Text(doc.id)))
//                             .toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             _selectedDepartment = val as String?;
//                           });
//                           _loadUsers(reset: true);
//                         },
//                       );
//                     },
//                   ),
//                 const SizedBox(height: 12),
//                 // Search field
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: "Search by Student ID",
//                     suffixIcon: Icon(Icons.search),
//                   ),
//                   onChanged: (val) {
//                     setState(() => search = val);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (ScrollNotification scrollInfo) {
//                 if (!_isLoading &&
//                     _hasMore &&
//                     scrollInfo.metrics.pixels ==
//                         scrollInfo.metrics.maxScrollExtent) {
//                   _loadUsers();
//                 }
//                 return false;
//               },
//               child: ListView.builder(
//                 itemCount: _users.length + 1,
//                 itemBuilder: (context, index) {
//                   if (index == _users.length) {
//                     return _isLoading
//                         ? const Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           )
//                         : const SizedBox();
//                   }
//
//                   Map<String, dynamic> data =
//                       _users[index].data() as Map<String, dynamic>;
//
//                   if (search.isNotEmpty &&
//                       !data['information']['id']
//                           .toString()
//                           .toLowerCase()
//                           .startsWith(search.toLowerCase())) {
//                     return const SizedBox();
//                   }
//
//                   return _userCard(data);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _userCard(Map<String, dynamic> profile) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image & PRO badge
//           Column(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: profile['image'],
//                 imageBuilder: (context, imageProvider) => CircleAvatar(
//                   radius: 28,
//                   backgroundImage: imageProvider,
//                 ),
//                 progressIndicatorBuilder: (context, url, progress) =>
//                     const CircleAvatar(
//                   radius: 28,
//                   backgroundImage:
//                       AssetImage('assets/images/pp_placeholder.png'),
//                   child: CupertinoActivityIndicator(),
//                 ),
//                 errorWidget: (context, url, error) => const CircleAvatar(
//                   radius: 28,
//                   backgroundImage:
//                       AssetImage('assets/images/pp_placeholder.png'),
//                 ),
//               ),
//               if (profile['information']['status']['subscriber'] == 'pro')
//                 Row(
//                   children: const [
//                     Icon(Icons.check_circle, size: 16, color: Colors.blue),
//                     Text('PRO', style: TextStyle(color: Colors.blue)),
//                   ],
//                 ),
//             ],
//           ),
//           const SizedBox(width: 12),
//           // Info column
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   profile['name'],
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Flexible(
//                         child: Text(profile['information']['batch'],
//                             overflow: TextOverflow.ellipsis)),
//                     const Text(' | '),
//                     Flexible(
//                         child: Text(profile['information']['id'],
//                             style: const TextStyle(
//                                 color: Colors.redAccent,
//                                 fontWeight: FontWeight.bold),
//                             overflow: TextOverflow.ellipsis)),
//                     const Text(' | '),
//                     Flexible(
//                         child: Text(profile['information']['session'],
//                             overflow: TextOverflow.ellipsis)),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(profile['email'], overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 4),
//                 // Roles
//                 Wrap(
//                   spacing: 8,
//                   children: [
//                     if (profile['information']['status']['admin'])
//                       _roleBadge('Admin', Colors.greenAccent.shade100),
//                     if (profile['information']['status']['moderator'])
//                       _roleBadge('Moderator', Colors.blue.shade100),
//                     if (profile['information']['status']['cr'])
//                       _roleBadge('CR', Colors.orange.shade100),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               _buildPopupItem(profile, 'admin', 'Admin'),
//               _buildPopupItem(profile, 'moderator', 'Moderator'),
//               _buildPopupItem(profile, 'cr', 'CR'),
//               _buildPopupItem(profile, 'subscriber', 'Pro'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _roleBadge(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration:
//           BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
//       child: Text(text),
//     );
//   }
//
//   PopupMenuItem _buildPopupItem(
//       Map<String, dynamic> profile, String key, String title) {
//     bool status = key == 'subscriber'
//         ? profile['information']['status'][key] == 'pro'
//         : profile['information']['status'][key];
//
//     return PopupMenuItem(
//       value: key,
//       onTap: () async {
//         dynamic newValue =
//             key == 'subscriber' ? (status ? 'basic' : 'pro') : !status;
//
//         final updatedStatus =
//             Map<String, dynamic>.from(profile['information']['status']);
//         updatedStatus[key] = newValue;
//
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(profile['uid'])
//             .update({
//           'information': {...profile['information'], 'status': updatedStatus}
//         });
//
//         _loadUsers(reset: true);
//       },
//       child: Text(status ? 'Remove as $title' : 'Add as $title'),
//     );
//   }
// }

// todo: ---

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String search = "";
  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;

  // Pagination
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  List<DocumentSnapshot> _users = [];

  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    getUniversityList();
    _loadUsers(reset: true); // load default users
    _fetchTotalCount();
  }

  // Fetch universities
  getUniversityList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Universities').get();
    setState(() {
      universityList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  // Fetch total count independent of pagination
  Future<void> _fetchTotalCount() async {
    Query query = FirebaseFirestore.instance.collection('users');

    if (_selectedUniversity != null) {
      query = query.where('university', isEqualTo: _selectedUniversity);
    }
    if (_selectedDepartment != null) {
      query = query.where('department', isEqualTo: _selectedDepartment);
    }

    final snapshot = await query.get();
    final count = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = (data['name'] ?? '').toString().toLowerCase();
      final id = (data['information']['id'] ?? '').toString().toLowerCase();
      final s = search.toLowerCase();
      return s.isEmpty || name.contains(s) || id.contains(s);
    }).length;

    setState(() {
      _totalCount = count;
    });
  }

  Future<void> _loadUsers({bool reset = false, bool searchMode = false}) async {
    if (_isLoading) return;

    if (reset) {
      _lastDocument = null;
      _users.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance.collection('users');

    if (_selectedUniversity != null) {
      query = query.where('university', isEqualTo: _selectedUniversity);
    }
    if (_selectedDepartment != null) {
      query = query.where('department', isEqualTo: _selectedDepartment);
    }

    query = query.orderBy('name').limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.length < _limit) {
      _hasMore = false;
    }

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      _users.addAll(snapshot.docs);
    }

    setState(() => _isLoading = false);

    // If in search mode, auto-load more until we find a match or no more
    if (searchMode && search.isNotEmpty) {
      final matches = _users.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = (data['name'] ?? '').toString().toLowerCase();
        final id = (data['information']['id'] ?? '').toString().toLowerCase();
        return name.contains(search.toLowerCase()) ||
            id.contains(search.toLowerCase());
      }).toList();

      if (matches.isEmpty && _hasMore) {
        await _loadUsers(searchMode: true); // fetch next page automatically
      }
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('All Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // University filter
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: const Text('Select University'),
                    initialValue: _selectedUniversity,
                    isDense: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16),
                      border: OutlineInputBorder(),
                    ),
                    items: universityList
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                            )))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedUniversity = val as String?;
                        _selectedDepartment = null;
                      });
                      _loadUsers(reset: true);
                      _fetchTotalCount();
                    },
                  ),
                ),

                if (_selectedUniversity != null) const SizedBox(height: 12),

                // Department filter
                if (_selectedUniversity != null)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Universities')
                        .doc(_selectedUniversity)
                        .collection('Departments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final docs = snapshot.data!.docs;
                      return ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text('Select Department'),
                          initialValue: _selectedDepartment,
                          isDense: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16),
                            border: OutlineInputBorder(),
                          ),
                          items: docs
                              .map((doc) => DropdownMenuItem(
                                  value: doc.id, child: Text(doc.id)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedDepartment = val as String?;
                            });
                            _loadUsers(reset: true);
                            _fetchTotalCount();
                          },
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 12),

                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search by Name or Student ID",
                    suffixIcon: _searchController.text.isEmpty
                        ? const Icon(Icons.search)
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                search = "";
                              });
                              _loadUsers(reset: true, searchMode: true);
                              _fetchTotalCount();
                            },
                          ),
                    contentPadding: const EdgeInsets.only(left: 16),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() => search = val);
                    _loadUsers(reset: true, searchMode: true);
                    _fetchTotalCount();
                  },
                ),

                const SizedBox(height: 16),
                // Total counter
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Users: $_totalCount',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    _hasMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  _loadUsers();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _users.length + 1,
                itemBuilder: (context, index) {
                  if (index == _users.length) {
                    return _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CupertinoActivityIndicator()),
                          )
                        : const SizedBox();
                  }

                  Map<String, dynamic> data =
                      _users[index].data() as Map<String, dynamic>;

                  // filter by search
                  if (search.isNotEmpty) {
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final id = (data['information']['id'] ?? '')
                        .toString()
                        .toLowerCase();
                    if (!name.contains(search.toLowerCase()) &&
                        !id.contains(search.toLowerCase())) {
                      return const SizedBox();
                    }
                  }

                  return _userCard(data);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard(Map<String, dynamic> profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Stack(
        alignment: AlignmentGeometry.topRight,
        children: [
          //info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image & PRO badge
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Column(
                    spacing: 6,
                    children: [
                      CachedNetworkImage(
                        imageUrl: profile['image'],
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 28,
                          backgroundImage: imageProvider,
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            const CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png'),
                          child: CupertinoActivityIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png'),
                        ),
                      ),
                      if (profile['information']['status']['subscriber'] ==
                          'pro')
                        const Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.blue),
                            Text('PRO', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                    ],
                  ),

                  //
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile['name'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(profile['department'] ?? '',
                            overflow: TextOverflow.ellipsis),
                        Text(
                          profile['university'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                                child: Text(
                                    profile['information']['batch'] ?? '',
                                    overflow: TextOverflow.ellipsis)),
                            const Text(' | '),
                            Flexible(
                                child: Text(profile['information']['id'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis)),
                            const Text(' | '),
                            Flexible(
                                child: Text(
                                    profile['information']['session'] ?? '',
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Info column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //

                  Text('Mobile: ${profile['mobile']}',
                      overflow: TextOverflow.ellipsis),
                  Text('Email: + ${profile['email']}',
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (profile['information']['status']['admin'])
                        _roleBadge('Admin', Colors.greenAccent.shade100),
                      if (profile['information']['status']['moderator'])
                        _roleBadge('Moderator', Colors.blue.shade100),
                      if (profile['information']['status']['cr'])
                        _roleBadge('CR', Colors.orange.shade100),

                      //
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('contributors')
                            .doc(profile['uid'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            return _roleBadge(
                                'Contributor', Colors.blueGrey.shade100);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // menu
          PopupMenuButton(
            itemBuilder: (context) => [
              _buildPopupItem(profile, 'admin', 'Admin'),
              _buildPopupItem(profile, 'moderator', 'Moderator'),
              _buildPopupItem(profile, 'cr', 'CR'),
              _buildPopupItem(profile, 'subscriber', 'Pro'),
              _buildPopupItem(profile, 'contributor', 'Contributor'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(text),
    );
  }

  //
  PopupMenuItem _buildPopupItem(
      Map<String, dynamic> profile, String key, String title) {
    bool status = key == 'subscriber'
        ? profile['information']['status'][key] == 'pro'
        : (profile['information']['status'][key] ?? false);

    return PopupMenuItem(
      value: key,
      onTap: () async {
        if (key == 'contributor') {
          final contributorRef = FirebaseFirestore.instance
              .collection('contributors')
              .doc(profile['uid']);

          if (status) {
            await contributorRef.delete();
          } else {
            await contributorRef.set({
              'uid': profile['uid'],
              'addedAt': FieldValue.serverTimestamp(),
            });
          }
        } else {
          dynamic newValue =
              key == 'subscriber' ? (status ? 'basic' : 'pro') : !status;

          final updatedStatus =
              Map<String, dynamic>.from(profile['information']['status']);
          updatedStatus[key] = newValue;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(profile['uid'])
              .update({
            'information': {...profile['information'], 'status': updatedStatus}
          });
        }

        _loadUsers(reset: true);
        _fetchTotalCount();
      },
      child: Text(status ? 'Remove as $title' : 'Add as $title'),
    );
  }
}
