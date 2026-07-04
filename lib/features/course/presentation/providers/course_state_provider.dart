import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier class to manage the selected course tab index
class SelectedCourseTabNotifier extends Notifier<int> {
  @override
  int build() {
    return 0; // Default to first tab
  }

  void setTab(int newIndex) {
    state = newIndex;
  }
}

final selectedCourseTabProvider =
    NotifierProvider<SelectedCourseTabNotifier, int>(
      SelectedCourseTabNotifier.new,
    );
