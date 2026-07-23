import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/lost_found_provider.dart';

/// Bottom sheet for "This is mine" / "I found this" — submits a claim on an
/// item the current user does not own.
Future<bool?> showClaimBottomSheet(BuildContext context, WidgetRef ref, String itemId) {
  final controller = TextEditingController();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _ClaimForm(controller: controller, itemId: itemId, ref: ref),
    ),
  );
}

class _ClaimForm extends StatefulWidget {
  final TextEditingController controller;
  final String itemId;
  final WidgetRef ref;

  const _ClaimForm({required this.controller, required this.itemId, required this.ref});

  @override
  State<_ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends State<_ClaimForm> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.ref
          .read(lostFoundActionsProvider)
          .claimItem(widget.itemId, message: widget.controller.text.trim());
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit claim: $e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Claim this item', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Describe the item or how you can prove it\'s yours (or how/where you found it). '
          'The poster will review your message and, if accepted, a private chat opens automatically.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'e.g. It has a scratch on the back cover...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Submit Claim'),
          ),
        ),
      ],
    );
  }
}
