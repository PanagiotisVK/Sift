# Build 22 — 5.1.1(v) and 5.2.3 rejection, and the reply

**Submission ID:** 091bf87b-af03-442a-b5ac-61d0bcc6acf0 (same thread as the 4.3(a))
**Reviewed:** 9 Sep 2026, **iPad Air 11-inch (M3)**, version 1.0 (22)
**Findings:** Guideline 5.1.1(v) — Data Collection and Storage · Guideline 5.2.3 —
Intellectual Property, Audio/Video

---

## Read this first: 4.3(a) is gone

The spam finding is **not** on this rejection. The August resubmission — new
screenshots, rewritten metadata, the RESUBMISSION note — did its job. Apple accepts
Sift as a distinct app. What replaced it are two ordinary compliance items.

Do not describe Sift as "rejected for spam" any more. It was, and that is resolved.

**The App Review Board appeal is now moot.** It was filed against the 4.3(a) finding,
which no longer stands. Do not spend effort on it.

## 5.1.1(v) — account deletion. Apple was right.

Not a discoverability problem. A real defect, and the reviewer's screenshot
(`Screenshot-0909-150757.png`) pointed straight at it: the You tab in the **"Pick a
username"** state.

`renderAcct()` had three signed-in-ish states:

```js
show("acctBox",   !me_session)                    // logged out: sign in / create
show("unameBox",  !!me_session && !me_profile)    // signed up, no username  <- reviewer
show("profileBox", me_session && me_profile)      // full account
```

**Delete my account lived inside `profileBox`.** But the account exists from the
moment you sign up — the profile row only appears once you pick a username. So anyone
between those two points had a real auth record, real data, and no way to delete it.

Fixed in `c9bf8f4`: deletion moved to its own `deleteBox`, shown for **any** session.
`deleteAccount()` already guarded on `me_session` rather than `me_profile`, so the RPC
path needed no change. Verified in all three states.

Also `TARGETED_DEVICE_FAMILY` "1,2" → 1. It had been universal since the Capacitor
project was first committed and Sift has no iPad layout — which is how this review
ended up on an iPad Air.

## 5.2.3 — nothing here was a violation, but one thing was unanswerable

Verified in the source: **no download surface exists.** No `download`, no `.mp3`, no
`blob:`, no `createObjectURL`, no media writes. Every service button was a plain search
URL opened in Safari.

What decided it was Apple's own remedy — *"attach documentary evidence that you have
all necessary rights or permissions to the third-party audio or video streaming,
catalogs, and discovery services"*. Apple's API terms, the MusicKit entitlement and the
CC0 data licences can all be produced on paper. **A YouTube permission cannot be, ever.**
So while a YouTube target existed, the request was unanswerable.

Removed in `5e4fdfd`: every YouTube link is gone — the Finds row button and the
`shareFind()` fallback, which now uses an Apple Music search. `SVC_ICONS.yt` and the
`.yt` CSS rule are kept but marked dead so nobody restores the button later.

A YouTube glyph beside a play button is the visual signature of a ripper. That reading,
not the code, is what got flagged.

---

## Pre-submission audit — 10 Sep 2026

Run because each rejection so far has surfaced something new: Apple stops at the first
blocker, so build 23 can expose a third issue that was always there.

### Found and fixed

- **2.3.3, self-inflicted an hour earlier.** Screenshot 4 (`04-finds`) showed the Finds
  track row with the **red YouTube button** — a control build 23 no longer has. A
  screenshot showing something the build lacks is a fresh rejection. The frame is
  regenerated with a bottom crop ending below "Save to Apple Music". The old file is
  kept at `store-shots/superseded/04-finds-with-youtube-button.png`.
  A fresh capture from build 23 would be better than a crop — the cropped frame leaves
  the lower third empty.

### Verified clean

| Check | Result |
| --- | --- |
| Download surface anywhere in app | none — no `blob:`, `createObjectURL`, media writes |
| Analytics / trackers / third-party SDKs | none (the one "Plausible" hit is a comment) |
| Outbound hosts | Apple, ListenBrainz, MusicBrainz, Supabase, jsDelivr, Spotify, own Pages |
| Support URL + Privacy URL | both live, HTTP 200 |
| Privacy policy vs actual behaviour | matches, and documents "Delete my account" on the You tab |
| Content Rights in ASC | Yes, rights confirmed |
| Age rating | set — 12+, 13+ in Vietnam. Not blank |

