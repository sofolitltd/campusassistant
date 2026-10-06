import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/features/student/domain/entities/student.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.selectedBatch,
    required this.studentModel,
  });

  final String selectedBatch;
  final Student studentModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                  child: studentModel.imageUrl.isEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                          child: Image.asset(
                            'assets/images/pp_placeholder.png',
                            fit: .cover,
                            height: 88,
                            width: 80,
                          ),
                        )
                      : CachedNetworkImage(
                          fit: .cover,
                          height: 88,
                          width: 80,
                          imageUrl: ApiEndpoints.resolveImageUrl(
                            studentModel.imageUrl,
                          ),
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              fit: .cover,
                              height: 88,
                              width: 80,
                            ),
                          ),
                          errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              fit: .cover,
                              height: 88,
                              width: 80,
                            ),
                          ),
                        ),
                ),
                if (studentModel.isClaimed)
                  Icon(Icons.verified, color: context.colors.success, size: 16),
              ],
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    studentModel.name,
                    overflow: .ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: .bold,
                      fontSize: FontSizeToken.base,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),

                  Row(
                    spacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: .start,
                        spacing: 6,
                        children: [
                          Container(
                            padding: const .symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                RadiusToken.xs,
                              ),
                              color: context.colors.border,
                            ),
                            child: Text(
                              studentModel.batch,
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(fontSize: FontSizeToken.xxs),
                            ),
                          ),

                          Container(
                            padding: const .symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                RadiusToken.xs,
                              ),
                              color: context.colors.border,
                            ),
                            child: Text(
                              studentModel.session,
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(fontSize: FontSizeToken.xxs),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        '|',
                        style: TextStyle(
                          color: context.colors.textSubtle,
                          fontSize: FontSizeToken.sm,
                          height: 1.2,
                        ),
                      ),
                      //
                      Row(
                        crossAxisAlignment: .start,
                        spacing: 6,
                        children: [
                          Text(
                            'Blood:',
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: context.colors.textMuted,
                                  fontSize: FontSizeToken.sm,
                                ),
                          ),
                          Text(
                            studentModel.bloodGroup,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontWeight: .w600,
                                  color: context.colors.danger,
                                  fontSize: FontSizeToken.sm,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: Spacing.sm),

                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        'Student Id:',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: context.colors.textMuted,
                          fontSize: FontSizeToken.sm,
                        ),
                      ),
                      Text(
                        studentModel.studentId,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: .w600,
                          color: context.colors.text,
                          fontSize: FontSizeToken.sm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),

                  if (studentModel.hall != 'None') ...[
                    const SizedBox(height: Spacing.xxs),
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Hall: ',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: context.colors.textMuted,
                                fontSize: FontSizeToken.sm,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            studentModel.hall,
                            overflow: .ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontWeight: .w600,
                                  color: context.colors.text,
                                  fontSize: FontSizeToken.sm,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
