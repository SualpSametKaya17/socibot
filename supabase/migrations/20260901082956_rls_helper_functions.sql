-- RLS helper functions. Each is SECURITY DEFINER so it can read
-- organization_members from inside a policy on organization_members
-- itself without a recursive-RLS deadlock (the function body runs with
-- the function owner's privileges, bypassing RLS).

create or replace function public.is_org_member(org_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.organization_members m
    where m.organization_id = org_id
      and m.user_id = auth.uid()
  );
$$;

create or replace function public.is_org_admin(org_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.organization_members m
    where m.organization_id = org_id
      and m.user_id = auth.uid()
      and m.role in ('owner', 'admin')
  );
$$;

-- Lets a member see the profiles of their teammates (any org they share),
-- not just their own profile row.
create or replace function public.shares_organization_with(target_user_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.organization_members mine
    join public.organization_members theirs
      on theirs.organization_id = mine.organization_id
    where mine.user_id = auth.uid()
      and theirs.user_id = target_user_id
  );
$$;

-- Bootstraps the creator as 'owner' the moment an organization is
-- created, so the organizations INSERT policy can allow any authenticated
-- user to create one without a chicken-and-egg membership check.
create or replace function public.handle_new_organization()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.organization_members (organization_id, user_id, role)
  values (new.id, auth.uid(), 'owner');
  return new;
end;
$$;

create trigger on_organization_created
  after insert on public.organizations
  for each row
  execute function public.handle_new_organization();
