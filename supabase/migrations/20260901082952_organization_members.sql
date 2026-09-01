-- Join table between profiles and organizations, carrying the member's
-- role. Mirrors lib/features/organization/domain/organization_member.dart
-- and organization_role.dart.

create table public.organization_members (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'admin', 'member')),
  created_at timestamptz not null default now(),
  unique (organization_id, user_id)
);

comment on table public.organization_members is
  'A user''s membership (and role) in one organization.';

create index organization_members_user_id_idx
  on public.organization_members (user_id);
