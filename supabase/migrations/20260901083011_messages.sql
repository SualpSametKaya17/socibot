-- A single normalized message, incoming or outgoing, on one conversation.
-- Mirrors the Normalized Message Model in the project brief.

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  channel_id uuid not null references public.channels (id) on delete cascade,
  external_message_id text,
  sender_contact_id uuid references public.contacts (id) on delete set null,
  sender_user_id uuid references auth.users (id) on delete set null,
  direction text not null check (direction in ('incoming', 'outgoing')),
  type text not null default 'text'
    check (type in ('text', 'image', 'video', 'audio', 'document', 'location', 'system')),
  body text,
  media_url text,
  status text not null default 'sent'
    check (status in ('pending', 'sent', 'delivered', 'read', 'failed')),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

comment on table public.messages is
  'A normalized message. No updated_at/soft-delete: messages are an audit trail and are never edited or removed.';

create index messages_conversation_id_created_at_idx
  on public.messages (conversation_id, created_at);

-- Webhook idempotency: the same provider event must not create the
-- message twice on retry.
create unique index messages_channel_external_unique
  on public.messages (channel_id, external_message_id)
  where external_message_id is not null;

alter table public.messages enable row level security;

-- Sending a message means calling a provider API with a channel access
-- token, so it happens only through the send-message Edge Function
-- (service_role, bypasses RLS); incoming messages are written the same
-- way by the meta-webhook Edge Function (AŞAMA 10/13). The Flutter
-- client only ever reads.
grant select on public.messages to authenticated;

create policy messages_select on public.messages
  for select
  using (public.is_org_member(organization_id));
