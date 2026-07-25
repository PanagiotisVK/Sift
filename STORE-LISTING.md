# Sift — App Store listing (paste-ready)

Everything App Store Connect asks for on the "App Information" and version pages.
Character limits noted; all entries below fit them.

---

## App Name (30 chars max — shown under the icon)

```
Sift: Music Discovery
```

*(21 chars. If taken, fallbacks: "Sift — Find New Music", "Sift Music Discovery".)*

## Subtitle (30 chars max — the line under the name in search)

```
Songs you've never heard
```

*(24 chars.)*

## Category

- Primary: **Music**
- Secondary: **Entertainment** (optional)

## Keywords (100 chars max, comma-separated — invisible to users, pure search fuel)

```
music,discovery,new songs,swipe,find music,taste,friends,indie,underground,daily,preview,fresh
```

*(94 chars. No competitor names — Apple rejects trademark keywords.)*

## Promotional Text (170 chars max — editable anytime without review, shows above the description)

```
Every swipe digs past the hits. Sift learns your taste and finds the songs you'd never have found — then jumps you straight to the best part.
```

## Description (4000 chars max)

```
Everyone else swipes you through songs you already know. Sift is built for one thing: finding you songs you've never heard — and will love.

HOW IT WORKS
Pick a few genres and artists you like. Sift maps the world of music around your taste and deals you a daily hand of songs — not the hits everyone streams, but the album cuts, deep tracks and rising artists that fit you. Swipe right to keep, left to pass. That's it. Every swipe teaches Sift how deep your knowledge runs and where to dig next.

SKIP TO THE BEST PART
Sift analyzes each preview and jumps you straight to the hook — no sitting through intros to know if a song hits. Thirty seconds is enough when it's the right thirty seconds.

YOUR FINDS, YOURS
Every song you keep lands in your Finds: playable as a radio, grouped by genre, with one-tap links to open it in the streaming app you already use. Sift shows you the number that matters — what percentage of your Finds you'd never heard before.

FOLLOW WHAT YOU UNEARTH
Follow the artists you discover and Sift flags when they release something new. You found them first — stay first.

TASTE IS BETTER TRADED
Add friends and see your match percentage and what you share. Swipe through a friend's recent finds. Send a deck of picks and see which ones landed. Your next favorite song is probably in a friend's library already.

WHY SIFT
• Built for discovery — not another shuffle of your existing playlists
• A daily hand of songs keeps it fresh, not endless
• Learns how much you already know, and digs deeper as you go
• No ads. No selling your data. Works without an account.

Start swiping. Your next favorite song is out there — you've just never heard it.
```

*(~1,650 chars — room to grow.)*

## What's New (version 1.0)

```
First release — welcome to Sift. Swipe through fresh songs picked for your taste, skip straight to the best part, and build your library of Finds.
```

## URLs

- **Support URL:** `https://panagiotisvk.github.io/Sift/` *(the app page doubles as support until a real site exists; feedback goes to the email below)*
- **Marketing URL (optional):** `https://panagiotisvk.github.io/Sift/`
- **Privacy Policy URL:** `https://panagiotisvk.github.io/Sift/privacy.html`

## Contact / Review info (App Review section)

- First name / Last name / phone / email: yours
- **Demo account:** `riff.demo@facetmusic.app` / `facetdemo123`
- **Notes for reviewer:**

```
Sift is a music discovery app using 30-second catalog previews (Apple's iTunes preview API) with links out to full songs on streaming services. An account is optional — the app is fully usable without one. The demo account above is pre-filled with a taste profile. Account deletion is available in-app: You tab → Delete my account. Sign in with Apple is offered alongside email signup, on the same You tab.
```

*(The Sign in with Apple line matters — Guideline 4.8 is checked by hand, and telling
the reviewer exactly where the button lives saves a round trip.)*

## App Privacy questionnaire (the "nutrition label")

Answer "Yes, we collect data":
- **Contact Info → Email Address** — for App Functionality (account), linked to identity
- **User Content → Other User Content** (saved songs / taste profile) — App Functionality, linked to identity
- Everything else: **Not collected** (no tracking, no ads, no location, no analytics SDKs)

Data is **not** used for tracking. No third-party advertising.

## Screenshots

