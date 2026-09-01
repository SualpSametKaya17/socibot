-- A B2B customer account (tenant). All business data is scoped to one
-- organization via an organization_id column.

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.organizations is
  'A B2B customer account (tenant). Mirrors lib/features/organization/domain/organization.dart.';

create trigger set_organizations_updated_at
  before update on public.organizations
  for each row
  execute function public.set_updated_at();
