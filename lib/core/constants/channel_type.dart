/// The messaging providers this app supports. Shared across channels,
/// conversations, contacts, and messages — not owned by any single
/// feature — so it lives in core rather than one feature's domain layer.
enum ChannelType {
  instagram,
  facebook,
  whatsapp;

  String get label => switch (this) {
    ChannelType.instagram => 'Instagram',
    ChannelType.facebook => 'Messenger',
    ChannelType.whatsapp => 'WhatsApp',
  };
}
