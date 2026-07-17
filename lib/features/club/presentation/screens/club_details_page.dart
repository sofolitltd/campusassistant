import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/features/club/domain/entities/club.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class ClubDetailsPage extends StatelessWidget {
  final Club club;

  const ClubDetailsPage({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Club Details'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (club.bannerUrl != null && club.bannerUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              child: CachedNetworkImage(
                imageUrl: club.bannerUrl!,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                child: club.logoUrl != null && club.logoUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: CachedNetworkImage(
                          imageUrl: club.logoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.groups, color: Colors.grey),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club.foundedYear != null
                          ? 'Founded ${club.foundedYear}'
                          : '',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            club.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          if (club.contactPhone != null ||
              club.contactEmail != null ||
              (club.socialLinks != null && club.socialLinks!.isNotEmpty)) ...[
            const SizedBox(height: 24),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            if (club.contactPhone != null)
              _buildContactRow(
                context,
                Icons.phone_rounded,
                club.contactPhone!,
                () => OpenApp.withNumber(club.contactPhone!),
              ),
            if (club.contactEmail != null)
              _buildContactRow(
                context,
                Icons.email_rounded,
                club.contactEmail!,
                () => OpenApp.withEmail(club.contactEmail!),
              ),
            if (club.socialLinks != null)
              ...club.socialLinks!.entries.map(
                (e) => _buildSocialRow(context, e.key, e.value.toString()),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: isDark ? Colors.white70 : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialRow(BuildContext context, String platform, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$platform: $value',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
