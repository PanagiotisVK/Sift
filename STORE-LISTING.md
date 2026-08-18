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
music,discovery,new songs,deep cuts,find music,taste,friends,indie,underground,daily,preview,fresh
```

*(98 chars. No competitor names — Apple rejects trademark keywords.)*

*`swipe` swapped for `deep cuts` on 2026-08-18. Keywords are invisible to users but
the reviewer reads them, and after the 4.3(a) follow-up the swipe mechanic is the only
surviving accusation — no reason to volunteer the word in a field nobody searching for
the app ever sees. "deep cuts" is also a phrase people genuinely type.*

## Promotional Text (170 chars max — editable anytime without review, shows above the description)

```
Sift listens to every preview and starts you at the chorus. Then it learns how much you already know, and digs past the hits until it finds what you've never heard.
```

## Description (4000 chars max)

```
Most music apps recommend you songs you already know. Sift is built for one thing: finding the ones you've never heard — and will love.

HOW IT WORKS
Pick a few genres and artists you like. Sift maps the world of music around your taste and deals you a daily hand of songs — not the hits everyone streams, but the album cuts, deep tracks and rising artists that fit you. Keep what you love, pass on what you don't, and every swipe recalibrates how deep Sift digs: recognise a lot and it reaches further past the popular results, find a keeper at that depth and it holds there. The app a crate-digger sees is not the app a casual listener sees.

SKIP TO THE BEST PART
Sift listens to every preview before you do. It measures the track's energy across its whole length, finds the loudest sustained passage rather than a single loud moment, and starts you a beat and a half before it — while making sure you never land in the fade-out. You hear the chorus first, not the intro. Thirty seconds is enough when it's the right thirty seconds.

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

*(2,015 chars of 4,000 — room to grow. The 1,825 figure here was stale; it
predated the 5 Aug rewrite.)*

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
RESUBMISSION - VERSION 1.0

This is a resubmission following the Guideline 4.3(a) finding on 5 August
(submission 091bf87b-af03-442a-b5ac-61d0bcc6acf0). I asked App Review which app Sift
was found to duplicate, and the reply restated the guideline without naming one, so I
have not been able to remove a specific overlap.

What I have changed instead is visibility. All three mechanisms described below were
already running in build 7 - but none of them are legible in a short session, and the
screenshots did not show them. Hook detection changes when playback starts, which is
imperceptible if you have never heard the song. Discovery depth needs dozens of swipes
before it visibly diverges. The recommendation graph looks like any "similar artists"
call from the outside. This build puts each one on screen, and the screenshots have
been replaced to match:

- Tap the "Related to <artist>" pill on any card to open Why this song? It shows the
  artist path that produced the pick, the tags it matched, how far past the popular
  results it reached, and the exact timestamp the hook analysis chose, with the reason.
- The waveform on every card now carries a visible marker at the detected hook.
- Tune your mix (sliders icon, top right) shows the current discovery depth as a live
  number and states how far your own swipes have moved it.

If you have two minutes, the Why this song? sheet is the fastest way to see that this
is not a wrapper around a preview feed. It is two taps from launch on the demo account.

WHAT SIFT DOES

Sift finds you songs you have never heard, from a catalogue you already have access
to. Three parts of it are original work and are the reason the app exists:

1. HOOK DETECTION. Every 30-second preview is decoded through the Web Audio API and
analysed for its energy envelope in 0.25-second frames. That envelope is smoothed over
roughly two seconds so sustained loudness wins over a single loud transient, and the
closing seconds are excluded so playback can never land in a fade-out. Playback then
starts 1.5 seconds before the resulting peak, and the same analysis draws the waveform
scrubber on the card. You hear the chorus first instead of the intro — which is the
difference between 30 seconds being enough to judge a song and not being enough.

