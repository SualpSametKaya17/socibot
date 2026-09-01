-- A connected messaging channel (Instagram/Facebook/WhatsApp) for an
-- organization. Provider access tokens must NEVER be stored here or in
-- any table readable by the Flutter client — they belong in a future
-- service-role-only integration_credentials table (AŞAMA 10).

create table public.channels (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  provider text not null check (provider in ('instagram', 'facebook', 'whatsapp')),
  display_name text,
  status text not null default 'disconnected'
    check (status in ('connected', 'disconnected', 'error')),
  external_account_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (organization_id, provider, external_account_id)
);

comment on table public.channels is
  'A connected provider channel for an organization. No access tokens here — see integration_credentials (AŞAMA 10).';

create index channels_organization_id_idx on public.channels (organization_id);

create trigger set_channels_updated_at
  before update on public.channels
  for each row
  execute function public.set_updated_at();

alter table public.channels enable row level security;

-- Connecting/disconnecting a channel involves an OAuth handshake and
-- provider tokens, so it happens only through the connect-channel Edge
-- Function (service_role, bypasses RLS). The Flutter client gets
-- read-only access.
grant select on public.channels to authenticated;

create policy channels_select on public.channels
  for select
  using (public.is_org_member(organization_id));
