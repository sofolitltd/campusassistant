import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExpiredSubscriptionsPage extends StatefulWidget {
  const ExpiredSubscriptionsPage(
      {super.key, required List<QueryDocumentSnapshot<Object?>> expiredSubs});

  @override
  State<ExpiredSubscriptionsPage> createState() =>
      _ExpiredSubscriptionsPageState();
}

class _ExpiredSubscriptionsPageState extends State<ExpiredSubscriptionsPage> {
  final Set<String> selectedUIDs = {};
  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expired Subscriptions"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('subscriptions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allSubs = snapshot.data!.docs;

                // Filter expired
                final expiredSubs = allSubs.where((doc) {
                  final endDate = (doc['endDate'] as Timestamp?)?.toDate();
                  return endDate != null && endDate.isBefore(now);
                }).toList();

                if (expiredSubs.isEmpty) {
                  return const Center(child: Text("No expired subscriptions"));
                }

                return ListView.builder(
                  itemCount: expiredSubs.length,
                  itemBuilder: (context, index) {
                    final doc = expiredSubs[index];
                    final uid = doc.id;
                    final subscription = doc['subscription'];
                    final end = (doc['endDate'] as Timestamp?)?.toDate();
                    final isSelected = selectedUIDs.contains(uid);
                    final start = (doc['startDate'] as Timestamp?)?.toDate();
                    final isExpired = end != null && end.isBefore(now);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox(
                            height: 80,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>?;

                        if (userData == null) return const SizedBox();

                        final name = userData['name'] ?? '';
                        final university = userData['university'] ?? '';
                        final department = userData['department'] ?? '';
                        final batch = userData['information']['batch'] ?? '';

                        return Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            tileColor: isSelected ? Colors.red.shade100 : null,
                            title: Text("$name"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$university"),
                                Text("$department"),
                                Text("$batch"),

                                const Divider(),

                                //
                                Row(
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Subscription: $subscription",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Start on: ${start != null ? DateFormat('yyyy-MM-dd').format(start) : 'N/A'}"),
                                          Text(
                                              "End on: ${end != null ? DateFormat('yyyy-MM-dd').format(end) : 'Lifetime'}"),
                                        ],
                                      ),
                                    ),
                                    if (isExpired)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: const Text(
                                          "Expired",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    selectedUIDs.add(uid);
                                  } else {
                                    selectedUIDs.remove(uid);
                                  }
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedUIDs.remove(uid);
                                } else {
                                  selectedUIDs.add(uid);
                                }
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: selectedUIDs.isEmpty
                  ? null
                  : () async {
                      for (String uid in selectedUIDs) {
                        // Update user to basic
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({'information.status.subs': 'basic'});

                        // Delete subscription doc
                        await FirebaseFirestore.instance
                            .collection('subscriptions')
                            .doc(uid)
                            .delete();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Selected subscriptions updated to basic")),
                      );

                      setState(() {
                        selectedUIDs.clear();
                      });
                    },
              child: const Text("Execute Change"),
            ),
          ),
        ],
      ),
    );
  }
}
