-- Run in Supabase SQL editor. Replace OWNER_EMAIL with your actual admin email.
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade, email text not null, role text not null default 'staff' check(role in ('super_admin','clinic_admin','staff')), status text not null default 'active' check(status in ('active','suspended')), created_at timestamptz default now());
alter table public.profiles enable row level security;
create or replace function public.is_super_admin() returns boolean language sql stable security definer set search_path = '' as $$ select exists(select 1 from public.profiles where id=(select auth.uid()) and role='super_admin' and status='active') $$;
revoke all on function public.is_super_admin() from public;
grant execute on function public.is_super_admin() to authenticated;
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select to authenticated using ((id=(select auth.uid()) and status='active') or public.is_super_admin());
drop policy if exists profiles_admin_update on public.profiles;
create policy profiles_admin_update on public.profiles for update to authenticated using (public.is_super_admin() and id<>(select auth.uid())) with check (public.is_super_admin() and id<>(select auth.uid()) and role <> 'super_admin');
-- First create your owner account in Supabase Authentication > Users.
-- Then run the following command, replacing OWNER_EMAIL with the email you used:
-- insert into public.profiles(id,email,role,status)
-- select id,email,'super_admin','active' from auth.users where email='OWNER_EMAIL'
-- on conflict (id) do update set role='super_admin',status='active';
-- Staff invitations must be implemented with a secured server-side Edge Function.
