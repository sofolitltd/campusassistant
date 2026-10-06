import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/routes/app_route.dart';
import '/features/routine/presentation/providers/routine_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/routine/domain/entities/routine.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class RoutinePage extends ConsumerWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final universityId = userAsync.value?.information.universityId ?? '';
    final departmentId = userAsync.value?.information.departmentId ?? '';

    final routineAsync = ref.watch(
      routinesProvider((
        universityId: universityId,
        departmentId: departmentId,
      )),
    );

    return CustomHeaderLayout(
      title: 'Class Routine',
      showSearchBar: false,
      body: routineAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    LucideIcons.calendarDays,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No Class Routines Found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Check back later for updates.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
            ),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return RoutineCard(routine: routine);
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: Spacing.xl),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: .bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                e.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: .center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    // Correctly resolve relative image URL to absolute path
    final resolvedUrl = ApiEndpoints.resolveImageUrl(routine.imageUrl);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.imageViewer.name,
          queryParameters: {
            'title': routine.title,
            'time': routine.time,
            'image': routine.imageUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? context.colors.border
                : context.colors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Image Section with premium tag
              Hero(
                tag: 'routine_image_${routine.id}',
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: CachedNetworkImage(
                    imageUrl: resolvedUrl,
                    fadeInDuration: const Duration(milliseconds: 300),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: .cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.errorContainer.withValues(alpha: 0.1),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            LucideIcons.image,
                            color: Theme.of(context).colorScheme.error,
                            size: 36,
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            'Could not load routine image',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Text Info & Action buttons Section
              Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      routine.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.xl,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: Spacing.sm),

                    // Validity / Time section with icon
                    Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            routine.time,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: FontSizeToken.md,
                                  fontWeight: .w500,
                                ),
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
