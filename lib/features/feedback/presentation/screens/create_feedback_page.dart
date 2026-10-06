import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/feedback/presentation/providers/feedback_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_control.dart';

class CreateFeedbackPage extends ConsumerStatefulWidget {
  const CreateFeedbackPage({super.key});

  @override
  ConsumerState<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends ConsumerState<CreateFeedbackPage> {
  final _categoryController = ValueNotifier<String>('general');
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  static const _categories = [
    ('bug', 'Bug Report', LucideIcons.bug, AccentToken.red),
    ('feature', 'Feature Request', LucideIcons.sparkles, AccentToken.violet),
    ('suggestion', 'Suggestion', LucideIcons.lightbulb, AccentToken.amber),
    ('complaint', 'Complaint', LucideIcons.alertTriangle, AccentToken.orange),
    ('general', 'General', LucideIcons.messageSquare, AccentToken.gray),
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in subject and message')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ref.read(feedbackRepositoryProvider);
      await repo.createFeedback(
        category: _categoryController.value,
        subject: subject,
        message: message,
      );
      if (!mounted) return;
      ref.invalidate(myFeedbacksProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted! Thank you.'),
          backgroundColor: Color(0xFF059669),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Send Feedback'), centerTitle: true),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text(
            'What kind of feedback do you have?',
            style: TextStyle(fontSize: FontSizeToken.lg, fontWeight: .w600),
          ),
          const SizedBox(height: Spacing.lg),
          ValueListenableBuilder<String>(
            valueListenable: _categoryController,
            builder: (_, selected, _) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((c) {
                final isSelected = selected == c.$1;
                return GestureDetector(
                  onTap: () => _categoryController.value = c.$1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.lg,
                      vertical: Spacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? c.$4.withValues(alpha: 0.15)
                          : (context.colors.surfaceAlt),
                      borderRadius: BorderRadius.circular(RadiusToken.full),
                      border: Border.all(
                        color: isSelected
                            ? c.$4
                            : (context.colors.borderStrong),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(c.$3, size: 16, color: isSelected ? c.$4 : null),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          c.$2,
                          style: TextStyle(
                            fontSize: FontSizeToken.md,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? c.$4 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: Spacing.xxl),
          const Text(
            'Subject',
            style: TextStyle(fontSize: FontSizeToken.base, fontWeight: .w500),
          ),
          const SizedBox(height: Spacing.sm),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Brief title for your feedback',
            ),
            textCapitalization: .sentences,
          ),
          const SizedBox(height: Spacing.xl),
          const Text(
            'Message',
            style: TextStyle(fontSize: FontSizeToken.base, fontWeight: .w500),
          ),
          const SizedBox(height: Spacing.sm),
          TextField(
            controller: _messageController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Describe your feedback or issue in detail...',
              alignLabelWithHint: true,
            ),
            textCapitalization: .sentences,
          ),
          const SizedBox(height: Spacing.xxxl),
          SizedBox(
            width: double.infinity,
            height: ControlToken.height,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.onPrimary,
                      ),
                    )
                  : const Text(
                      'Submit feedback',
                      style: TextStyle(
                        fontSize: FontSizeToken.lg,
                        fontWeight: .bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
