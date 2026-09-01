-- RLS for profiles, organizations, and organization_members. Split out
-- from their CREATE TABLE migrations because the policies depend on the
-- helper functions defined afterward.

alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;

-- profiles: writes only ever happen via the handle_new_user trigger
-- (SECURITY DEFINER), so authenticated only needs select/update grants.
grant select, update on public.profiles to authenticated;
grant select, insert, update on public.organizations to authenticated;
grant select, insert, update, delete on public.organization_members to authenticated;

-- profiles: see your own profile, plus teammates' in any shared organization.
create policy profiles_select on public.profiles
  for select
  using (id = auth.uid() or public.shares_organization_with(id));

create policy profiles_update_own on public.profiles
  for update
  using (id = auth.uid())
  with check (id = auth.uid());

-- organizations: any signed-in user may create one (the
-- handle_new_organization trigger makes them owner); membership is
-- required to read or manage it afterward.
create policy organizations_select on public.organizations
  for select
  using (public.is_org_member(id));

create policy organizations_insert on public.organizations
  for insert
  with check (auth.uid() is not null);

create policy organizations_update on public.organizations
  for update
  using (public.is_org_admin(id))
  with check (public.is_org_admin(id));

-- organization_members: members see their fellow members; only
-- owners/admins manage membership, and anyone may remove themselves.
create policy organization_members_select on public.organization_members
  for select
  using (public.is_org_member(organization_id));

create policy organization_members_insert on public.organization_members
  for insert
  with check (public.is_org_admin(organization_id));

create policy organization_members_update on public.organization_members
  for update
  using (public.is_org_admin(organization_id))
  with check (public.is_org_admin(organization_id));

create policy organization_members_delete on public.organization_members
  for delete
  using (public.is_org_admin(organization_id) or user_id = auth.uid());