2. ADAPTIVE DISCOVERY DEPTH. Sift tracks how much of what it shows you is already
familiar to you, and uses that to decide how far past the popular results to reach when
it builds the next set. Swiping moves it continuously: recognising a lot pushes the app
deeper into the catalogue, and finding something you keep at a given depth eases it
back. Two people starting from the same declared taste but with different listening
knowledge are shown materially different music.

3. OPEN-DATA RECOMMENDATION GRAPH. Artist relationships come from ListenBrainz
co-listening statistics and MusicBrainz tags, including alias resolution so that
artists filed under non-Latin names resolve correctly. This is not a store's built-in
"similar artists" field.

Apple's iTunes Search API supplies the preview audio and artwork, used as documented
and with links out to the store. It is the playback layer — the selection, ordering,
audio analysis and personalisation above are all my own work.

PRACTICAL NOTES

- An account is optional; the app is fully usable without one.
- The demo account above is pre-filled with a taste profile, so the deck is populated
  immediately on first launch.
- Sign in with Apple is offered alongside email signup, on the You tab.
- Account deletion is in-app: You tab → Delete my account.
```

*(Rewritten 5 Aug 2026 after the build 7 4.3(a) rejection. The old note opened
"a music discovery app using 30-second catalog previews (Apple's iTunes preview API)
with links out to full songs" — that sentence describes the whole category rather than
this app, and reads like a wrapper. The note now leads with what only Sift does and
mentions the iTunes API second, as the playback layer. The four practical lines are
kept because they still save round trips: Guideline 4.8 is checked by hand, and 5.1.1(v)
account deletion is checked by hand too, so telling the reviewer exactly where both
live is worth the space. Deliberately does not mention the rejection — a new reviewer
sees that history in Resolution Center anyway, and naming it primes them.)*

## App Privacy questionnaire (the "nutrition label")

Answer "Yes, we collect data from this app", then tick exactly three boxes:

- **Contact Info → Email Address** — signup, and Apple's private relay address for
  Hide My Email users
- **Identifiers → User ID** — the Supabase account id and the username friends can
  see. Apple's definition of User ID explicitly covers "screen name, handle,
  account ID", so this one counts even though it isn't a tracking identifier.
- **User Content → Other User Content** — saved Finds, taste summary, friend
  connections, shared decks

Everything else: **Not collected.** No location, contacts, browsing or search
history, purchases, usage data or diagnostics — there is no analytics SDK and no
crash reporter in the build.

For all three, the follow-up answers are identical:

- **Purpose: App Functionality** only. Not Product Personalization — the
  recommendation engine runs on-device from local storage; the cloud copy exists to
  restore a library and to power friends. Ticking Personalization would overstate
  what the server does on your public privacy label.
- **Linked to identity: Yes** — all three hang off an account.
- **Used for tracking: No.** "Tracking" here means combining data with other
  companies' data for advertising, or selling to data brokers. Sift does neither.

**Do not declare Name.** Sign in with Apple is called with `scopes: "email name"`,
but the handler reads only `identityToken` — the name is never stored, so it isn't
collected. (Worth dropping `name` from the scope string post-launch, since it asks
for something unused.)

## Screenshots

`store-shots/01..05.png` (1290x2796, the 6.9" iPhone slot). Upload in this order - the
first three are what show in App Store search results, so they carry the 4.3 argument:

1. `01-why-this-song.png` - "Every pick shows its work"
2. `02-hook.png` - "Starts at the hook, not the intro"
3. `03-depth.png` - "Digs deeper the more you know"
4. `04-finds.png` - "85% of it was new to you"
5. `05-shef.png` - "A daily hand of twenty songs"

Real device captures from **build 22** on iPhone 17 Pro (native 1206x2622), uniformly
upscaled 7% to 1290x2796 with no crop or letterbox, status bar trimmed, captioned on
the app's own ground (#09090b) in its own palette. Built by `compose.py` (Pillow,
Lanczos). Captions are Segoe UI Bold, not SF Pro - Apple does not ship SF Pro for
Windows. One-line swap if the set is ever rebuilt on a Mac.

**These replace `design-previews/app-store/sift-store-1..5.png`, which must not be
used again.** Those were marketing posters - a device mockup over a blown-up blurred
commercial album cover, a different accent colour per frame, fake handles. Two
problems with them on this submission specifically. First, that composition is the
default App Store poster template, on an app whose only remaining rejection ground is
a template accusation. Second, they showed none of the machinery the 4.3(a) reply
argues for, so the reviewer of build 7 had nothing in front of them.

Rule that governs the set: every frame is a screen the attached build actually
renders. Anything out of `design-previews/` - the trail-chain pill, the Shef pose set,
the setup concepts - is Guideline 2.3.3 and a brand new rejection reason.

Judgement call carried over from the old set: shot 4 (Finds) is cropped above the
track list, because each saved track renders Spotify / Apple Music / YouTube buttons
in full brand colour. One row is visible, so the screen is still honest - but four
rows of Spotify green in an App Store screenshot is loud third-party branding on a
submission that cannot afford a new argument.

## Pricing & Availability

- Free, all countries and regions.
- Sift Pro IAP comes later — do **not** configure in-app purchases for 1.0.

## Age Rating (App Store Connect asks this as a questionnaire — it won't let you submit without it)

Sift plays 30-second previews from the general music catalog, so some of them will
contain explicit lyrics. Answer honestly rather than optimistically — a reviewer who
finds swearing in an app rated 4+ treats it as a misrepresentation.

**These are the answers actually submitted for 1.0 on 2026-07-26, which produced
13+.** The 2025 redesign splits the old single questions into seven steps with
None / Infrequent / Frequent per row.

The rule that resolves every row: **Sift depicts nothing.** It shows album artwork
from Apple's curated store and plays 30-second audio. So rows about *references and
themes* get **Infrequent**; rows about *graphic or explicit depictions* get
**None**. The one exception is the weapons row, which explicitly counts references.

- **Profanity or Crude Humor:** *Infrequent* — catalog previews contain explicit
  lyrics. On its own this only produced **9+**, which is why the rows below matter.
- **Mature or Suggestive Themes:** *Infrequent* — lyrics reference mature topics
  constantly.
- **Sexual Content or Nudity:** *Infrequent* — non-explicit lyrical content plus the
  occasional suggestive album cover. This is what Apple Music declares.
- **Graphic Sexual Content and Nudity:** *None* — there are no depictions of sexual
  activity anywhere in the app.
- **Alcohol, Tobacco, or Drug Use or References:** *Infrequent* — lyrics, constantly.
- **Guns or Other Weapons:** *Infrequent* — this row counts "references to", and
  rap, drill, metal and rock lyrics reference weapons. Declaring drug references but
  not weapon references would be inconsistent.
- **Cartoon/Fantasy Violence, Realistic Violence, Prolonged Graphic or Sadistic
  Violence:** *None* — all three are about depicting physical conflict.
- **Horror/Fear Themes, Medical/Treatment Information, Gambling, Contests:** *None*

Don't stop at "Infrequent profanity and nothing else" — that describes a podcast
app, not a general music catalog, and it under-rates at 9+.

**Step 7 — Additional Information:** leave **Not Applicable** selected. Never pick
*Made for Kids*: the Kids Category forbids external links without a parental gate,
and Sift links out to Spotify and Apple Music, so it would be rejected outright.
Leave the Age Suitability URL blank. Only use *Override to Higher Age Rating* if the
calculated number looks too low for what the app actually plays.

**Expected side effect:** App Store Connect will warn that a 13+ app can't be sold
in **Afghanistan** under local content law. That's normal for this band and affects
a negligible market. Do not soften the content answers to recover it.
### In-App Controls — both **NO**

- **Parental Controls** ("settings or tools that allow parents/guardians to monitor,
  manage or restrict a child's access") — Sift has none.
- **Age Assurance** ("mechanism to confirm an individual's age") — Sift never asks
  anyone's age.

Only ever answer Yes here if the safeguard genuinely exists in the build. Claiming
a protection you don't have is a misrepresentation, and worse than a high rating.

### Capabilities — every row **NO**

- **Unrestricted Web Access** — Sift opens external links in Safari or the streaming
  app; it has no built-in browser.
- **User-Generated Content** ("broad distribution of content created by users") —
  users don't create content. They save catalog songs. No posts, comments, uploads
  or bios.
- **Social Media** — the definition is narrow: *"redistribution, amplification, or
  interaction with user-generated content through a social feed or similar discovery
  method that visibly spreads content to many users."* Sift has no feed, nothing
  amplifies, and a deck goes to one mutually-added friend. Not social media, despite
  having a friends graph.
- **Social Media Disabled for Users Under 13** — answering Yes asserts that you call
  Apple's **Declared Age Range API** before enabling social features. Sift doesn't
  call it and has no social capabilities to gate, so Yes would be false.
- **Messaging and Chat** — users cannot author a message. Sending a deck transmits a
  fixed list of catalog songs; there is no text field anywhere in the flow. That's
  sharing, not communication.
- **Advertising** — no ads, and the description and privacy policy both promise none.

Expected result: **13+** (Apple replaced the old 12+ band with 13+ in the 2025
questionnaire redesign). The rating comes entirely from the profanity answer.

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

*(Format is year + the rights holder. No © symbol, App Store Connect adds it.)*

Use **Peter**, not Panagiotis, even though Panagiotis is the legal name. The rule
isn't "legal name" — it's "match the rights holder as Apple lists you", and the
Apple Developer account is registered as Peter Vlahos. That name is also what
shows publicly as the app's seller, so the two should agree. The legal name is
already on file where it actually matters — Agreements, Tax and Banking — and a
display-name mismatch there is normal. If you ever incorporate, this becomes the
company name.

## Agreements, Tax and Banking — the one people forget

**Business** (or **Agreements, Tax, and Banking**) in App Store Connect must show the
free-apps agreement as **Active**. If it's pending — an unaccepted contract or missing
tax details — the app can pass review and still not appear on the store. Check it
before submitting, not after.

Banking details are only needed if you ever charge for something; free apps don't
need them.

## Reminder before submitting for App Store review (not TestFlight)

- **Submit build 22.** Not build 20 - it was archived 5 Aug and predates the hook
  marker, the why-sheet and the typed-artist fix, so screenshots 1, 2 and 3 show
  screens that build does not contain (Guideline 2.3.3). The build you screenshot is
  the build you attach.
- Historical floor, kept for reference: **build 7 or later.** Build 6 is *not* acceptable: it still declares iPad
  support, so App Store Connect blocks the submission until you upload 13-inch iPad
  screenshots — and Sift has no iPad layout worth screenshotting. Build 7 is iPhone
  only. Beyond that, three more reasons a lower build won't do:
  - Build 4 and earlier predate the Sign in with Apple entitlement and would be
    rejected under Guideline 4.8. Build 5 is verified working from a release
    (TestFlight) build, not just a debug run — the entitlement rides on the
    provisioning profile, so those are genuinely different tests.
  - Build 5 predates the non-Latin discovery fix (commit fb84fba), which means it
    returns an empty or off-genre deck for Greek, Japanese, Korean, Arabic and
    Cyrillic artists. Capacitor bundles the web assets into the binary, so this
    needs a fresh archive — pushing to GitHub Pages does not reach the app.
- Check the demo account below still logs in before submitting. Email confirmation is
  now switched on in Supabase, so a reviewer typing it must land in a confirmed
  account — an unconfirmed one would look broken to them.
- Small Business Program: apply/confirm after enrollment fully active.
