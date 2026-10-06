import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '../providers/wishlist_provider.dart';

/// A heart that saves/unsaves a product. [overlay] draws it as a small round
/// chip for sitting on top of a product photo.
class WishlistButton extends ConsumerWidget {
  final String productId;
  final bool overlay;
  final double size;
  const WishlistButton({super.key, required this.productId, this.overlay = false, this.size = 18});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final saved = ref.watch(wishlistIdsProvider.select((s) => s.contains(productId)));
    final icon = Icon(
      saved ? Icons.favorite_rounded : LucideIcons.heart,
      size: size,
      color: saved ? c.danger : (overlay ? c.text : c.textSubtle),
    );

    Future<void> onTap() async {
      final ok = await ref.read(wishlistIdsProvider.notifier).toggle(productId);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Could not update your wishlist.')));
      }
    }

    if (!overlay) {
      return IconButton(
        tooltip: saved ? 'Remove from wishlist' : 'Save for later',
        onPressed: onTap,
        icon: icon,
      );
    }
    return Material(
      color: c.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(7), child: icon),
      ),
    );
  }
}
