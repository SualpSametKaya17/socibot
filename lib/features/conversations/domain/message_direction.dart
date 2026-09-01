/// Matches the `direction` check constraint on the `messages` table
/// (see supabase/migrations) — kept in sync so the eventual real
/// repository maps 1:1 onto this.
enum MessageDirection { incoming, outgoing }
