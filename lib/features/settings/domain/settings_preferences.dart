import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Session-scoped Settings preference state — genuine local app state
/// (like [inboxSortNewestFirstProvider] elsewhere), not a simulation.
/// There is no backend endpoint yet to persist these across sessions, so
/// each provider's doc comment says so rather than pretending it survives
/// a reload.

enum ThemePreference {
  system(label: 'System'),
  light(label: 'Light'),
  dark(label: 'Dark');

  const ThemePreference({required this.label});

  final String label;
}

enum EnterKeyBehavior { send, newLine }

enum ConversationResolutionBehavior {
  keepClosed(label: 'Keep conversation closed'),
  allowReopen(label: 'Reopen automatically on new reply');

  const ConversationResolutionBehavior({required this.label});

  final String label;
}

/// Draft values for the Workspace settings form. [name] is `null` until
/// the user edits it, meaning "still following the real organization
/// name" — [WorkspaceSettingsPage] falls back to
/// `currentOrganizationProvider`'s name in that case.
class WorkspaceDraft {
  const WorkspaceDraft({
    this.name,
    this.timezone = 'Europe/Istanbul',
    this.language = 'English',
    this.theme = ThemePreference.light,
    this.dateFormat = 'DD/MM/YYYY',
    this.timeFormat = '24 hour',
  });

  final String? name;
  final String timezone;
  final String language;
  final ThemePreference theme;
  final String dateFormat;
  final String timeFormat;

  WorkspaceDraft copyWith({
    String? name,
    String? timezone,
    String? language,
    ThemePreference? theme,
    String? dateFormat,
    String? timeFormat,
  }) {
    return WorkspaceDraft(
      name: name ?? this.name,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }
}

/// The last *saved* workspace draft — what forms should be compared
/// against to decide whether there are unsaved changes. Starts equal to
/// a fresh [WorkspaceDraft] and is only updated when the user presses
/// Save.
final savedWorkspaceDraftProvider = StateProvider<WorkspaceDraft>((ref) {
  return const WorkspaceDraft();
});

/// The in-progress edit — diverges from [savedWorkspaceDraftProvider]
/// while the user is typing, which is what drives the Save button's
/// enabled state.
final workspaceDraftProvider = StateProvider<WorkspaceDraft>((ref) {
  return ref.watch(savedWorkspaceDraftProvider);
});

class NotificationPreferences {
  const NotificationPreferences({
    this.newConversation = true,
    this.newMessage = true,
    this.assignedToMe = true,
    this.mention = true,
    this.newTeamMember = true,
    this.assignmentChanges = false,
    this.channelDisconnected = true,
    this.integrationError = true,
  });

  final bool newConversation;
  final bool newMessage;
  final bool assignedToMe;
  final bool mention;
  final bool newTeamMember;
  final bool assignmentChanges;
  final bool channelDisconnected;
  final bool integrationError;

  NotificationPreferences copyWith({
    bool? newConversation,
    bool? newMessage,
    bool? assignedToMe,
    bool? mention,
    bool? newTeamMember,
    bool? assignmentChanges,
    bool? channelDisconnected,
    bool? integrationError,
  }) {
    return NotificationPreferences(
      newConversation: newConversation ?? this.newConversation,
      newMessage: newMessage ?? this.newMessage,
      assignedToMe: assignedToMe ?? this.assignedToMe,
      mention: mention ?? this.mention,
      newTeamMember: newTeamMember ?? this.newTeamMember,
      assignmentChanges: assignmentChanges ?? this.assignmentChanges,
      channelDisconnected: channelDisconnected ?? this.channelDisconnected,
      integrationError: integrationError ?? this.integrationError,
    );
  }
}

final notificationPreferencesProvider = StateProvider<NotificationPreferences>(
  (ref) => const NotificationPreferences(),
);

class InboxPreferences {
  const InboxPreferences({
    this.autoAssignNewConversations = false,
    this.defaultAssignee = 'Unassigned',
    this.markReadWhenOpened = true,
    this.showMessagePreview = true,
    this.enterKeyBehavior = EnterKeyBehavior.send,
    this.resolutionBehavior = ConversationResolutionBehavior.keepClosed,
    this.reopenWhenCustomerReplies = true,
  });

  final bool autoAssignNewConversations;
  final String defaultAssignee;
  final bool markReadWhenOpened;
  final bool showMessagePreview;
  final EnterKeyBehavior enterKeyBehavior;
  final ConversationResolutionBehavior resolutionBehavior;
  final bool reopenWhenCustomerReplies;

  InboxPreferences copyWith({
    bool? autoAssignNewConversations,
    String? defaultAssignee,
    bool? markReadWhenOpened,
    bool? showMessagePreview,
    EnterKeyBehavior? enterKeyBehavior,
    ConversationResolutionBehavior? resolutionBehavior,
    bool? reopenWhenCustomerReplies,
  }) {
    return InboxPreferences(
      autoAssignNewConversations:
          autoAssignNewConversations ?? this.autoAssignNewConversations,
      defaultAssignee: defaultAssignee ?? this.defaultAssignee,
      markReadWhenOpened: markReadWhenOpened ?? this.markReadWhenOpened,
      showMessagePreview: showMessagePreview ?? this.showMessagePreview,
      enterKeyBehavior: enterKeyBehavior ?? this.enterKeyBehavior,
      resolutionBehavior: resolutionBehavior ?? this.resolutionBehavior,
      reopenWhenCustomerReplies:
          reopenWhenCustomerReplies ?? this.reopenWhenCustomerReplies,
    );
  }
}

final inboxPreferencesProvider = StateProvider<InboxPreferences>(
  (ref) => const InboxPreferences(),
);
