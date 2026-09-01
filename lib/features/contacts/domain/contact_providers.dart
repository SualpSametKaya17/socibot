import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/contact_repository.dart';
import 'contact.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return MockContactRepository();
});

final contactsProvider = FutureProvider<List<Contact>>((ref) {
  return ref.watch(contactRepositoryProvider).fetchContacts();
});

final contactSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedContactIdProvider = StateProvider<String?>((ref) => null);

final filteredContactsProvider = Provider<AsyncValue<List<Contact>>>((ref) {
  final contactsAsync = ref.watch(contactsProvider);
  final query = ref.watch(contactSearchQueryProvider).trim().toLowerCase();

  return contactsAsync.whenData((contacts) {
    final filtered = query.isEmpty
        ? contacts
        : contacts.where((contact) {
            final haystack =
                '${contact.displayName} ${contact.email ?? ''} ${contact.phone ?? ''}'
                    .toLowerCase();
            return haystack.contains(query);
          }).toList();

    filtered.sort((a, b) => a.displayName.compareTo(b.displayName));
    return filtered;
  });
});
