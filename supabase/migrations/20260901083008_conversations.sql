-- One customer thread on one channel. last_message_at is a denormalized
-- column kept for efficient inbox sorting (avoids a subquery over
-- messages just to order the conversation list).

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  channel_id uuid not null references public.channels (id) on delete cascade,
  contact_id uuid not null references public.contacts (id) on delete cascade,
  external_conversation_id text,
  status text not null default 'open' check (status in ('open', 'pending', 'resolved')),
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.conversations is
  'One customer thread on one channel. Assignment/tags columns are added in a later stage.';

create index conversations_organization_id_idx on public.conversations (organization_id);
create index conversations_contact_id_idx on public.conversations (contact_id);
create index conversations_inbox_order_idx
  on public.conversations (organization_id, last_message_at desc);

-- Prevents a webhook retry from creating a duplicate conversation for the
-- same provider thread.
create unique index conversations_channel_external_unique
  on public.conversations (channel_id, external_conversation_id)
  where external_conversation_id is not null;

create trigger set_conversations_updated_at
  before update on public.conversations
  for each row
  execute function public.set_updated_at();

alter table public.conversations enable row level security;

-- No delete policy: conversations are never hard-deleted from the
-- client, only moved to 'resolved' (an audit trail, like messages).
grant select, insert, update on public.conversations to authenticated;

create policy conversations_select on public.conversations
  for select
  using (public.is_org_member(organization_id));

create policy conversations_insert on public.conversations
  for insert
  with check (public.is_org_member(organization_id));

create policy conversations_update on public.conversations
  for update
  using (public.is_org_member(organization_id))
  with check (public.is_org_member(organization_id));
