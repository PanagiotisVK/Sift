# Sift — getting the app to friends via TestFlight

TestFlight is Apple's official beta system: friends tap a link, install a real
native Sift, and can send you feedback (with screenshots) by shaking their
phone. This walkthrough is one Mac session, ~1 hour, most of it waiting.

Everything you need to type or paste is in a box. Do the parts in order.

---

## Part 1 — Create the app's record (one-time, in a browser)

1. Go to <https://appstoreconnect.apple.com> and sign in with your developer
   Apple ID.
2. Click **Apps** → the blue **+** button → **New App**.
3. Fill the form:
   - **Platforms:** iOS
   - **Name:** `Sift`
     *(If Apple says the name is taken, try `Sift — Music Discovery`. This is
     only the store name — the icon on the phone still says Sift.)*
   - **Primary language:** English (U.S.)
   - **Bundle ID:** pick `com.pvk.sift` from the dropdown.
     *(It's there because Xcode registered it when you set your Team. If the
     dropdown is empty, tell Claude — one extra step fixes it.)*
   - **SKU:** `sift-001` (internal label, nobody sees it)
   - **User Access:** Full Access
4. Click **Create**. Done — leave this tab open, you'll come back in Part 3.

## Part 2 — Upload a build (in Xcode)

1. On the Mac, get the latest code and open the project:

   ```
   cd ~/Desktop/Sift && git pull && npm run sync && npm run open
   ```

2. In Xcode's top bar, click the device dropdown (where your iPhone's name or
   "iPhone 17 Pro" shows) and choose **Any iOS Device (arm64)** — it's near
   the top. *(Archiving is greyed out if a simulator is selected — this is the
   most common gotcha.)*
3. Menu bar: **Product → Archive**. Takes a few minutes. When it finishes, an
   **Organizer** window opens showing your archive.
4. Click **Distribute App** → choose **App Store Connect** → **Upload** →
   accept all the default checkboxes → **Upload**.
5. Wait for "Upload Successful". Then close the Organizer. Apple now
   *processes* the build — you'll get an email in ~10–30 minutes saying it's
   ready. Coffee break.

## Part 3 — Turn on TestFlight (browser again)

1. Back in App Store Connect → **Apps** → **Sift** → **TestFlight** tab.
2. Your build appears under **iOS** once processing finishes (refresh the
   page). If a yellow warning asks about **export compliance**, it shouldn't —
   we pre-answered it in the app. If it *does* ask: answer **None of the
   algorithms mentioned above** — Sift only uses standard HTTPS.
3. **Test with yourself first (instant, no review):**
   - Left sidebar: **Internal Testing** → **+** → name the group `Me` → add
     your own Apple ID → check the build.
   - Install the **TestFlight** app from the App Store on your iPhone, open
     the invite email, and install Sift through it. From now on you can update
     your own phone over the air — no more cable + Xcode ▶.
4. **Then the friends group:**
   - Left sidebar: **External Testing** → **+** → group name `Friends`.
   - Add the build to the group. Apple asks for beta details — paste these:

   **Beta App Description:**
   ```
   Sift plays you 30-second previews of songs you've probably never heard,
   jumping straight to the best part. Swipe right to keep a song, left to
   pass — it learns your taste and digs deeper with every swipe. Add friends
   to compare taste and swipe each other's finds.
   ```

   **Feedback Email:**
   ```
   vlahos89@gmail.com
   ```

   **What to Test:**
   ```
   Swipe through Discover and tell me: are the songs actually new to you?
   Did anything feel confusing the first minute? Try making an account,
   adding a friend by username, and "Swipe their taste" on the Friends tab.
   Report anything that froze, silenced, or surprised you.
   ```

   **Sign-in required?** Yes → give Apple the demo account:
   ```
   Email: riff.demo@facetmusic.app
   Password: facetdemo123
   ```
   *(An account is optional in the app, but giving reviewers one avoids
   questions.)*

5. Click **Submit for Review**. Beta review is the light version — usually
   approved within a day, often hours.
6. Once approved: in the Friends group, turn on **Public Link** and copy it.
   **That link is what you text your friends.** Cap it (e.g. 100 testers) if
   you want.

## What friends do (tell them this)

1. Install the free **TestFlight** app from the App Store.
2. Tap your link → Install Sift.
3. To send feedback: take a screenshot inside Sift → tap the screenshot →
   share → TestFlight, or just open TestFlight → Sift → Send Feedback.

Android / non-iPhone friends: send them
<https://panagiotisvk.github.io/Sift/> and tell them "Add to Home Screen".

## Shipping updates to testers later

1. On the Mac: `cd ~/Desktop/Sift && git pull && npm run sync && npm run open`
2. In Xcode, click the blue **App** icon (left sidebar) → **General** tab →
   under **Identity**, raise **Build** by one (1 → 2 → 3…). Leave Version at
   1.0 while in beta.
3. **Product → Archive → Distribute App** (same as Part 2).
4. In App Store Connect → TestFlight, add the new build to your groups —
   updates to an already-approved group usually don't need another review.
   Testers get it automatically.
