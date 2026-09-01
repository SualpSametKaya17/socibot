import '../../../core/constants/status_tone.dart';

enum ConversationStatus {
  open,
  pending,
  resolved;

  String get label => switch (this) {
    ConversationStatus.open => 'Open',
    ConversationStatus.pending => 'Pending',
    ConversationStatus.resolved => 'Resolved',
  };

  StatusTone get tone => switch (this) {
    ConversationStatus.open => StatusTone.info,
    ConversationStatus.pending => StatusTone.warning,
    ConversationStatus.resolved => StatusTone.success,
  };
}
