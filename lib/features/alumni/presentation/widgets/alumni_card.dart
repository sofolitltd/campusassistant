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

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase().trim()) {
      case 'job':
      case 'working':
      case 'employed':
        return {
          'text': 'Working',
          'icon': LucideIcons.briefcase,
          'color': Colors.green,
          'emoji': '💼',
        };
      case 'study':
      case 'studying':
      case 'student':
        return {
          'text': 'Studying',
          'icon': LucideIcons.graduationCap,
          'color': Colors.blue,
          'emoji': '🎓',
        };
      case 'entrepreneur':
      case 'business':
      case 'founder':
        return {
          'text': 'Entrepreneur',
          'icon': LucideIcons.rocket,
          'color': Colors.purple,
          'emoji': '🚀',
        };
      default:
        return {
          'text': 'Alumnus',
          'icon': LucideIcons.user,
          'color': Colors.grey,
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
    final statusConfig = _getStatusConfig(a.currentStatus);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 12,
          backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          backgroundColor: Colors.black.withValues(alpha: 0.2),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Theme.of(context).cardColor
                                    : Colors.white,
                                border: Border.all(
                                  color: isDark
                                      ? Theme.of(context).cardColor
                                      : Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
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
                                        fit: BoxFit.cover,
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
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
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
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      a.fullName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (a.bio.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade100,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.format_quote_rounded,
                                  size: 20,
                                  color: primaryColor.withValues(alpha: 0.4),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    a.bio,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: isDark
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade700,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Batch', a.batch, isDark),
                              if (a.passingYear.isNotEmpty)
                                _buildDetailRow(
                                  'Passing Year',
                                  a.passingYear,
                                  isDark,
                                ),
                              _buildDetailRow(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (a.designation.isNotEmpty)
                                _buildDetailRow('Role', a.designation, isDark),
                              if (a.organization.isNotEmpty)
                                _buildDetailRow(
                                  'Organization',
                                  a.organization,
                                  isDark,
                                ),
                              if (a.location.isNotEmpty)
                                _buildDetailRow('Location', a.location, isDark),
                              _buildDetailRow(
                                'Current Status',
                                statusConfig['text'] as String,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Divider(
                          height: 1,
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          'Connect With Alumni',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (a.phone.isNotEmpty)
                              _buildContactButton(
                                icon: Icons.phone_rounded,
                                backgroundColor: isDark
                                    ? Colors.green.withValues(alpha: 0.15)
                                    : Colors.green.shade50,
                                iconColor: isDark
                                    ? Colors.green.shade300
                                    : Colors.green.shade700,
                                tooltip: 'Call Phone',
                                onTap: () => OpenApp.withNumber(a.phone),
                              ),
                            if (a.email.isNotEmpty)
                              _buildContactButton(
                                icon: Icons.email_rounded,
                                backgroundColor: isDark
                                    ? Colors.blue.withValues(alpha: 0.15)
                                    : Colors.blue.shade50,
                                iconColor: isDark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700,
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
                                backgroundColor: isDark
                                    ? Colors.indigo.withValues(alpha: 0.15)
                                    : Colors.indigo.shade50,
                                iconColor: isDark
                                    ? Colors.indigo.shade300
                                    : Colors.indigo.shade700,
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
                                backgroundColor: isDark
                                    ? Colors.cyan.withValues(alpha: 0.15)
                                    : Colors.cyan.shade50,
                                iconColor: isDark
                                    ? Colors.cyan.shade300
                                    : Colors.cyan.shade700,
                                tooltip: 'LinkedIn Profile',
                                onTap: () => OpenApp.withUrl(
                                  a.socialLinks!['linkedin'].toString(),
                                ),
                              ),
                            _buildContactButton(
                              icon: Icons.share_rounded,
                              backgroundColor: isDark
                                  ? Colors.teal.withValues(alpha: 0.15)
                                  : Colors.teal.shade50,
                              iconColor: isDark
                                  ? Colors.teal.shade300
                                  : Colors.teal.shade700,
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
    final statusConfig = _getStatusConfig(a.currentStatus);

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
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(
                          alpha: isDark ? 0.2 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        a.batch.startsWith('Batch')
                            ? a.batch
                            : 'Batch ${a.batch}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Theme.of(context).colorScheme.onSurface
                              : primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (statusConfig['color'] as Color).withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: (statusConfig['color'] as Color).withValues(
                            alpha: 0.15,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(width: 5),
                          Text(
                            statusConfig['text'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'alumni-avatar-${a.id}',
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade100,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: a.profileImage.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: ApiEndpoints.resolveImageUrl(
                                    a.profileImage,
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade100,
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
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.fullName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          if (a.designation.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.briefcase,
                                  size: 12,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    a.designation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey.shade800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                          ],
                          Row(
                            children: [
                              Icon(
                                LucideIcons.building,
                                size: 12,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 5),
                              if (a.organizationRef?.logoUrl != null &&
                                  a.organizationRef!.logoUrl.isNotEmpty) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiEndpoints.resolveImageUrl(
                                      a.organizationRef!.logoUrl,
                                    ),
                                    width: 14,
                                    height: 14,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  a.organization.isNotEmpty
                                      ? a.organization
                                      : 'Self Employed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (a.location.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 11,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    a.location,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.grey.shade500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.02)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                    ),
                    child: Text(
                      a.bio,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 20,
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (a.phone.isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.phone_rounded,
                            iconColor: Colors.green.shade600,
                            backgroundColor: isDark
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.green.shade50.withValues(alpha: 0.7),
                            onTap: () => OpenApp.withNumber(a.phone),
                          ),
                        if (a.email.isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.email_rounded,
                            iconColor: Colors.blue.shade600,
                            backgroundColor: isDark
                                ? Colors.blue.withValues(alpha: 0.15)
                                : Colors.blue.shade50.withValues(alpha: 0.7),
                            onTap: () => OpenApp.withEmail(a.email),
                          ),
                        if (a.socialLinks != null &&
                            a.socialLinks!['facebook'] != null &&
                            a.socialLinks!['facebook'].toString().isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.facebook_rounded,
                            iconColor: Colors.indigo.shade600,
                            backgroundColor: isDark
                                ? Colors.indigo.withValues(alpha: 0.15)
                                : Colors.indigo.shade50.withValues(alpha: 0.7),
                            onTap: () => OpenApp.withUrl(
                              a.socialLinks!['facebook'].toString(),
                            ),
                          ),
                        if (a.socialLinks != null &&
                            a.socialLinks!['linkedin'] != null &&
                            a.socialLinks!['linkedin'].toString().isNotEmpty)
                          _buildCardActionButton(
                            icon: Icons.alternate_email_rounded,
                            iconColor: Colors.cyan.shade600,
                            backgroundColor: isDark
                                ? Colors.cyan.withValues(alpha: 0.15)
                                : Colors.cyan.shade50.withValues(alpha: 0.7),
                            onTap: () => OpenApp.withUrl(
                              a.socialLinks!['linkedin'].toString(),
                            ),
                          ),
                        _buildCardActionButton(
                          icon: Icons.share_rounded,
                          iconColor: Colors.teal.shade600,
                          backgroundColor: isDark
                              ? Colors.teal.withValues(alpha: 0.15)
                              : Colors.teal.shade50.withValues(alpha: 0.7),
                          onTap: () => _shareAlumni(a),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(padding: const EdgeInsets.only(left: 24), child: content),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
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
      padding: const EdgeInsets.only(right: 12),
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
      padding: const EdgeInsets.only(right: 8),
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
