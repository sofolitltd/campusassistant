import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/app_update_provider.dart';

/// Non-dismissible gate shown when the installed build is below the admin's
/// minimum supported version code. The router redirect is what keeps the
/// user here — this screen itself just blocks the back button.
class ForceUpdateScreen extends ConsumerStatefulWidget {
  const ForceUpdateScreen({super.key});

  @override
  ConsumerState<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends ConsumerState<ForceUpdateScreen> {
  bool _updating = false;

  Future<void> _startUpdate(String playStoreUrl) async {
    setState(() => _updating = true);
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (_) {
      // Not installed via Play (debug/sideloaded build), Play services
      // unavailable, etc. — fall through to the store link below.
    }
    if (playStoreUrl.isNotEmpty) {
      await launchUrl(
        Uri.parse(playStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    }
    if (mounted) setState(() => _updating = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appUpdateConfigProvider).value;
    final message = (config?.updateMessage.isNotEmpty ?? false)
        ? config!.updateMessage
        : 'A required update is available. Please update the app to continue using Campus Assistant.';

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.system_update,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Update required',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _updating
                      ? null
                      : () => _startUpdate(config?.playStoreUrl ?? ''),
                  child: _updating
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
