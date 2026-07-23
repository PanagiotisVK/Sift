# Sift — putting the app on your iPhone (Mac steps)

Everything below happens on the MacBook. Total time first run: ~15 minutes,
most of it waiting for downloads.

## One-time setup

1. **Install Node.js** — go to <https://nodejs.org>, click the big green
   **LTS** download, open the installer, click through it.
2. Make sure Xcode has been opened at least once (you've done this).

## Get the app onto the Mac

Open **Terminal** (Cmd+Space, type "Terminal", Enter) and paste these lines
one at a time, pressing Enter after each:

```
cd ~/Desktop
git clone https://github.com/PanagiotisVK/Sift.git
cd Sift
npm install
npm run sync
npm run open
```

- `git clone` copies the project to a **Sift** folder on your Desktop.
- `npm install` + `npm run sync` prepare the iPhone project.
- `npm run open` launches Xcode with the app loaded.

> If `npm run sync` prints an error mentioning **Podfile** or **pods**,
> run `npx cap copy ios` instead, then `npm run open`. (We use Apple's own
> package manager, so CocoaPods is never needed.)

## In Xcode (first time only)

1. In the left sidebar click the blue **App** icon at the very top.
2. Middle pane: click **App** under TARGETS → **Signing & Capabilities** tab.
3. **Team** dropdown → pick your name (your Apple Developer account).
   Leave "Automatically manage signing" checked. Xcode sorts out the rest.
4. Xcode may spend a minute "resolving packages" in the status bar the first
   time — that's normal, let it finish.

## Run it on your iPhone

1. Plug the iPhone into the Mac with a cable. Tap **Trust** on the phone if asked.
2. On the phone, turn on Developer Mode: **Settings → Privacy & Security →
   Developer Mode → on** (it makes you restart the phone once).
3. In Xcode's top bar, click the device dropdown (next to "App") and pick
   your iPhone.
4. Press the **▶ Run** button (top left). First build takes a few minutes.
5. If the app installs but won't open ("Untrusted Developer"):
   **Settings → General → VPN & Device Management** → tap your account →
   **Trust**. Then open Sift from the home screen.

That's it — Sift runs as a real app on your phone.

## Updating later

When the app changes (I push updates), on the Mac:

```
cd ~/Desktop/Sift
git pull
npm run sync
npm run open
```

then press ▶ Run again.
