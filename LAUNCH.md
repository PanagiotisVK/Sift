# Sift — the App Store launch checklist

Everything between here and "live on the App Store". Do the parts in order; each
one says whether it's a browser job or a Mac job. Anything in a box is meant to
be copied, not retyped.

**Where the code stands** *(updated 2026-07-26)*: **every technical blocker is
cleared.** Parts 1–5 are done and verified. Sign in with Apple works from a real
TestFlight build, the demo account logs in, the screenshots are final, and
**build 6 is uploaded** — the build you submit.

The one late bug is fixed and shipped. Demoing the beta to a friend who's into
old Greek folk turned up a real engine fault: any artist whose name isn't in the
Latin alphabet — Greek, Japanese, Korean, Arabic, Cyrillic — resolved correctly
and then contributed **zero songs**, so those decks came back empty or drifted
wildly off-genre. Fixed in commit `fb84fba`, followed by an audit of all 140
genre anchors (`e9d3148`), and **confirmed working on a physical iPhone from
build 6** — not just in headless testing.

Worth remembering for next time: Capacitor bundles the web assets into the
binary, so **a JS fix only reaches the app through a new archive.** Pushing to
GitHub Pages updates the website and nothing else. That's why the fix wasn't in
build 5 and why build 6 exists.

**Everything left is browser work — Parts 6 to 9.** Pre-submission checks were
re-run on 2026-07-26 and all pass: demo account logs in (email confirmed), the
privacy and support URLs return 200, all five screenshots are exactly
1320×2868, and every listing field is inside its character limit.

---

## Part 1 — Supabase: let Apple sign people in *(browser, 3 min)*

Do this **first**. If the provider isn't switched on, the button in the app will
open Apple's sheet and then fail at the last step.

1. <https://supabase.com/dashboard> → your Sift project.
2. Left sidebar: **Authentication** → **Sign In / Providers**.
3. Find **Apple** in the list and switch it **on**.
4. In the field labelled **Client IDs** (sometimes "Authorized Client IDs"),
   paste exactly:

   ```
   com.pvk.sift
   ```

   That's the app's bundle ID. It's how Supabase knows an Apple token was
   issued *for Sift* and not for some other app.
5. Leave **Secret Key (for OAuth)** empty. That field is only for signing in
   through a web browser, which Sift doesn't use.
6. **Save**.

## Part 2 — Supabase: turn email confirmation back on *(browser, 1 min)*

It was switched off during early testing because there was no email sender.
There is one now (Resend), so real signups should confirm their address.

1. Same project → **Authentication** → **Sign In / Providers** → **Email**.
2. Turn **Confirm email** on. Save.
3. Sanity check: sign up with an address you own on
   <https://panagiotisvk.github.io/Sift/> and confirm the email arrives (check
   spam once). The app already says *"Account made! Check your email to confirm
   it, then hit Log in."* when confirmation is on, so nothing else changes.

## Part 3 — Xcode: switch on the Sign in with Apple capability *(Mac, 5 min)*

The code is there; iOS won't let it run without the entitlement.

1. Get the new code and open the project:

   ```
   cd ~/Desktop/Sift && ./mac.sh
   ```

   Use the script, not the individual git commands. It saves whatever Xcode
   changed, pulls, installs the Apple sign-in plugin, syncs it into the iOS
   project and opens Xcode — and it handles the three things that went wrong
   doing it by hand: a bare `git pull` failing with "need to specify how to
   reconcile divergent branches", the merge dropping you into vim, and the push
   blocking on a GitHub login prompt.

2. In Xcode, click the blue **App** icon (top of the left sidebar) → select the
   **App** target → **Signing & Capabilities** tab.
3. Click **+ Capability** (top left of that tab) → type `Apple` → double-click
   **Sign in with Apple**.
4. That's it. Xcode adds the entitlement and registers it against your App ID
   automatically. If it complains about signing, make sure **Automatically
   manage signing** is ticked and your Team is selected.
5. Xcode has created a new file — save it back to the repo so it's never lost:

   ```
   cd ~/Desktop/Sift && git add -A && git commit -m "Xcode: Sign in with Apple entitlement" && git push
   ```

## Part 4 — Test it on your phone *before* archiving *(Mac, 5 min)*

Don't archive blind — a broken sign-in button is an instant rejection.

