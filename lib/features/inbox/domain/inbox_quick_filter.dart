/// The Inbox filter sidebar's primary scope selector — ownership, not
/// conversation status (that's a separate, secondary filter).
enum InboxQuickFilter {
  all,
  mine,
  unassigned;

  String get label => switch (this) {
    InboxQuickFilter.all => 'All',
    InboxQuickFilter.mine => 'Mine',
    InboxQuickFilter.unassigned => 'Unassigned',
  };
}
