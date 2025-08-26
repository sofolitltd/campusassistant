import 'package:campusassistant/screens/home/slider/pro_subscription.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SliderSection extends StatelessWidget {
  const SliderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProSubscriptionPage()));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            // height: 100,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                //
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Become a Pro User'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),

                    //
                    Text(
                      'আমাদের অ্যাপে গুগল হোস্টিং ব্যবহৃত হচ্ছে। ফলে হোস্টিং খরচ ও রক্ষণাবেক্ষণ দিন দিন কঠিন হয়ে পড়ছে। তাই প্রজেক্টটি সচল রাখতে সকলের সহযোগিতা একান্ত কাম্য। অনুগ্রহ করে সাবস্ক্রাইব করে পাশে থাকুন। ধন্যবাদ।',
                      style: GoogleFonts.tiroBangla(
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),

                //
                Icon(
                  Icons.diamond_outlined,
                  size: 32,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
