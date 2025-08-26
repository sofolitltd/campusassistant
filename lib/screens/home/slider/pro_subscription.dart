import 'package:flutter/cupertino.dart';

import '/bkash/bkash_payment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<Map<String, dynamic>> proFeatures = [
  {'title': 'N0 long Ads'},
  {'title': 'Access All Premium Content'},
  {'title': 'Offline Mode'},
  {'title': 'Early Access to New Features'},
  {'title': 'Priority Support'},
];

final List<Map<String, dynamic>> subscriptionPlans = [
  {
    'title': '1 Year',
    'price': 50,
    'mainPrice': 50,
    'discount': '0%',
  },
  {
    'title': '2 Year',
    'price': 90,
    'mainPrice': 100,
    'discount': '10%',
  },
  {
    'title': '3 Year',
    'price': 130,
    'mainPrice': 150,
    'discount': '13%',
  },
  {
    'title': 'Lifetime',
    'price': 200,
    'mainPrice': 250,
    'discount': '20%',
  },
];

class ProSubscriptionPage extends StatefulWidget {
  const ProSubscriptionPage({super.key});

  @override
  State<ProSubscriptionPage> createState() => _ProSubscriptionPageState();
}

class _ProSubscriptionPageState extends State<ProSubscriptionPage> {
  String selectedPlan = subscriptionPlans.first['title'];
  String selectedPlanPrice = subscriptionPlans.first['price'].toString();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Pro'),
        centerTitle: true,
      ),

      //
      body: _isLoading
          ? Container(
              color: Colors.white.withValues(alpha: 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please Wait',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 24),
                  const CupertinoActivityIndicator(radius: 20),
                  const SizedBox(height: 12),
                  Text(
                    'Redirecting....',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Go Pro?',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: proFeatures
                            .map((feature) => Row(
                                  children: [
                                    const Icon(Icons.check,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(feature['title'])),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Subscription Option',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subscriptionPlans.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final plan = subscriptionPlans[index];
                      bool isSelected = selectedPlan == plan['title'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPlan = plan['title'];
                            selectedPlanPrice = plan['price'].toString();
                          });
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.orange.shade200
                                        : Colors.orange.shade50,
                                    width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    plan['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '৳${plan['mainPrice']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '৳${plan['price']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.fromLTRB(8, 2, 8, 5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Save ${plan['discount']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    'Payment Method',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        width: double.maxFinite,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            Image.asset(
                              'assets/images/bkash_logo.png',
                              height: 40,
                            ),
                            const SizedBox(),
                          ],
                        )),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              Fluttertoast.showToast(
                                msg:
                                    'Proceed to Bkash payment for $selectedPlan plan',
                              );

                              setState(() {
                                _isLoading = true;
                              });

                              // todo: change [isProduction = true] before publish app
                              await Bkash.payment(
                                context,
                                isProduction: true,
                                amount: selectedPlanPrice,
                                subscriptionPlan: selectedPlan,
                              );

                              setState(() {
                                _isLoading = false;
                              });

                              // 123456
                              // 12121
                            },
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Subscribe'),
                          _isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
