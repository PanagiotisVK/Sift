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

-- ============================================================
-- IN-APP DECK SENDING (added 2026-07-27)
-- A deck can be delivered straight to a friend inside Sift;
-- links remain the fallback for people without the app.
-- ============================================================
create table if not exists public.deck_sends (
  id uuid primary key default gen_random_uuid(),
  deck_id uuid not null references public.decks(id) on delete cascade,
  sender uuid not null references public.profiles(id) on delete cascade,
  recipient uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  opened boolean not null default false,
  unique (deck_id, recipient)
);

alter table public.deck_sends enable row level security;

-- You can only send decks YOU own, as yourself.
drop policy if exists "send own decks" on public.deck_sends;
create policy "send own decks" on public.deck_sends
  for insert with check (
    auth.uid() = sender
    and exists (select 1 from public.decks d where d.id = deck_id and d.owner = auth.uid())
  );

-- Sender and recipient both see the send (sender: "sent ✓", recipient: inbox).
drop policy if exists "see own sends" on public.deck_sends;
create policy "see own sends" on public.deck_sends
  for select using (auth.uid() = sender or auth.uid() = recipient);

-- Only the recipient marks a send opened.
drop policy if exists "recipient marks opened" on public.deck_sends;
create policy "recipient marks opened" on public.deck_sends
  for update using (auth.uid() = recipient) with check (auth.uid() = recipient);

-- ============================================================
-- FRIEND REQUESTS + BLOCKS (added 2026-07-27)
-- Friendships now start as a REQUEST the other person accepts;
-- every pre-existing row is grandfathered as accepted. Blocks
-- stop requests and in-app deck sends at the database level.
-- ============================================================
create table if not exists public.blocks (
  blocker    uuid not null references public.profiles(id) on delete cascade,
  blocked    uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker, blocked)
);
alter table public.blocks enable row level security;
drop policy if exists "manage own blocks" on public.blocks;
create policy "manage own blocks" on public.blocks
  for all using (auth.uid() = blocker) with check (auth.uid() = blocker);

alter table public.friendships add column if not exists status text not null default 'accepted';

-- Both endpoints see the edge — the recipient needs incoming rows for requests,
-- and this also (finally) powers the "added you" activity feed properly.
drop policy if exists "see own friendships" on public.friendships;
drop policy if exists "see friendships to me" on public.friendships;
drop policy if exists "see own edges" on public.friendships;
create policy "see own edges" on public.friendships
  for select using (auth.uid() = user_id or auth.uid() = friend_id);

-- Requests come from you, as you — never to or from someone in a block.
drop policy if exists "add own friendships" on public.friendships;
create policy "add own friendships" on public.friendships
  for insert with check (
    auth.uid() = user_id
    and not exists (select 1 from public.blocks b
      where (b.blocker = friend_id and b.blocked = user_id)
         or (b.blocker = user_id and b.blocked = friend_id))
  );

-- The recipient answers a request (accepting flips its status).
drop policy if exists "recipient answers" on public.friendships;
create policy "recipient answers" on public.friendships
  for update using (auth.uid() = friend_id) with check (auth.uid() = friend_id);

-- Either endpoint can sever a friendship, withdraw, or decline a request.
drop policy if exists "remove own friendships" on public.friendships;
create policy "remove own friendships" on public.friendships
  for delete using (auth.uid() = user_id or auth.uid() = friend_id);

-- Deck sends respect blocks too.
drop policy if exists "send own decks" on public.deck_sends;
create policy "send own decks" on public.deck_sends
  for insert with check (
    auth.uid() = sender
    and exists (select 1 from public.decks d where d.id = deck_id and d.owner = auth.uid())
    and not exists (select 1 from public.blocks b
      where (b.blocker = recipient and b.blocked = sender)
         or (b.blocker = sender and b.blocked = recipient))
  );

-- Avatar (added 2026-07-27): "<colorIndex>|<emoji>" from the app's curated
-- palette/glyph set; null = plain initial. No uploads, no moderation surface.
alter table public.profiles add column if not exists avatar text;
