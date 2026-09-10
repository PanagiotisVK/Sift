-- Sift — moderation tables and policies. Paste the whole file into the Supabase
-- SQL editor and run it once. Every statement is idempotent, so running it twice
-- is harmless.
--
-- Why this exists (2026-09-10): the app already has Block and now has Report, and
-- the Block toast promises "they can't request you or send you decks". That promise
-- is only true if the database refuses the insert. The client checks `blocks` before
-- sending a request too, but the client can be bypassed; this cannot.

-- ---------------------------------------------------------------------------
-- blocks: who has blocked whom. One row per direction.
-- ---------------------------------------------------------------------------
create table if not exists public.blocks (
  blocker    uuid not null references auth.users(id) on delete cascade,
  blocked    uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker, blocked),
  check (blocker <> blocked)
);

alter table public.blocks enable row level security;

drop policy if exists "blocks: see my own"    on public.blocks;
drop policy if exists "blocks: add my own"    on public.blocks;
drop policy if exists "blocks: remove my own" on public.blocks;

-- You can see rows where you are on EITHER side. The app needs the reverse
-- direction to stop you re-requesting someone who blocked you, and it never
-- displays which side did the blocking.
create policy "blocks: see my own" on public.blocks
  for select using (auth.uid() = blocker or auth.uid() = blocked);
create policy "blocks: add my own" on public.blocks
  for insert with check (auth.uid() = blocker);
create policy "blocks: remove my own" on public.blocks
  for delete using (auth.uid() = blocker);

-- ---------------------------------------------------------------------------
-- reports: a person reported another person. Append-only from the client.
-- Read these in the Supabase dashboard; nothing in the app displays them.
-- ---------------------------------------------------------------------------
create table if not exists public.reports (
  id         bigint generated always as identity primary key,
  reporter   uuid not null references auth.users(id) on delete cascade,
  reported   uuid not null references auth.users(id) on delete cascade,
  reason     text not null default 'user',
  created_at timestamptz not null default now()
);

alter table public.reports enable row level security;

drop policy if exists "reports: file my own" on public.reports;
create policy "reports: file my own" on public.reports
  for insert with check (auth.uid() = reporter);
-- No select policy on purpose: reporters never see the queue, only the owner does.

-- ---------------------------------------------------------------------------
-- The enforcement: a friend request cannot be created across a block in either
-- direction. Existing insert policies on friendships stay as they are; this one
-- is an additional check the row must also pass.
-- ---------------------------------------------------------------------------
create or replace function public.not_blocked(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select not exists (
    select 1 from public.blocks
    where (blocker = a and blocked = b) or (blocker = b and blocked = a)
  );
$$;

drop policy if exists "friendships: not across a block" on public.friendships;
create policy "friendships: not across a block" on public.friendships
  as restrictive
  for insert
  with check (public.not_blocked(user_id, friend_id));

-- Deck sends get the same guard, so "or send you decks" in the toast is true too.
-- Columns match the app's insert: deck_sends(deck_id, sender, recipient).
drop policy if exists "deck_sends: not across a block" on public.deck_sends;
create policy "deck_sends: not across a block" on public.deck_sends
  as restrictive
  for insert
  with check (public.not_blocked(sender, recipient));

-- ---------------------------------------------------------------------------
-- Sanity check — run after the above; every row should say true / true / true.
-- ---------------------------------------------------------------------------
select
  to_regclass('public.blocks')  is not null as blocks_table,
  to_regclass('public.reports') is not null as reports_table,
  exists (select 1 from pg_policies where policyname = 'friendships: not across a block') as friendship_guard;
