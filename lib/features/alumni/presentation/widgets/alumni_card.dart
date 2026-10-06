import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/widgets/open_app.dart';
import '/features/alumni/domain/entities/alumni.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class AlumniCard extends StatelessWidget {
  final Alumni alumni;
  const AlumniCard({super.key, required this.alumni});

  void _shareAlumni(Alumni a) {
    final sb = StringBuffer();
    sb.writeln('🎓 Alumni Profile: ${a.fullName}');
    if (a.batch.isNotEmpty) {
      sb.writeln(
        '📅 Batch: ${a.batch}${a.passingYear.isNotEmpty ? " (Passing Year: ${a.passingYear})" : ""}',
      );
    }
    if (a.studentId.isNotEmpty) {
      sb.writeln('🆔 Student ID: ${a.studentId}');
    }
    if (a.bio.isNotEmpty) {
      sb.writeln('💬 Bio: "${a.bio}"');
    }

    sb.writeln('\n💼 Professional Status:');
    sb.writeln('• Status: ${a.currentStatus}');
    if (a.designation.isNotEmpty) {
      sb.writeln('• Designation: ${a.designation}');
    }
    if (a.organization.isNotEmpty) {
      sb.writeln('• Organization: ${a.organization}');
    }
    if (a.location.isNotEmpty) {
      sb.writeln('• Location: ${a.location}');
    }

    if (a.phone.isNotEmpty ||
        a.email.isNotEmpty ||
        (a.socialLinks != null && a.socialLinks!.isNotEmpty)) {
      sb.writeln('\n📞 Contact & Social Links:');
      if (a.phone.isNotEmpty) {
        sb.writeln('• Phone: ${a.phone}');
      }
      if (a.email.isNotEmpty) {
        sb.writeln('• Email: ${a.email}');
      }
      if (a.socialLinks != null) {
        a.socialLinks!.forEach((key, value) {
          if (value != null && value.toString().trim().isNotEmpty) {
            final name = key[0].toUpperCase() + key.substring(1);
            sb.writeln('• $name: $value');
          }
        });
      }
    }

    sb.writeln('\nShared via Campus Assistant App');

    SharePlus.instance.share(
      ShareParams(
        text: sb.toString().trim(),
        subject: 'Alumni Profile: ${a.fullName}',
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(BuildContext context, String status) {
    switch (status.toLowerCase().trim()) {
      case 'job':
      case 'working':
      case 'employed':
        return {
          'text': 'Working',
          'icon': LucideIcons.briefcase,
          'color': context.colors.success,
          'emoji': '💼',
        };
      case 'study':
      case 'studying':
      case 'student':
        return {
          'text': 'Studying',
          'icon': LucideIcons.graduationCap,
          'color': context.colors.info,
          'emoji': '🎓',
        };
      case 'entrepreneur':
      case 'business':
      case 'founder':
        return {
          'text': 'Entrepreneur',
          'icon': LucideIcons.rocket,
          'color': AccentToken.violet,
          'emoji': '🚀',
        };
      default:
        return {
          'text': 'Alumnus',
          'icon': LucideIcons.user,
          'color': context.colors.textSubtle,
          'emoji': '🎓',
        };
    }
  }

  void _showAlumniDetailsDialog(
    BuildContext context,
    Alumni a,
    String initials,
    Color primaryColor,
    bool isDark,
  ) {
    final statusConfig = _getStatusConfig(context, a.currentStatus);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusToken.xxxl),
          ),
          elevation: 12,
          backgroundColor: context.colors.surface,
          clipBehavior: .antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: context.colors.shadow,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 16,
                              color: context.colors.onPrimary,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: Spacing.xl,
                          right: Spacing.xl,
                        ),
                        child: Row(
                          crossAxisAlignment: .end,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colors.surface,
                                border: Border.all(
                                  color: context.colors.onPrimary,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colors.shadow,
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: a.profileImage.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: ApiEndpoints.resolveImageUrl(
                                          a.profileImage,
                                        ),
                                        fit: .cover,
                                        errorWidget: (context, url, error) {
                                          final h =
                                              (a.fullName.hashCode.abs() % 360)
                                                  .toDouble();
                                          final gStart = HSLColor.fromAHSL(
                                            1.0,
                                            h,
                                            0.65,
                                            0.45,
                                          ).toColor();
                                          final gEnd = HSLColor.fromAHSL(
                                            1.0,
                                            h + 30,
                                            0.75,
                                            0.55,
                                          ).toColor();
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [gStart, gEnd],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                initials,
                                                style: TextStyle(
                                                  color:
                                                      context.colors.onPrimary,
                                                  fontWeight: .bold,
                                                  fontSize:
                                                      FontSizeToken.display,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              HSLColor.fromAHSL(
                                                1.0,
                                                (a.fullName.hashCode.abs() %
                                                        360)
                                                    .toDouble(),
                                                0.65,
                                                0.45,
                                              ).toColor(),
                                              HSLColor.fromAHSL(
                                                1.0,
                                                ((a.fullName.hashCode.abs() +
                                                            30) %
                                                        360)
                                                    .toDouble(),
                                                0.75,
                                                0.55,
                                              ).toColor(),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            initials,
                                            style: TextStyle(
                                              color: context.colors.onPrimary,
                                              fontWeight: .bold,
                                              fontSize: FontSizeToken.display,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: Spacing.lg),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Spacing.xs,
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisSize: .min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.sm,
                                        vertical: Spacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          RadiusToken.sm,
                                        ),
                                      ),
                                      child: Text(
                                        a.batch.startsWith('Batch')
                                            ? a.batch
                                            : 'Batch ${a.batch}',
                                        style: TextStyle(
                                          fontSize: FontSizeToken.xs,
                                          fontWeight: .bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.sm),
                                    Text(
                                      a.fullName,
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        fontSize: FontSizeToken.xl,
                                        color: context.colors.text,
                                      ),
                                      maxLines: 2,
                                      overflow: .ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.xl,
                      Spacing.xl,
                      Spacing.xl,
                      Spacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (a.bio.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Spacing.md),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceAlt,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                              border: Border.all(
                                color: context.colors.surfaceAlt,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: .start,
                              children: [
                                Icon(
                                  Icons.format_quote_rounded,
                                  size: 20,
                                  color: primaryColor.withValues(alpha: 0.4),
                                ),
                                const SizedBox(width: Spacing.sm),
                                Expanded(
                                  child: Text(
                                    a.bio,
                                    style: TextStyle(
                                      fontSize: FontSizeToken.md,
                                      fontStyle: .italic,
                                      color: context.colors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                        ],

                        _buildDetailSection(
                          title: 'Academic Profile',
                          icon: Icons.school_rounded,
                          color: primaryColor,
                          isDark: isDark,
                          content: Column(
                            crossAxisAlignment: .start,
                            children: [
                              _buildDetailRow(
                                context,
                                'Batch',
                                a.batch,
                                isDark,
                              ),
                              if (a.passingYear.isNotEmpty)
                                _buildDetailRow(
                                  context,
                                  'Passing Year',
                                  a.passingYear,
                                  isDark,
                                ),
                              _buildDetailRow(
                                context,
                                'Student ID',
                                a.studentId,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),

                        _buildDetailSection(
                          title: 'Professional Details',
                          icon: statusConfig['icon'] as IconData,
                          color: statusConfig['color'] as Color,
                          isDark: isDark,
                          content: Column(
                            crossAxisAlignment: .start,
                            children: [
                              if (a.designation.isNotEmpty)
                                _buildDetailRow(
                                  context,
                                  'Role',
                                  a.designation,
                                  isDark,
                                ),
                              if (a.organization.isNotEmpty)
                                _buildDetailRow(
                                  context,
                                  'Organization',
                                  a.organization,
                                  isDark,
                                ),
                              if (a.location.isNotEmpty)
                                _buildDetailRow(
                                  context,
                                  'Location',
                                  a.location,
                                  isDark,
                                ),
                              _buildDetailRow(
                                context,
                                'Current Status',
                                statusConfig['text'] as String,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),

                        Divider(height: 1, color: context.colors.border),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          'Connect With Alumni',
                          style: TextStyle(
                            fontSize: FontSizeToken.sm,
                            fontWeight: .bold,
                            letterSpacing: 0.5,
                            color: context.colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          mainAxisAlignment: .start,
                          children: [
                            if (a.phone.isNotEmpty)
                              _buildContactButton(
                                icon: Icons.phone_rounded,
                                backgroundColor: context.colors.success,
                                iconColor: context.colors.success,
                                tooltip: 'Call Phone',
                                onTap: () => OpenApp.withNumber(a.phone),
                              ),
                            if (a.email.isNotEmpty)
                              _buildContactButton(
                                icon: Icons.email_rounded,
                                backgroundColor: context.colors.info,
                                iconColor: context.colors.info,
                                tooltip: 'Send Email',
                                onTap: () => OpenApp.withEmail(a.email),
                              ),
                            if (a.socialLinks != null &&
                                a.socialLinks!['facebook'] != null &&
                                a.socialLinks!['facebook']
                                    .toString()
                                    .isNotEmpty)
                              _buildContactButton(
                                icon: Icons.facebook_rounded,
                                backgroundColor: context.colors.info,
                                iconColor: context.colors.info,
                                tooltip: 'Facebook Profile',
                                onTap: () => OpenApp.withUrl(
                                  a.socialLinks!['facebook'].toString(),
                                ),
                              ),
                            if (a.socialLinks != null &&
                                a.socialLinks!['linkedin'] != null &&
                                a.socialLinks!['linkedin']
                                    .toString()
                                    .isNotEmpty)
                              _buildContactButton(
                                icon: Icons.alternate_email_rounded,
                                backgroundColor: context.colors.primary,
                                iconColor: context.colors.primary,
                                tooltip: 'LinkedIn Profile',
                                onTap: () => OpenApp.withUrl(
                                  a.socialLinks!['linkedin'].toString(),
                                ),
                              ),
                            _buildContactButton(
                              icon: Icons.share_rounded,
                              backgroundColor: context.colors.primary,
                              iconColor: context.colors.primary,
                              tooltip: 'Share Profile',
                              onTap: () => _shareAlumni(a),
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
  }

  @override
  Widget build(BuildContext context) {
    final a = alumni;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusConfig = _getStatusConfig(context, a.currentStatus);

    final initials = a.fullName.isNotEmpty
        ? a.fullName
              .trim()
              .split(' ')
              .map((l) => l[0])
              .take(2)
              .join()
              .toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1.0),
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
        child: InkWell(
          onTap: () => _showAlumniDetailsDialog(
            context,
            a,
            initials,
            primaryColor,
            isDark,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(
                          alpha: isDark ? 0.2 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Text(
                        a.batch.startsWith('Batch')
                            ? a.batch
                            : 'Batch ${a.batch}',
                        style: TextStyle(
                          fontSize: FontSizeToken.xxs,
                          fontWeight: .bold,
                          color: isDark
                              ? Theme.of(context).colorScheme.onSurface
                              : primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: (statusConfig['color'] as Color).withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        border: Border.all(
                          color: (statusConfig['color'] as Color).withValues(
                            alpha: 0.15,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusConfig['color'] as Color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (statusConfig['color'] as Color)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            statusConfig['text'] as String,
                            style: TextStyle(
                              fontSize: FontSizeToken.xxs,
                              fontWeight: .bold,
                              color: statusConfig['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Hero(
                      tag: 'alumni-avatar-${a.id}',
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.surfaceAlt,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.xxxl),
                          child: a.profileImage.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: ApiEndpoints.resolveImageUrl(
                                    a.profileImage,
                                  ),
                                  fit: .cover,
                                  placeholder: (context, url) => Container(
                                    color: context.colors.surfaceAlt,
                                    child: Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
                                    final h = (a.fullName.hashCode.abs() % 360)
                                        .toDouble();
                                    final gStart = HSLColor.fromAHSL(
                                      1.0,
                                      h,
                                      0.65,
                                      0.45,
                                    ).toColor();
                                    final gEnd = HSLColor.fromAHSL(
                                      1.0,
                                      h + 30,
                                      0.75,
                                      0.55,
                                    ).toColor();
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [gStart, gEnd],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          initials,
                                          style: TextStyle(
                                            color: context.colors.onPrimary,
                                            fontWeight: .bold,
                                            fontSize: FontSizeToken.xl,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        HSLColor.fromAHSL(
                                          1.0,
                                          (a.fullName.hashCode.abs() % 360)
                                              .toDouble(),
                                          0.65,
                                          0.45,
                                        ).toColor(),
                                        HSLColor.fromAHSL(
                                          1.0,
                                          ((a.fullName.hashCode.abs() + 30) %
                                                  360)
                                              .toDouble(),
                                          0.75,
                                          0.55,
                                        ).toColor(),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        color: context.colors.onPrimary,
                                        fontWeight: .bold,
                                        fontSize: FontSizeToken.xl,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.lg),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            a.fullName,
                            style: TextStyle(
                              fontWeight: .bold,
                              fontSize: FontSizeToken.lg,
                              color: context.colors.text,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                          const SizedBox(height: Spacing.xs),
                          if (a.designation.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.briefcase,
                                  size: 12,
                                  color: context.colors.textMuted,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Expanded(
                                  child: Text(
                                    a.designation,
                                    style: TextStyle(
                                      fontSize: FontSizeToken.md,
                                      fontWeight: .w600,
                                      color: context.colors.text,
                                    ),
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.xs),
                          ],
                          Row(
                            children: [
                              Icon(
                                LucideIcons.building,
                                size: 12,
                                color: context.colors.textSubtle,
                              ),
                              const SizedBox(width: Spacing.xs),
                              if (a.organizationRef?.logoUrl != null &&
                                  a.organizationRef!.logoUrl.isNotEmpty) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiEndpoints.resolveImageUrl(
                                      a.organizationRef!.logoUrl,
                                    ),
                                    width: 14,
                                    height: 14,
                                    fit: .cover,
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                                const SizedBox(width: Spacing.xs),
                              ],
                              Expanded(
                                child: Text(
                                  a.organization.isNotEmpty
                                      ? a.organization
                                      : 'Self Employed',
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    color: context.colors.textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (a.location.isNotEmpty) ...[
                            const SizedBox(height: Spacing.xs),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 11,
                                  color: context.colors.textSubtle,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Expanded(
                                  child: Text(
                                    a.location,
                                    style: TextStyle(
                                      fontSize: FontSizeToken.xs,
                                      color: context.colors.textSubtle,
                                    ),
                                    maxLines: 1,
                                    overflow: .ellipsis,
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

              if (a.bio.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.md,
                    Spacing.lg,
                    Spacing.xs,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                    ),
                    child: Text(
                      a.bio,
                      style: TextStyle(
                        fontSize: FontSizeToken.xs,
                        fontStyle: .italic,
                        color: context.colors.textSubtle,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
                ),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Divider(height: 20, color: context.colors.border),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  0,
                  Spacing.lg,
                  Spacing.md,
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (a.phone.isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.phone_rounded,
                            iconColor: context.colors.success,
                            backgroundColor: context.colors.success.withValues(
                              alpha: 0.7,
                            ),
                            onTap: () => OpenApp.withNumber(a.phone),
                          ),
                        if (a.email.isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.email_rounded,
                            iconColor: context.colors.info,
                            backgroundColor: context.colors.info.withValues(
                              alpha: 0.7,
                            ),
                            onTap: () => OpenApp.withEmail(a.email),
                          ),
                        if (a.socialLinks != null &&
                            a.socialLinks!['facebook'] != null &&
                            a.socialLinks!['facebook'].toString().isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.facebook_rounded,
                            iconColor: context.colors.info,
                            backgroundColor: context.colors.info.withValues(
                              alpha: 0.7,
                            ),
                            onTap: () => OpenApp.withUrl(
                              a.socialLinks!['facebook'].toString(),
                            ),
                          ),
                        if (a.socialLinks != null &&
                            a.socialLinks!['linkedin'] != null &&
                            a.socialLinks!['linkedin'].toString().isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.alternate_email_rounded,
                            iconColor: context.colors.primary,
                            backgroundColor: context.colors.primary.withValues(
                              alpha: 0.7,
                            ),
                            onTap: () => OpenApp.withUrl(
                              a.socialLinks!['linkedin'].toString(),
                            ),
                          ),
                        _buildCardActionButton(
                          icon: Icons.share_rounded,
                          iconColor: context.colors.primary,
                          backgroundColor: context.colors.primary.withValues(
                            alpha: 0.7,
                          ),
                          onTap: () => _shareAlumni(a),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: FontSizeToken.xs,
                            fontWeight: .bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: Spacing.xxs),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
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

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: Spacing.sm),
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Padding(
          padding: const EdgeInsets.only(left: Spacing.xxl),
          child: content,
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: FontSizeToken.sm,
                color: context.colors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: FontSizeToken.sm,
                fontWeight: .w500,
                color: context.colors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.md),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            onTap: onTap,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardActionButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 16),
        ),
      ),
    );
  }
}
