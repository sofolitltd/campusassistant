import '../../circular/data/models/career_circular.dart';
import '../../jobs/data/models/career_job.dart';

/// A single entry in the unified Circular-tab feed — either an official,
/// admin-authored Circular or a peer-shared Job — so both can be sorted and
/// rendered together in one list instead of two separate sections.
sealed class CareerFeedItem {
  DateTime get createdAt;
}

class CircularFeedItem extends CareerFeedItem {
  final CareerCircular circular;
  CircularFeedItem(this.circular);

  @override
  DateTime get createdAt => circular.createdAt;
}

class SharedJobFeedItem extends CareerFeedItem {
  final CareerJob job;
  SharedJobFeedItem(this.job);

  @override
  DateTime get createdAt => job.createdAt;
}