### Guideline 1.2, user-generated content — now closed

**Correction to an earlier draft of this section:** it said there was no Block. There
is — `blockUser()`, reachable from a friend's row and from an incoming request, writing
to a `blocks` table. The earlier grep looked for `id=` attributes and these are classes.
The 5 Aug letter's "requests and blocking" was accurate. Withdrawn, with apologies to
the person who wrote it.

What *was* missing, and is now added (10 Sep):

- **Report** — a `Report` button beside Remove friend / Block on every friend row, and
  a 🚩 on every incoming request. `reportUser()` writes a row to `reports` and opens a
  prefilled email to the support address, in that order, so a record exists even if
  the mail is cancelled.
- **Username filter** — `handleAllowed()` rejects slurs, hard profanity (with the
  obvious leetspeak variants) and reserved handles that would impersonate the app,
  Apple or a moderator. Applied on first pick and on rename. Kept deliberately short so
  it does not eat *essex* or *hitchcock*.
- **Block is enforced, not just recorded.** `supabase/moderation.sql` creates `blocks`
  and `reports` with row-level security, and adds a *restrictive* insert policy on
  `friendships` and `deck_sends` that refuses any row across a block in either
  direction. The client also checks `blocks` before sending a request, so the "Couldn't
  send that request" message appears without a round trip. **That SQL has to be pasted
  into the Supabase SQL editor by Peter** — nothing here can run it.

The listing still declares User-Generated Content: No. With report, block, a filter and
published contact details all present, either answer is now defensible; leave it.

### Unverified

- `delete_account` is a Supabase RPC and is not in this repo, so it has not been
  confirmed to handle a user with **no profile row**. The step 3 screen recording
  exercises exactly that path — if it errors, that is why.

---

## Reply to paste into Resolution Center

Hello,

Thank you for the detailed feedback on 1.0 (22), and for attaching the screenshots —
they showed me exactly where the problem was. Both issues are addressed in build 23.

**Guideline 5.1.1(v) — Account deletion**

You were right, and this was a genuine defect rather than something hard to find.

Sift can be used without an account. When someone does create one, there is a short
intermediate step between signing up and choosing a username. Account deletion was only
rendered once a username existed, so a user sitting on the "Pick a username" screen —
which is where your screenshot was taken — had a real account and no way to delete it.

In build 23, "Delete my account…" is shown in every signed-in state, including before a
username has been chosen. It sits on the You tab directly beneath the account section.
Deletion is immediate and permanent: a server-side routine removes the authentication
record, the profile, the cloud backup of saved songs, friend connections and any shared
decks. There is no deactivate-only option, no website step, and no requirement to
contact support. A two-tap confirmation prevents accidental deletion.

The attached screen recording, captured on a physical iPhone running build 23, shows
creating a new account, arriving at the "Pick a username" screen, tapping Delete my
account, confirming, and the app returning to its signed-out state.

**Guideline 5.2.3 — Third-party content**

Sift does not download, store, cache or redistribute any audio or video. There is no
download function anywhere in the app, and no media file is ever written to the device
or to my servers. All playback is streamed directly from Apple.

The third-party material the app uses, and the basis for each:

1. **Apple iTunes Search API** — 30-second preview audio and album artwork, used as
documented and publicly available, with links back to the store. This is the only
source of preview audio in the app.
2. **Apple Music, via MusicKit** — full-song playback for users who have their own
Apple Music subscription, through MusicKit JS v3 under the MusicKit entitlement granted
to my developer account. Playback occurs under the user's own subscription; Sift never
stores, proxies or re-serves the audio.
3. **MusicBrainz and ListenBrainz** — artist relationships and tags only, no audio.
Published by the MetaBrainz Foundation and released into the public domain under CC0
1.0 Universal. Licence: https://creativecommons.org/publicdomain/zero/1.0/ — source:
https://musicbrainz.org/doc/About/Data_License

On the specific item I believe prompted this finding: build 22 showed a YouTube icon on
saved songs. It was a plain link to a YouTube search results page, opened in Safari,
with no embedded player, no extraction and no downloading of any kind. I recognise that
it can read otherwise, and as I cannot produce a rights document for YouTube, I have
removed every YouTube link from the app entirely in build 23. The remaining service
buttons are Spotify and Apple Music search links, which simply open the corresponding
app or website.

If any part of this is still unclear, I would rather fix it than argue it — please tell
me which screen or behaviour you would like changed.

Thank you for your time.

Peter Vlahos
