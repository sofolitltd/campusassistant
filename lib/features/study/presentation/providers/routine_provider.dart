// TODO: Remove Firebase dependency - refactor to use backend API
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Update to use the new routine provider from features/routine
// The new provider already exists at: lib/features/routine/presentation/providers/routine_provider.dart
final routineStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      // Temporary placeholder - returns empty stream
      // Use routinesProvider from features/routine instead
      return const Stream.empty();

      // final userAsync = ref.watch(userProvider);

      // return userAsync.when(
      //   data: (user) {
      //     return FirebaseFirestore.instance
      //         .collection('routines')
      //         .where('university', isEqualTo: user.university)
      //         .where('department', isEqualTo: user.department)
      //         .orderBy('time', descending: false)
      //         .snapshots();
      //   },
      //   loading: () => const Stream.empty(),
      //   error: (e, st) => Stream.error(e),
      // );
    });
