-- A customer identity within an organization, independent of any one
-- channel (one contact can have conversations on more than one channel).

create table public.contacts (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  display_name text,
  avatar_url text,
  phone text,
  email text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.contacts is
  'A customer identity within an organization. Channel-specific ids live on conversations, not here.';

create index contacts_organization_id_idx on public.contacts (organization_id);

create trigger set_contacts_updated_at
  before update on public.contacts
  for each row
  execute function public.set_updated_at();

alter table public.contacts enable row level security;
grant select, insert, update, delete on public.contacts to authenticated;

create policy contacts_select on public.contacts
  for select
  using (public.is_org_member(organization_id));

create policy contacts_insert on public.contacts
  for insert
  with check (public.is_org_member(organization_id));

create policy contacts_update on public.contacts
  for update
  using (public.is_org_member(organization_id))
  with check (public.is_org_member(organization_id));

create policy contacts_delete on public.contacts
  for delete
  using (public.is_org_admin(organization_id));
