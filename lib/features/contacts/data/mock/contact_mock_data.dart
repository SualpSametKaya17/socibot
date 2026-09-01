import '../../../../core/constants/channel_type.dart';
import '../../domain/contact.dart';

/// Isolated from [MockContactRepository] on purpose, same reasoning as
/// the conversations feature's mock data. Names/channels intentionally
/// echo the conversation mock data (same customers), so "View
/// conversation" in the contact detail pane leads somewhere real.
List<Contact> buildMockContacts() {
  final now = DateTime.now();
  return [
    Contact(
      id: '1',
      displayName: 'Elena Martinez',
      email: 'elena.martinez@example.com',
      phone: '+1 415 555 0142',
      primaryChannel: ChannelType.whatsapp,
      conversationId: '1',
      lastContactedAt: now.subtract(const Duration(minutes: 4)),
    ),
    Contact(
      id: '2',
      displayName: 'Marcus Chen',
      email: 'marcus.chen@example.com',
      primaryChannel: ChannelType.instagram,
      conversationId: '2',
      lastContactedAt: now.subtract(const Duration(minutes: 32)),
    ),
    Contact(
      id: '3',
      displayName: 'Priya Nair',
      email: 'priya.nair@example.com',
      phone: '+44 20 7946 0958',
      primaryChannel: ChannelType.facebook,
      conversationId: '3',
      lastContactedAt: now.subtract(const Duration(hours: 2)),
    ),
    Contact(
      id: '4',
      displayName: 'Diego Fernandez',
      phone: '+52 55 1234 5678',
      primaryChannel: ChannelType.whatsapp,
      conversationId: '4',
      lastContactedAt: now.subtract(const Duration(hours: 5)),
    ),
    Contact(
      id: '5',
      displayName: 'Aiko Tanaka',
      email: 'aiko.tanaka@example.com',
      primaryChannel: ChannelType.instagram,
      conversationId: '5',
      lastContactedAt: now.subtract(const Duration(hours: 9)),
    ),
    Contact(
      id: '6',
      displayName: 'Sofia Rossi',
      email: 'sofia.rossi@example.com',
      primaryChannel: ChannelType.facebook,
      conversationId: '6',
      lastContactedAt: now.subtract(const Duration(hours: 14)),
    ),
    Contact(
      id: '7',
      displayName: "James O'Brien",
      phone: '+353 1 234 5678',
      primaryChannel: ChannelType.whatsapp,
      conversationId: '7',
      lastContactedAt: now.subtract(const Duration(days: 1, hours: 3)),
    ),
    Contact(
      id: '8',
      displayName: 'Fatima Al-Sayed',
      email: 'fatima.alsayed@example.com',
      primaryChannel: ChannelType.instagram,
      conversationId: '8',
      lastContactedAt: now.subtract(const Duration(days: 2)),
    ),
    Contact(
      id: '9',
      displayName: 'Lucas Weber',
      phone: '+49 30 1234567',
      primaryChannel: ChannelType.whatsapp,
      conversationId: '9',
      lastContactedAt: now.subtract(const Duration(days: 2, hours: 6)),
    ),
    Contact(
      id: '10',
      displayName: 'Hannah Kim',
      email: 'hannah.kim@example.com',
      primaryChannel: ChannelType.facebook,
      conversationId: '10',
      lastContactedAt: now.subtract(const Duration(days: 3)),
    ),
  ];
}
