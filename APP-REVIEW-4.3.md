# Build 7 — Guideline 4.3(a) rejection, and the reply

**Submission ID:** 091bf87b-af03-442a-b5ac-61d0bcc6acf0
**Reviewed:** 5 Aug 2026, iPhone 17 Pro Max, version 1.0 (7)
**Finding:** Guideline 4.3(a) — Design — Spam. "Similar binary, metadata, and/or
concept as apps submitted to the App Store by other developers, with only minor
differences."

---

## Read this before doing anything

**Do not upload a new build first.** A fresh binary with no reply gets the same
rejection stamped on it — the reviewer has no reason to look again. Reply in
Resolution Center, then act on what comes back.

**Do not change the app's name or concept in a panic.** Nothing in Apple's message
says the concept is wrong. 4.3(a) is the most boilerplate letter Apple sends; the
four bullets in it are a stock list, not findings about Sift.

## Why it probably happened

The reviewer had a few minutes. What they saw was a card deck of 30-second previews
you swipe left and right, and the previews come from Apple's own public iTunes feed.
Both halves of that — the interaction and the content source — are things they have
watched other people wrap many times.

Two things we wrote made it easier to reach for:

- **The reviewer note.** "A music discovery app using 30-second catalog previews
  (Apple's iTunes preview API) with links out to full songs on streaming services."
  That sentence describes the category, not this app. It reads like a wrapper.
- **The description.** "Swipe right to keep, left to pass. That's it." Written as
  plain-speaking copy; lands as *there is nothing else here*.

Neither is a mistake in isolation. Together they hand a busy reviewer the
conclusion.

## The four factors Apple listed — none apply, and all four are checkable

| Apple's factor | Sift |
| --- | --- |
| Same source code or assets as other submitted apps | Codebase written from scratch, single author |
| Multiple similar apps from a repackaged template | This is the only app ever submitted on the account |
| Purchased template with problematic third-party code | None used, at any point |
| Several similar apps across multiple accounts | One developer account, never held another |

This is the strongest part of the reply because Apple can verify every row itself.

## What is genuinely original — verified in the shipping code, not the marketing

1. **Hook detection** — `findHotStart()`, `www/index.html:2045`. Decodes the preview
   through Web Audio, computes RMS energy in 0.25s frames, smooths over a ~2s window
   so sustained energy wins over transients, excludes the last 4s so it can't land in
   the fade, and eases in 1.5s before the peak. Same pass draws the waveform scrubber.
2. **Adaptive discovery depth** — `state.familiarity` / `depth`, `www/index.html:1452`.
   Decides how far past the popular results to reach, and *moves* on swipe: line 2169
   eases off after a keeper at that depth.
3. **Open-data recommendation graph** — ListenBrainz co-listening plus MusicBrainz
   tags and alias resolution (`www/index.html:918-1078`), including the non-Latin
   alias fix. Not a store's built-in "similar artists" field.
4. **Taste Match %** between friends — `www/index.html:2841`.

Deezer is fully removed as of 2026-07-25 (`www/index.html:908`); only stale comments
mention it. Build 7 makes no Deezer calls. Nothing to correct there.

---

## Reply to paste into Resolution Center

Hello,

Thank you for the review. I would like to address the 4.3(a) finding, as I do not
believe Sift matches any of the patterns the guideline describes — and I would be
grateful for specifics if you still disagree after reading this.

Taking the four contributing factors in your message directly:

- **Same source code or assets as other apps.** Sift is written from scratch by me,
  a solo developer — a single codebase of my own authorship packaged with Capacitor.
  It contains no purchased or third-party app template, no white-label SDK, and no
  code shared with any other submission.
- **Multiple similar apps from a repackaged template.** This is the only app I have
  ever submitted. There is no second bundle ID and no other app on my account.
- **A purchased template with problematic third-party code.** None was used, at any
  point in development.
- **Several similar apps across multiple accounts.** I hold one Apple Developer
  account and have never held another.

On concept: I recognise that a swipe interface over music previews is a familiar
starting point, so I want to be specific about what the app actually does, since I do
not think these exist elsewhere.

**1. Automatic hook detection.** Sift decodes each 30-second preview through the Web
Audio API and computes an energy envelope in 0.25-second frames. It smooths that
envelope over roughly two seconds so that sustained energy wins over a single loud
transient, excludes the closing seconds so playback can never land in a fade-out, and
begins playback 1.5 seconds before the resulting peak. The same analysis draws the
waveform scrubber on each card. The listener hears the chorus first instead of the
intro — which is the difference between a 30-second preview being enough to judge a
song and not.

**2. A discovery-depth model that adapts to the listener.** Sift tracks how much of
what it shows you is already familiar to you, and uses that to decide how far past the
popular results to reach when building the next set. Swiping changes it continuously:
recognising a lot pushes the app deeper into the catalogue, while finding something
you keep at a given depth eases it back. A listener with deep knowledge of a genre and
a casual listener are shown materially different music from the same starting taste.

**3. An open-data recommendation graph.** Artist relationships are drawn from
ListenBrainz co-listening statistics and MusicBrainz tags, including alias resolution
so that artists filed under non-Latin names resolve correctly. This is not a store's
built-in "similar artists" field.

Apple's iTunes Search API supplies preview audio and artwork, used as documented and
with links out to the store. It is the playback layer, not the product — the
selection, ordering, audio analysis and personalisation are all my own work.

If the rejection stands after this, could you please tell me which app or apps Sift
was found to resemble, or which specific screens or metadata prompted the finding? I
will change anything that is genuinely too close, but at the moment I do not know what
that would be.

Thank you for your time.

Peter Vlahos

---

## If the reply fails

1. **Ask again for specifics.** A second Resolution Center message is free.
2. **Appeal to the App Review Board.** Separate reviewers, not the same person.
3. **MusicKit (roadmap phase 2) is the structural answer.** Full Apple Music playback
   for subscribers removes the "preview wrapper" reading entirely — an app that plays
   complete songs through a user's own subscription is not a wrapper around a public
   preview feed. Weeks of work, so it is the fallback, not the first move.

## Metadata — rewritten 5 Aug 2026, already in STORE-LISTING.md

All four are done and verified against their character limits. Paste them into App
Store Connect whether or not the reply succeeds; they are better copy regardless.

| Field | Was | Now | Chars |
| --- | --- | --- | --- |
| Reviewer note | Opened by describing the whole category | Opens with the three original mechanisms; iTunes API mentioned second, as the playback layer | 2,077 / 4,000 |
| Description — HOW IT WORKS | "Swipe right to keep, left to pass. That's it." | The swipe is the input to the depth model: "The app a crate-digger sees is not the app a casual listener sees." | — |
| Description — SKIP TO THE BEST PART | "analyzes each preview and jumps you straight to the hook" | Describes the actual signal analysis: loudest *sustained* passage, starts a beat and a half early, never lands in the fade-out | — |
| Description — opening line | "Everyone else **swipes** you through songs you already know" | "Most music apps recommend you songs you already know" | 2,015 / 4,000 |
| Promotional text | "Every **swipe** digs past the hits…" | Leads with hook detection — it sits above the description, so it is the first line anyone reads | 164 / 170 |

The word "swipe" no longer appears anywhere in the first 200 characters a reviewer
reads. The mechanic is still described plainly further down; it is simply no longer
the headline, because the headline was doing the 4.3 argument for them.

**Not changed, deliberately:** the app name, subtitle, keywords, screenshots and the
swipe interaction itself. Nothing in Apple's message says any of those are the problem,
and changing the product in response to a boilerplate letter would be guessing.
