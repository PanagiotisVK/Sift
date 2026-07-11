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

-- 3) SEND-A-DECK ---------------------------------------------
-- decks: a bundle of songs one user sends for a friend to swipe.
create table if not exists public.decks (
  id         uuid primary key default gen_random_uuid(),
  owner      uuid references auth.users(id) on delete cascade,
  title      text,
  tracks     jsonb not null,
  created_at timestamptz default now()
);

alter table public.decks enable row level security;

-- Anyone can open a deck by its link (public read); only the owner writes it.
drop policy if exists "decks readable" on public.decks;
create policy "decks readable" on public.decks
  for select using (true);

drop policy if exists "insert own deck" on public.decks;
create policy "insert own deck" on public.decks
  for insert with check (auth.uid() = owner);

drop policy if exists "delete own deck" on public.decks;
create policy "delete own deck" on public.decks
  for delete using (auth.uid() = owner);

-- deck_results: which songs a swiper loved (one row per swiper per deck).
create table if not exists public.deck_results (
  deck_id     uuid references public.decks(id) on delete cascade,
  swiper      uuid references auth.users(id) on delete cascade,
  swiper_name text,
  loved       jsonb default '[]'::jsonb,
  created_at  timestamptz default now(),
  primary key (deck_id, swiper)
);

alter table public.deck_results enable row level security;

-- A swiper writes their own result; the deck OWNER (or the swiper) can read it.
drop policy if exists "insert own result" on public.deck_results;
create policy "insert own result" on public.deck_results
  for insert with check (auth.uid() = swiper);

drop policy if exists "update own result" on public.deck_results;
create policy "update own result" on public.deck_results
  for update using (auth.uid() = swiper);

drop policy if exists "read results" on public.deck_results;
create policy "read results" on public.deck_results
  for select using (
    auth.uid() = swiper
    or auth.uid() = (select owner from public.decks d where d.id = deck_id)
  );
