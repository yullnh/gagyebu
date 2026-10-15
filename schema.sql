-- 우리집 가계부 — Supabase SQL Editor에 통째로 붙여넣고 Run 하세요.
-- 맨 아래 이메일 두 개만 실제 로그인할 이메일로 바꿔주세요.

-- 1) 가계부를 쓸 수 있는 사람 목록 (API로는 아무도 못 읽음)
create table if not exists public.allowed_users (
  email text primary key
);
alter table public.allowed_users enable row level security;

-- 2) 내역·고정항목 (한 행 = 한 건, 내용은 JSON)
create table if not exists public.items (
  id text primary key,
  col text not null check (col in ('entries', 'recurring')),
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.items enable row level security;

-- 3) 설정 (한 행만 존재)
create table if not exists public.settings (
  id int primary key default 1 check (id = 1),
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.settings enable row level security;

-- 4) 로그인한 사람이 목록에 있는지 확인
create or replace function public.is_family()
returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1 from public.allowed_users
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
revoke all on function public.is_family() from public, anon;
grant execute on function public.is_family() to authenticated;

-- 5) 보안 정책: 목록에 있는 사람만 읽기·쓰기
drop policy if exists family_items on public.items;
create policy family_items on public.items
  for all to authenticated using (public.is_family()) with check (public.is_family());

drop policy if exists family_settings on public.settings;
create policy family_settings on public.settings
  for all to authenticated using (public.is_family()) with check (public.is_family());

-- 6) 실시간 반영 (한 사람이 입력하면 다른 사람 화면에 바로 반영)
do $$ begin
  alter publication supabase_realtime add table public.items, public.settings;
exception when duplicate_object then null; end $$;

-- 7) ▼ 여기 두 이메일을 바꾸세요 ▼
insert into public.allowed_users (email) values
  ('husband@example.com'),
  ('wife@example.com')
on conflict do nothing;