1. Plug in your iPhone, pick it in Xcode's device dropdown, press **▶**.
2. In the app: **You** tab → the white **Sign in with Apple** button should be
   sitting above the email fields. (On the web version it's deliberately
   hidden — that's expected, not a bug.)
3. Tap it. Apple's sheet appears → Face ID → you land back in Sift being asked
   to pick a username. Pick one, then check the **Friends** tab loads.
4. Kill the app, reopen it — you should still be signed in.
5. Try it once more with **Hide My Email** to be sure that path works too.

**If the sheet opens and then errors:** Part 1 wasn't saved, or the bundle ID in
Supabase has a typo. **If the button does nothing:** `npm install` was skipped.

## Part 5 — Archive and upload the build *(Mac, 15 min mostly waiting)* — ☑ done, build 6

Kept for the next time you ship. **Build 6 is already uploaded**; skip to Part 6.

1. Run `./mac.sh` first so the archive contains the latest web code — this is the
   step that's easy to forget, and forgetting it ships stale JS.
2. Xcode → **App** target → **General** → **Identity** → bump **Build** by one
   (6 → 7 next time). Leave **Version** at `1.0` until the app is live.
3. Device dropdown → **Any iOS Device (arm64)**. *(Archive is greyed out on a
   simulator — the usual gotcha.)*
4. **Product → Archive**, wait, then **Distribute App** → **App Store Connect**
   → **Upload** → accept the defaults.
5. Wait for the processing email (~10–30 min).

## Part 6 — Fill in the store listing *(browser, ~45 min)*

Everything to paste is in **STORE-LISTING.md** in this repo. This is the whole
remaining job. **App Store Connect blocks submission until every one of these
nine is filled in**, and it doesn't tell you which is missing until you try — so
work down the list rather than hunting for the Submit button.

1. App Store Connect → **Apps** → **Sift** → the **1.0 Prepare for Submission**
   page.
2. Paste in: name, subtitle, promotional text, description, keywords, support
   URL, marketing URL.
3. **Screenshots** — upload `design-previews/app-store/sift-store-1..5.png` in
   order 1→5. They're 1320×2868 (6.9" iPhone), which is the only size Apple
   still requires; it scales them down for smaller devices itself.
4. **Age Rating** — a questionnaire, and the one people don't expect. Answers are
   in STORE-LISTING.md. The short version: **Profanity → Infrequent/Mild**
   (catalog previews can contain explicit lyrics), everything else **None**, no
   unrestricted web access, no user-generated content. Result: **12+**. Answer it
   honestly — a reviewer who finds swearing in a 4+ app treats it as
   misrepresentation, which is a worse rejection than the rating.
5. **App Privacy** (left sidebar) — email address and user content, linked to
   identity, used only for app functionality; no tracking, no third-party
   advertising. Full answers in STORE-LISTING.md.
6. **Privacy Policy URL**:

   ```
   https://panagiotisvk.github.io/Sift/privacy.html
   ```

7. **Content Rights** → **Yes**, the app accesses third-party content, and you
   have the rights. (30-second previews and artwork from Apple's public iTunes
   API, used as intended with links out to the store, plus CC0 data from
   MusicBrainz and ListenBrainz. Sift hosts no audio.)
8. **App Information page** → **Copyright**:

   ```
   2026 Peter Vlahos
   ```

   and **Pricing and Availability** → **Free**, all countries. Do **not**
   configure in-app purchases for 1.0.
9. **App Review Information** → sign-in required: **Yes**, demo account
   `riff.demo@facetmusic.app` / `facetdemo123`, and paste the reviewer notes from
   STORE-LISTING.md verbatim. The notes matter more than they look: they tell the
   reviewer where the Sign in with Apple button is (Guideline 4.8 is checked by
   hand) and where account deletion lives (5.1.1(v)). Both save a round trip.
10. Select **build 6** — *not* build 5, which predates the non-Latin fix — and
    **Submit for Review**.

## Part 7 — The name *(browser, 20 min — do it before you print anything)*

Two separate things, and passing one does **not** mean passing the other:

- **App Store name availability** — checked when you create/rename the app
  record in App Store Connect. `Sift` was free in July 2026. If it's taken now,
  fall back to `Sift — Music Discovery` (the home-screen icon still says Sift).
- **Trademark.** This one needs your own eyes. Go to
  <https://tmsearch.uspto.gov>, search `sift`, and filter to **live** marks.

  What a quick look already turns up: **Sift LLC** holds registered SIFT marks
  (reg. 5449167 / 5449168) in class 42 for HR analytics software, and **Sift
  Inc.** — the fraud-prevention company at sift.com, formerly Sift Science —
  holds SIFT filings of its own. Neither is a music app, and trademark rights
  are tied to the field you actually trade in, so this isn't necessarily a
  blocker. But "Sift" is clearly *crowded* in software, which means: check
  class 9 (downloadable software) and class 41 (entertainment) yourself for
  anything live and music-shaped, and if you find one, get an hour of a
  trademark attorney's time before launch rather than after.

  Apple can also pull an app on a trademark complaint, so this is worth the
  20 minutes even though nothing in App Review checks it.

## Part 8 — Small Business Program *(browser, 2 min)*

<https://developer.apple.com/app-store/small-business-program/> — confirm
enrolment went through. It's 15% commission instead of 30% on anything you
ever charge. Doesn't block submission; just don't forget it.

---

## Quick status

| # | Thing | Where | Done? |
|---|-------|-------|-------|
| 1 | Supabase: Apple provider on | browser | ☑ |
| 2 | Supabase: email confirmation on | browser | ☑ |
| 3 | Xcode: Sign in with Apple capability | Mac | ☑ |
| 4 | Test sign-in on device | Mac | ☑ (build 5, TestFlight) |
| 5 | Archive + upload **build 6** (has the non-Latin fix) | Mac | ☑ |
| 6 | Agreements, Tax and Banking shows **Active** | browser | ☑ |
| 7 | Store listing + Age Rating + App Privacy + submit | browser | ☐ ← **you are here** |
| 8 | Trademark check | browser | ☐ |
| 9 | Small Business Program | browser | ☐ |

Nothing left on the Mac. Rows 7–9 are all browser work, and only row 7 blocks
submission.

Already done in code: Sign in with Apple, account deletion, password reset,
Apple-only music engine (Deezer removed for licensing), privacy policy,
non-Latin artist discovery (Greek, Japanese, Korean, Arabic, Cyrillic).

**Verified 2026-07-26, right before submission:** demo account logs in and its
email is confirmed (Supabase's confirmation switch didn't strand it), the account
has 27 saved songs and 2 friends so the reviewer lands in a populated app, the
privacy and support URLs both return 200, all five screenshots are exactly
1320×2868, and every listing field fits its character limit.
