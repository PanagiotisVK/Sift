-- ============================================================
-- SIFT USAGE — paste any of these into Supabase SQL Editor.
-- ============================================================

-- 1) The daily pulse: people, swipes, loves — last 14 days
select day,
       count(*)                as active_devices,
       sum(swipes)             as swipes,
       sum(loves)              as loves,
       sum(decks_sent)         as decks_sent,
       sum(deck_opens)         as deck_opens,
       sum(daily_done)         as finished_todays_20
from usage_daily
where day > current_date - 14
group by day order by day desc;

-- 2) Today at a glance
select count(*) as devices_today, sum(swipes) as swipes, sum(loves) as loves
from usage_daily where day = current_date;

-- 3) How deep do sessions go? (average swipes per active device, by day)
select day, round(avg(swipes), 1) as avg_swipes_per_device
from usage_daily where day > current_date - 14 and swipes > 0
group by day order by day desc;

-- 4) Platform split, last 7 days
select platform, count(distinct device) as devices, sum(swipes) as swipes
from usage_daily where day > current_date - 7
group by platform;

-- 5) Retention-ish: devices seen on 2+ different days in the last week
select count(*) from (
  select device from usage_daily
  where day > current_date - 7
  group by device having count(distinct day) >= 2
) x;
