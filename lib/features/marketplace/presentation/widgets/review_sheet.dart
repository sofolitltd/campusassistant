import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../../data/models/review.dart';
import '../providers/reviews_provider.dart';
import 'rating_widgets.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Bottom sheet to write or edit a review. Returns true when saved/deleted.
Future<bool?> showReviewSheet(
  BuildContext context, {
  required String productId,
  required String productTitle,
  Review? existing,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReviewSheet(productId: productId, productTitle: productTitle, existing: existing),
  );
}

class _ReviewSheet extends ConsumerStatefulWidget {
  final String productId;
  final String productTitle;
  final Review? existing;
  const _ReviewSheet({required this.productId, required this.productTitle, this.existing});

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  late int _rating = widget.existing?.rating ?? 0;
  late final _comment = TextEditingController(text: widget.existing?.comment ?? '');
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Could not save your review. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existing == null ? 'Rate this product' : 'Edit your review',
            style: TextStyle(fontSize: FontSizeToken.xl, fontWeight: FontWeight.w800, color: c.text),
          ),
          const SizedBox(height: Spacing.xs),
          Text(widget.productTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c.textMuted)),
          const SizedBox(height: Spacing.lg),
          Center(child: StarPicker(value: _rating, onChanged: (v) => setState(() => _rating = v))),
          const SizedBox(height: Spacing.lg),
          TextField(
            controller: _comment,
            maxLines: 4,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Share what you liked or what could be better (optional)'),
          ),
          if (_error != null) ...[
            const SizedBox(height: Spacing.xs),
            Text(_error!, style: TextStyle(color: c.danger, fontSize: FontSizeToken.sm)),
          ],
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              if (widget.existing != null)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() => deleteReview(ref, productId: widget.productId)),
                  child: Text('Delete', style: TextStyle(color: c.danger)),
                ),
              const Spacer(),
              FilledButton(
                onPressed: _busy || _rating == 0
                    ? null
                    : () => _run(() => submitReview(ref,
                        productId: widget.productId, rating: _rating, comment: _comment.text.trim())),
                child: Text(_busy ? 'Saving…' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
