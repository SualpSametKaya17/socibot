import '../domain/contact.dart';
import 'mock/contact_mock_data.dart';

abstract class ContactRepository {
  Future<List<Contact>> fetchContacts();
}

/// Backs the Contacts screen until the `contacts` table is queried for
/// real (AŞAMA 7) — same mock-first pattern used elsewhere in the app.
class MockContactRepository implements ContactRepository {
  @override
  Future<List<Contact>> fetchContacts() async {
    return buildMockContacts();
  }
}
