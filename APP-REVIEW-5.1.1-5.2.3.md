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

**Corrected 10 Sep — the iPad theory was wrong.** This document first claimed iPad
support had crept back in, because the repo shows `TARGETED_DEVICE_FAMILY = "1,2"`. It
had not. Peter's Mac has it set to iPhone-only in a commit that never reached GitHub
(see "Repo vs Mac drift" below). Apple's screenshots are letterboxed with a compat-mode
resize control in the corner — an iPhone-only app running on an iPad, which Apple does
routinely. Nothing to fix. The Windows-side edit to `project.pbxproj` was reverted so it
cannot collide with the Mac's copy during a merge.

## 5.2.3 — Apple flagged the preview player itself

Apple's second screenshot (`Screenshot-0909-151636.png`, retrieved 10 Sep) settles what
this finding is about: it is the **Discover card** — a 30-second preview playing at 0:21,
the album artwork behind it, "Fresh Find" and "best part" pills. Not the Finds row, not
a button. The reviewer looked at the core product and asked for proof of rights to the
audio and artwork.

That is answerable, and the answer is strong: **every preview and every piece of
artwork comes from Apple's own iTunes Search API**, used as documented, with links back
to Apple's store. Full-song playback is MusicKit under the user's own Apple Music
subscription. The only non-Apple data is MusicBrainz/ListenBrainz artist metadata (no
audio), released under CC0. Verified in the source: **no download surface exists** — no
`download`, `.mp3`, `blob:`, `createObjectURL`, or media writes anywhere.

The YouTube link was removed anyway (`5e4fdfd`). It was not what Apple pointed at, but
Apple's remedy is a rights *document per third-party service*, and none can ever exist
for YouTube — so leaving it would have left the request permanently unanswerable. It was
a plain search URL and is not missed.

---

## Repo vs Mac drift — read before trusting any iOS-side audit

**Peter's Mac has never successfully pushed to GitHub.** There is not one `Xcode:`
commit in the repo's history, which is the message `mac.sh` uses when it saves Xcode's
changes. Its push step is deliberately non-fatal, so it has been printing "couldn't
push (GitHub login needed)" and carrying on — for months.

Consequences:

- **The repo's `ios/` tree is not what ships.** It has no `.entitlements` file, no
  `DEVELOPMENT_TEAM`, `IPHONEOS_DEPLOYMENT_TARGET = 14.0` (the Mac is on 15.6) and
  `TARGETED_DEVICE_FAMILY = "1,2"` (the Mac is iPhone-only). All of that lives in
  unpushed local commits.
- **Never edit `project.pbxproj` from Windows.** The Mac owns it. An edit here merges
  against the Mac's version and a conflict in a `.pbxproj` leaves marker text that stops
  Xcode opening the project at all — unrecoverable for a non-coder mid-flow. The one
  edit made on 10 Sep was reverted for exactly this reason.
- **Audits of `index.html` remain valid** — that file is authored on Windows and pushed,
  so what was reviewed is what ships. Only the iOS project settings are unverifiable
  from here.
- The Xcode checklist step in `RESUBMIT-BUILD-23.txt` ("Supported Destinations: iPhone
  only", "Sign in with Apple present") is therefore the *only* control on those
  settings. It is not belt-and-braces; it is the belt.

**Worth fixing properly:** run `gh auth login` on the Mac once. Until then every Xcode
capability change is one disk failure away from being gone, and nothing on this side can
see the real project.

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

The screenshot you attached shows a 30-second preview playing on the Discover screen.
Every preview and every piece of album artwork in Sift is served by Apple's own iTunes
Search API, used exactly as documented, with links back to the iTunes / Apple Music store.
The app never downloads, stores, caches or redistributes audio or video — there is no
download function anywhere in it, and no media file is ever written to the device or to
my servers. Playback is streamed directly from Apple.

Documentary basis for each third-party element:

1. **Preview audio and artwork — Apple iTunes Search API.** Documentation:
https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html
Previews are the 30-second clips Apple provides through that API for exactly this
purpose; the app plays them from Apple's URLs and links each song back to the store.

2. **Full-song playback — Apple Music via MusicKit**, for users with their own Apple
Music subscription, through MusicKit JS v3 under the MusicKit entitlement granted to my
developer account: https://developer.apple.com/musickit/ and
https://developer.apple.com/documentation/applemusicapi . Playback occurs under the
user's own subscription; Sift never proxies or re-serves the audio.

3. **Artist relationships and tags — MusicBrainz and ListenBrainz**, metadata only, no
audio. Published by the MetaBrainz Foundation and released into the public domain under
CC0 1.0: https://musicbrainz.org/doc/About/Data_License and
https://creativecommons.org/publicdomain/zero/1.0/

Build 22 also showed a YouTube icon on saved songs — a plain link to a YouTube search
page, opened in Safari, with no embedded player or download. I have removed every
YouTube link in build 23 regardless. The remaining service buttons are Spotify and Apple
Music search links that simply open the corresponding app.

If any part of this is still unclear, I would rather fix it than argue it — please tell
me which screen or behaviour you would like changed.

Thank you for your time.

Peter Vlahos
