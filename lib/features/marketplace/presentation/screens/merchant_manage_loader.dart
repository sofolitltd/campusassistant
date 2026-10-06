import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../../data/models/merchant.dart';
import '../providers/marketplace_provider.dart';
import 'merchant_manage_screen.dart';

/// Opens [MerchantManageScreen] when only a merchant id is known — e.g. from
/// a new-order push notification, which can't carry a [Merchant] object.
class MerchantManageLoader extends ConsumerWidget {
  final String merchantId;
  const MerchantManageLoader({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchants = ref.watch(myMerchantsProvider);
    return merchants.when(
      data: (list) {
        final match = list.cast<Merchant?>().firstWhere(
          (m) => m!.id == merchantId,
          orElse: () => null,
        );
        if (match == null) return _Message('This business was not found.');
        return MerchantManageScreen(merchant: match);
      },
      loading: () => const Scaffold(
        body: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => _Message('Could not load your business.'),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message(this.text);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Center(
      child: Text(text, style: TextStyle(color: context.colors.textMuted)),
    ),
  );
}
