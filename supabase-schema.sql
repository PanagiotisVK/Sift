-- ============================================================
-- Facet — social backend schema (run once in Supabase SQL Editor)
-- Creates: profiles (public taste cards) + friendships (who you added)
-- Security: Row Level Security so people can only edit their own data.
-- ============================================================

-- 1) PROFILES ------------------------------------------------
create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  username     text unique not null,
  display_name text,
  archetype    text,
  top_genres   jsonb default '[]'::jsonb,
  top_artists  jsonb default '[]'::jsonb,
  finds_count  int  default 0,
  adventure    int  default 1,
  updated_at   timestamptz default now()
);

alter table public.profiles enable row level security;

-- Anyone can read profiles (they're public taste cards, used to look up friends).
drop policy if exists "profiles readable" on public.profiles;
create policy "profiles readable" on public.profiles
  for select using (true);

-- You can only create / edit YOUR OWN profile row.
drop policy if exists "insert own profile" on public.profiles;
create policy "insert own profile" on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles
  for update using (auth.uid() = id);

-- 2) FRIENDSHIPS ---------------------------------------------
-- Directed edges: (user_id added friend_id). Simple + expandable.
create table if not exists public.friendships (
  user_id    uuid references auth.users(id) on delete cascade,
  friend_id  uuid references auth.users(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, friend_id)
);

alter table public.friendships enable row level security;

-- You can only see / add / remove your OWN friend edges.
drop policy if exists "see own friendships" on public.friendships;
create policy "see own friendships" on public.friendships
  for select using (auth.uid() = user_id);

drop policy if exists "add own friendships" on public.friendships;
create policy "add own friendships" on public.friendships
  for insert with check (auth.uid() = user_id);

drop policy if exists "remove own friendships" on public.friendships;
create policy "remove own friendships" on public.friendships
  for delete using (auth.uid() = user_id);
