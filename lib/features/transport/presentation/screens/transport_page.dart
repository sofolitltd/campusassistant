import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/routes/app_route.dart';
import '/features/transport/presentation/providers/transport_provider.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

class TransportPage extends ConsumerWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transportAsync = ref.watch(myTransportsProvider);

    return CustomHeaderLayout(
      title: 'Transport Service',
      showSearchBar: false,
      body: transportAsync.when(
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
        data: (transports) {
          if (transports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    LucideIcons.bus,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No Transports Found',
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
            itemCount: transports.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: Spacing.xl),
            itemBuilder: (context, index) {
              final transport = transports[index];
              final resolvedUrl = ApiEndpoints.resolveImageUrl(transport.image);

              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoute.imageViewer.name,
                    queryParameters: {
                      'title': transport.title,
                      'time': transport.time,
                      'image': transport.image,
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.xl),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow,
                        spreadRadius: 0,
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusToken.xl),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Image Section
                        Hero(
                          tag: 'transport_image_${transport.id}',
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            child: CachedNetworkImage(
                              imageUrl: resolvedUrl,
                              fadeInDuration: const Duration(milliseconds: 300),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: .cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer
                                    .withValues(alpha: 0.1),
                                child: Column(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(
                                      LucideIcons.image,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      size: 36,
                                    ),
                                    const SizedBox(height: Spacing.sm),
                                    Text(
                                      'Could not load transport image',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Text Info Section
                        Padding(
                          padding: const EdgeInsets.all(Spacing.lg),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                transport.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: .bold,
                                      fontSize: FontSizeToken.xl,
                                      height: 1.2,
                                    ),
                                maxLines: 2,
                                overflow: .ellipsis,
                              ),
                              const SizedBox(height: Spacing.sm),

                              // Time section with icon
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.clock,
                                    size: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Text(
                                      transport.time,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
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
            },
          );
        },
      ),
    );
  }
}
