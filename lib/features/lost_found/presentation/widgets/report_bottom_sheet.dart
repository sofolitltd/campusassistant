import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/lost_found_provider.dart';

const _reportReasons = [
  'Spam or advertisement',
  'Fraudulent / fake claim',
  'Duplicate post',
  'Inappropriate content',
  'Other',
];

/// Options-menu-style report flow: pick a reason, confirm, submit — same
/// bottom-sheet-with-ListTile convention used across the app (e.g. community
/// post options menu).
Future<bool?> showReportBottomSheet(BuildContext context, WidgetRef ref, String itemId) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (context) => _ReportSheet(itemId: itemId, ref: ref),
  );
}

class _ReportSheet extends StatefulWidget {
  final String itemId;
  final WidgetRef ref;
  const _ReportSheet({required this.itemId, required this.ref});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  bool _submitting = false;

  Future<void> _report(String reason) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report this item?'),
        content: Text('Reason: $reason\n\nOur team will review it shortly.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Report')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _submitting = true);
    try {
      await widget.ref.read(lostFoundActionsProvider).reportItem(widget.itemId, reason);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Report item', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          if (_submitting)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            )
          else
            ..._reportReasons.map(
              (reason) => ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(reason),
                onTap: () => _report(reason),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
