import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:material_ui/material_ui.dart';

/// Builds a screen from a `deferred as` library once it has loaded.
///
/// On web this keeps rarely used routes out of the initial download: the
/// library's code is fetched the first time the route opens. On native,
/// [loadLibrary] completes immediately, so this is effectively a pass-through.
///
/// ```dart
/// import '/features/developer/.../developer_page.dart' deferred as developer;
///
/// DeferredPage(developer.loadLibrary, () => developer.DeveloperPage())
/// ```
class DeferredPage extends StatefulWidget {
  final Future<void> Function() loadLibrary;
  final Widget Function() builder;

  const DeferredPage(this.loadLibrary, this.builder, {super.key});

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  late final Future<void> _loaded = widget.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Couldn\'t load this page')),
            );
          }
          return widget.builder();
        }
        return const Scaffold(
          body: Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }
}
