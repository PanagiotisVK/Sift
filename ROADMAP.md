# Sift — what comes after 1.0, and what each thing costs

Written 2026-07-26, while 1.0 was in the submission forms.

This is not a wishlist. It's a list of the things most likely to get built next,
each with the part people forget: **what adding it obliges you to do.** On the App
Store some features are a checkbox, and some quietly enrol you in a set of rules
you then have to satisfy forever. Knowing which is which before you build is the
difference between a two-day feature and a two-week one.

Two facts that apply to everything below:

- **Age rating and the privacy label are editable metadata.** You re-answer the
  questionnaire and it ships with that version's review. Nothing you answered for
  1.0 is permanent, and none of it has to be redone.
- **Answer for what ships, never for what you plan.** Declaring a capability early
  raises your rating and can trigger obligations immediately — for a feature that
  doesn't exist yet.

---

## Cheap: a normal version submission and nothing more

### Sift Pro (in-app purchase)

No effect on your age rating. You create the products in App Store Connect, attach
them to a version, submit. The only new admin is banking details in Agreements,
Tax and Banking — free apps skip that, paid ones can't.

The rule that catches people: **anything digital sold inside the app must go
through Apple's in-app purchase.** You may not take a card, link to your own
checkout, or mention a cheaper price on your website. Commission is 30%, or **15%
under the Small Business Program** — which is why enrolling in that (Part 9 of
LAUNCH.md) is worth two minutes even before you charge anything.

### More genres, better discovery, UI polish

Pure product work, no compliance surface. Includes the deferred `+ More genres`
pill (see "Deferred from 1.0" below).

### Playlist export to Spotify / Apple Music

Adds an OAuth flow and a privacy-label line if you store their tokens server-side.
Manageable. Keep tokens on-device if you can and the label doesn't change.

---

## Expensive: features that enrol you in App Review Guideline 1.2

### Messaging, comments, bios — any free text between users

The moment one user can type text another user reads, **Guideline 1.2** applies,
and it requires *all four* of:

1. A filter for objectionable content
2. A way to report content
3. A way to block abusive users
4. Published contact information for complaints

Plus it raises the age rating. That's a feature in its own right, not a text field.

**This is why sending a deck of songs is the right design.** It's genuinely social
— you share taste, you see what landed — without opening a text channel. Preserve
that property for as long as you can. If you ever do want messages, budget for the
four requirements above as part of the work, not as an afterthought when review
rejects it.

Note that a free-text **profile bio** counts too. Usernames are borderline; a
150-character "about me" is not.

### Ads

Changes the privacy label substantially — you'd declare Advertising Data, and if
the ad SDK tracks users across other companies' apps you must show Apple's
App Tracking Transparency prompt.

The bigger problem is that it contradicts your own words. The description says
"No ads. No selling your data" and the privacy policy says "No ads, and no selling
or sharing of your data with advertisers — ever." Adding ads means rewriting both,
publicly, after telling people otherwise. **A subscription doesn't cost you that.**

### An in-app browser (unrestricted web access)

Pushes the rating toward 18+ for no benefit. Don't. Keep opening links in Safari
and the streaming apps, which is what Sift already does.

---

## Deferred from 1.0, deliberately

- **`+ More genres` pill.** Onboarding shows 18 of 69 genres with the rest behind a
  quiet centred "Show all genres ▾" text link. A pill at the end of the chip grid
  would read better. Cosmetic, and it costs a full archive cycle, so it waits for
  the next build rather than delaying submission.
- **Drop `name` from the Sign in with Apple scope string.** `index.html` requests
  `scopes: "email name"` but the handler only ever reads `identityToken`, so the
  name is requested and discarded. Harmless, but it asks for something unused.
- **Stale comment above `analyzeHot()`** still credits Deezer's CDN for the CORS
  behaviour. Deezer was removed in 2026-07; the previews are Apple's now.
- **Cosmetic follow-state bug:** an artist followed before the Deezer removal can
  still show "Follow" again.
- **Supabase test users** `+sift7251`, `+sift8842`, `+sift9163` are still in the
  database and can surface in friend search. Delete them in Supabase → Auth → Users.

---

## The rule worth remembering

Capacitor bundles the web assets into the binary. **A JavaScript change only
reaches the app through a new archive** — pushing to GitHub Pages updates the
website and nothing else. Every item above that touches `index.html` needs a build
number bump and a fresh upload. Batch them.
