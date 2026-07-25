# Sift — the App Store launch checklist

Everything between here and "live on the App Store". Do the parts in order; each
one says whether it's a browser job or a Mac job. Anything in a box is meant to
be copied, not retyped.

**Where the code stands:** Sign in with Apple, the Apple-only music engine and
the privacy-policy update are already written and pushed. Build 3 was archived
*before* them, so it does **not** contain Sign in with Apple — the build you
submit to the App Store will be **build 4**. Build 3 is still useful: put it in
front of your friends on TestFlight while you work through this list.

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
   cd ~/Desktop/Sift && git pull && npm install && npm run sync && npm run open
   ```

   `npm install` matters this time — it pulls in the Apple sign-in plugin, and
   `npm run sync` wires it into the iOS project.

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

## Part 5 — Archive build 4 *(Mac, 15 min mostly waiting)*

1. Xcode → **App** target → **General** → **Identity** → set **Build** to `4`.
   Leave **Version** at `1.0`.
2. Device dropdown → **Any iOS Device (arm64)**. *(Archive is greyed out on a
   simulator — the usual gotcha.)*
3. **Product → Archive**, wait, then **Distribute App** → **App Store Connect**
   → **Upload** → accept the defaults.
4. Wait for the processing email (~10–30 min).

## Part 6 — Fill in the store listing *(browser, ~45 min)*

Everything to paste is in **STORE-LISTING.md** in this repo.

1. App Store Connect → **Apps** → **Sift** → the **1.0 Prepare for Submission**
   page.
2. Paste in: name, subtitle, promotional text, description, keywords, support
   URL, marketing URL. Upload the screenshots.
3. **App Privacy** (left sidebar) — the questionnaire answers are in the same
   file. The short version: email address and user content, linked to identity,
   used only for app functionality; no tracking, no third-party advertising.
4. Privacy Policy URL:

   ```
   https://panagiotisvk.github.io/Sift/privacy.html
   ```

5. **App Review Information** → sign-in required: **Yes**, and give them the
   demo account (also in STORE-LISTING.md). Add a note in the reviewer field
   that Sign in with Apple is on the **You** tab.
6. Select **build 4** and **Submit for Review**.

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
| 1 | Supabase: Apple provider on | browser | ☐ |
| 2 | Supabase: email confirmation on | browser | ☐ |
| 3 | Xcode: Sign in with Apple capability | Mac | ☐ |
| 4 | Test sign-in on device | Mac | ☐ |
| 5 | Archive + upload build 4 | Mac | ☐ |
| 6 | Store listing + App Privacy + submit | browser | ☐ |
| 7 | Trademark check | browser | ☐ |
| 8 | Small Business Program | browser | ☐ |

Already done in code: Sign in with Apple, account deletion, password reset,
Apple-only music engine (Deezer removed for licensing), privacy policy.
