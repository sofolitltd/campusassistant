import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/department/presentation/providers/department_provider.dart';
import '../features/university/presentation/providers/university_provider.dart';

class Breadcrumbs extends ConsumerWidget {
  const Breadcrumbs({super.key, this.leftPadding});
  final double? leftPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.maybeOf(context);
    if (router == null) return const SizedBox.shrink();

    String location = '';
    try {
      location = GoRouterState.of(context).uri.path;
    } catch (e) {
      return const SizedBox.shrink();
    }
    final segments = location.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8, top: 8, left: leftPadding ?? 16),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int i = 0; i < segments.length; i++) ...[
            GestureDetector(
              onTap: i == segments.length - 1
                  ? null
                  : () {
                      final newPath = '/${segments.take(i + 1).join('/')}';
                      context.go(newPath);
                    },
              child: _BreadcrumbText(
                segment: segments[i],
                index: i,
                segments: segments,
                isLast: i == segments.length - 1,
              ),
            ),
            if (i < segments.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right, size: 16),
              ),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbText extends ConsumerWidget {
  const _BreadcrumbText({
    required this.segment,
    required this.index,
    required this.segments,
    required this.isLast,
  });

  final String segment;
  final int index;
  final List<String> segments;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String displayText = _formatSegment(segment);

    // Dynamic resolution for IDs
    if (index > 0) {
      final parent = segments[index - 1];
      if (parent == 'universities') {
        displayText = ref.watch(universityNameProvider(segment));
      } else if (parent == 'departments') {
        // Find university ID (it should be two segments back: /universities/:uId/departments/:dId)
        String? uId;
        for (int j = index - 1; j >= 0; j--) {
          if (segments[j] == 'universities' && j + 1 < segments.length) {
            uId = segments[j + 1];
            break;
          }
        }
        if (uId != null) {
          displayText = ref.watch(departmentNameProvider('$uId|$segment'));
        }
      }
    }

    final cs = Theme.of(context).colorScheme;
    return Text(
      displayText,
      style: TextStyle(
        fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
        color: isLast ? cs.onSurface : cs.onSurfaceVariant,
      ),
    );
  }

  String _formatSegment(String s) {
    if (s.isEmpty) return '';
    
    // Special case for common admin words
    if (s.toLowerCase() == 'admin') return 'Dashboard';

    return s
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
