import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'expired_subscriber.dart';

class SubscriptionMainPage extends StatelessWidget {
  const SubscriptionMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('subscriptions')
            .orderBy('startDate', descending: true)
            .snapshots(),
        builder: (context, subsSnapshot) {
          if (!subsSnapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final allSubs = subsSnapshot.data!.docs;

          // Count expired subscriptions
          final expiredSubs = allSubs.where((doc) {
            final endDate = (doc['endDate'] as Timestamp?)?.toDate();
            return endDate != null && endDate.isBefore(now);
          }).toList();

          // add total amount , amount as string in firebase,
          int totalAmount = 0;
          for (var doc in allSubs) {
            final amount = int.parse(doc['amount']);
            totalAmount += amount;
          }

          // total subscribers
          int totalSubscribers = allSubs.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Expired subscription card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExpiredSubscriptionsPage(expiredSubs: expiredSubs),
                    ),
                  );
                },
                child: Card(
                  color: Colors.red.shade100,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Expired Subscriptions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${expiredSubs.length}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Subscribers: $totalSubscribers'),
                    Text('Total Earning: $totalAmount'),
                  ],
                ),
              ),
              // List of all subscriptions
              Expanded(
                child: ListView.builder(
                  itemCount: allSubs.length,
                  itemBuilder: (context, index) {
                    final doc = allSubs[index];
                    final uid = doc.id;
                    final subscription = doc['subscription'];
                    final amount = doc['amount'];
                    final start = (doc['startDate'] as Timestamp?)?.toDate();
                    final end = (doc['endDate'] as Timestamp?)?.toDate();
                    final isExpired = end != null && end.isBefore(now);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox(height: 80);
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>?;
                        if (userData == null) return const SizedBox();

                        final name = userData['name'] ?? '';
                        final imageUrl = userData['image'] ?? '';
                        final university = userData['university'] ?? '';
                        final department = userData['department'] ?? '';
                        final batch = userData['information']['batch'] ?? '';
                        final subscriber = userData['information']['status']
                                ['subscriber'] ??
                            '';

                        //
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ExpansionTile(
                            leading: imageUrl == ''
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/pp_placeholder.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            title: Text("$name",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                //baseline
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,

                                children: [
                                  Text(start != null
                                      ? DateFormat('dd-MM-yyyy h:mm a')
                                          .format(start)
                                      : 'N/A'),
                                  const SizedBox(width: 8),
                                  Text("|"),
                                  const SizedBox(width: 8),
                                  Text("$subscription"),
                                  const SizedBox(width: 8),
                                  Text(" Pay:  $amount৳"),
                                  const SizedBox(width: 8),
                                  if (isExpired)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: const Text(
                                        "Expired",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            height: 1),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$university"),
                                    Text("$department"),
                                    Text(
                                        "$batch | ${subscriber.toUpperCase()}"),
                                    const Divider(),
                                    Row(
                                      // spacing: 8,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Start on: ${start != null ? DateFormat('yyyy-MM-dd').format(start) : 'N/A'}"),
                                              Text(
                                                  "End on: ${end != null ? DateFormat('yyyy-MM-dd').format(end) : 'Lifetime'}"),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Edit button
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                _showEditDialog(context, uid,
                                                    subscription, start, end);
                                              },
                                            ),
                                            // Delete button
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                final confirm =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        "Confirm Delete"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this subscription and reset to basic?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child: const Text(
                                                            "Delete"),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm == true) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'subscriptions')
                                                      .doc(uid)
                                                      .delete();

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(uid)
                                                      .update({
                                                    'information.status.subscriber':
                                                        'basic',
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "Subscription deleted and reset to basic")),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //
  void _showEditDialog(BuildContext context, String uid, String currentPlan,
      DateTime? start, DateTime? end) {
    final plans = ["1 Year", "2 Year", "3 Year", "Lifetime"];
    String selectedPlan = currentPlan;
    DateTime? startDate = start ?? DateTime.now();
    DateTime? endDate = end;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Edit Subscription"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Plan dropdown
                  DropdownButton<String>(
                    value: selectedPlan,
                    isExpanded: true,
                    items: plans.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedPlan = val!;
                        if (val == "Lifetime") {
                          endDate = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Start date picker
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              "Start: ${DateFormat('yyyy-MM-dd').format(startDate!)}")),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate!,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => startDate = picked);
                          }
                        },
                      )
                    ],
                  ),

                  // End date picker (if not lifetime)
                  if (selectedPlan != "Lifetime")
                    Row(
                      children: [
                        Expanded(
                            child: Text(endDate != null
                                ? "End: ${DateFormat('yyyy-MM-dd').format(endDate!)}"
                                : "No End Date")),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                        )
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('subscriptions')
                      .doc(uid)
                      .update({
                    'plan': selectedPlan,
                    'startDate': Timestamp.fromDate(startDate!),
                    'endDate': selectedPlan == "Lifetime" || endDate == null
                        ? null
                        : Timestamp.fromDate(endDate!),
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Subscription updated")),
                  );
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }
}