`design-previews/app-store/sift-store-1..5.png` (1320×2868, 6.9" iPhone size).
Upload in order 1→5:

1. **Discover** — "Songs you've never heard. Found." *(violet)*
2. **Finds + the 83% stat** — "Love it? Swipe. It's yours." *(amber)*
3. **Friends** — "Swipe your friends' taste" *(emerald)*
4. **Taste card** — "Your taste, on a card" *(pink)*
5. **Artist page** — "Follow what you unearth" *(blue)*

**Style: "liner notes"** (2026-07-25, third pass). Earlier versions are kept in
`v1-old/` (original) and `v2-glow/` (centred type over a coloured radial glow).

The glow version was competent but its ingredients — centred system-sans headline,
accent-coloured second line, soft radial glow behind a floating device — are the
default template you see on every generated app page. This version swaps the
ingredients instead of adjusting them:

- **The background is a real album cover, blown up and blurred**, not a synthetic
  gradient. That's the app's own backdrop treatment, so the poster and the product
  share a visual language — and the five frames differ from each other for an honest
  reason rather than a decorative one. Covers chosen for colour separation across the
  strip: Currents (violet), After Hours (amber), Future Nostalgia (blue), Lo Siento
  BB:/ (pink), The Slow Rush (gold).
- **Bahnschrift Condensed caps, hard left**, with a tracked-out section label over a
  short rule in the frame's colour. DIN-ish condensed reads as music press and gig
  poster; a system UI sans reads as software.
- **The phone bleeds off the bottom edge** instead of floating in the middle, which
  makes it a poster rather than a slide. Cropped so the Nope / Heard it / Love row
  still shows — that trio is the product in one glance.
- **A fine film grain** over everything, to kill the flat digital-gradient look.
- The header block is a fixed height with its contents bottom-aligned, so a two-line
  and a three-line headline still place the phone at the same y. The strip reads as
  a set rather than five loose images.

Earlier pass (kept for reference) — what changed from the original:

- **Each frame has its own accent colour.** All five were near-identical dark
  rectangles, and the App Store shows about two and a half of them at a time while
  scrolling — there was nothing to pull the eye along. The second headline line now
  carries that accent too.
- **The phones are straight.** The tilt shrank the type on exactly the screens that
  had the most of it.
- **The old #5 is gone.** It was the deck-intro screen, more than half empty black,
  sitting in the last position. Replaced by the taste card, which is the thing people
  actually screenshot and post.
- **The artist page is now captured through the real `openArtist()`.** The old one
  pasted in a Deezer promo photo and repeated one album cover five times; the shipping
  app uses the artist's top-song artwork and each track's own cover. Screenshots have
  to show the app that ships.
- **Fake handles have some personality** — `@mrsift`, `@nightbus`, and `@peter` on the
  taste card.

Known judgement call: screenshot 2 shows the Spotify / Apple Music / YouTube link
buttons in their brand colours, because that is genuinely what the Finds list looks
like. Cropping them out would misrepresent the app; leaving them in carries a small
risk of a metadata query about promoting competing services. Kept them — accuracy
wins, and it's the minimum-buttons view of that screen already.

## Pricing & Availability

- Free, all countries and regions.
- Sift Pro IAP comes later — do **not** configure in-app purchases for 1.0.

## Age Rating (App Store Connect asks this as a questionnaire — it won't let you submit without it)

Sift plays 30-second previews from the general music catalog, so some of them will
contain explicit lyrics. Answer honestly rather than optimistically — a reviewer who
finds swearing in an app rated 4+ treats it as a misrepresentation.

Recommended answers:

- **Profanity or Crude Humor:** *Infrequent/Mild* — catalog previews can contain
  explicit lyrics. (This is what lands the app at **12+**, in line with other music
  apps.)
- **Violence, Sexual Content, Nudity, Horror, Alcohol/Tobacco/Drugs, Gambling,
  Contests, Medical/Treatment Info, Simulated Gambling:** *None*
- **Unrestricted Web Access:** **No.** Sift opens external links in the system
  browser or the streaming app; it has no built-in browser.
- **User Generated Content:** **No.** Friends share songs from a fixed catalog —
  there is no free-text posting, no comments, no uploads.

Expected result: **12+**.

## Content Rights

App Store Connect asks: *"Does your app contain, show, or access third-party content?"*

- Answer **Yes**, then confirm you have the necessary rights.
- What that content is, if anyone asks: 30-second previews and artwork from Apple's
  public iTunes Search/Lookup API (used as intended, with links out to the store),
  plus open music data from MusicBrainz and ListenBrainz (CC0). No audio is hosted,
  cached or redistributed by Sift.

## Copyright field (App Information page)

```
2026 Peter Vlahos
```

*(Format is year + the name of the rights holder — your own legal name unless you've
formed a company. No © symbol, App Store Connect adds it.)*

## Agreements, Tax and Banking — the one people forget

**Business** (or **Agreements, Tax, and Banking**) in App Store Connect must show the
free-apps agreement as **Active**. If it's pending — an unaccepted contract or missing
tax details — the app can pass review and still not appear on the store. Check it
before submitting, not after.

Banking details are only needed if you ever charge for something; free apps don't
need them.

## Reminder before submitting for App Store review (not TestFlight)

- **Submit build 5 or later.** Build 4 and earlier predate the Sign in with Apple
  entitlement and would be rejected under Guideline 4.8. Build 5 is verified working
  from a release (TestFlight) build, not just a debug run — the entitlement rides on
  the provisioning profile, so those are genuinely different tests.
- Check the demo account below still logs in before submitting. Email confirmation is
  now switched on in Supabase, so a reviewer typing it must land in a confirmed
  account — an unconfirmed one would look broken to them.
- Small Business Program: apply/confirm after enrollment fully active.
