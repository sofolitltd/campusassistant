import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Monitors network connectivity and exposes a stream of online/offline state.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  /// Stream of connectivity changes. true = online, false = offline.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Start listening for connectivity changes.
  void startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasConnected = _isConnected;
      _isConnected = results.any((r) => r != ConnectivityResult.none);
      if (wasConnected != _isConnected) {
        _controller.add(_isConnected);
      }
    });
  }

  /// Check current connectivity status (one-shot).
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = results.any((r) => r != ConnectivityResult.none);
    return _isConnected;
  }

  /// Stop listening for connectivity changes.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

/// Riverpod provider for ConnectivityService.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.startListening();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Convenience notifier that exposes the current online state.
class IsConnectedNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void update(bool value) => state = value;
}

final isConnectedProvider = NotifierProvider<IsConnectedNotifier, bool>(
  IsConnectedNotifier.new,
);
