#!/usr/bin/env bash
# Sift — the "get my Mac up to date and open Xcode" script.
#
#   cd ~/Desktop/Sift && ./mac.sh
#
# Saves anything Xcode changed, pulls the latest app code, installs dependencies,
# checks the Apple sign-in plugin actually landed, syncs it all into the iOS project,
# pushes, and opens Xcode. Stops at the first thing that fails rather than carrying
# on and leaving you with a half-updated project.
set -e
cd "$(dirname "$0")"

echo ""
echo "1/6  Saving anything Xcode changed (capabilities, entitlements)…"
git add -A
if git diff --cached --quiet; then
  echo "     nothing new to save"
else
  git commit -m "Xcode: project and entitlement changes"
  echo "     saved"
fi

echo ""
echo "2/6  Pulling the latest app code…"
git pull --no-rebase

echo ""
echo "3/6  Installing dependencies…"
npm install

echo ""
echo "4/6  Checking the Apple sign-in plugin is present…"
if [ -d node_modules/@capacitor-community/apple-sign-in ]; then
  echo "     OK — @capacitor-community/apple-sign-in is installed"
else
  echo "     MISSING. Sign in with Apple cannot work in this build."
  echo "     Tell Claude that step 4 failed."
  exit 1
fi

echo ""
echo "5/6  Building www/ and syncing into the iOS project…"
npm run sync

echo ""
echo "6/6  Pushing…"
# Deliberately not fatal. Pushing is a backup of what Xcode changed, not something
# building the app depends on — and if git asks for a GitHub username here it will
# sit and block forever. GIT_TERMINAL_PROMPT=0 makes it fail fast instead, and the
# script carries on to Xcode either way.
if GIT_TERMINAL_PROMPT=0 git push 2>/dev/null; then
  echo "     pushed"
else
  echo "     couldn't push (GitHub login needed) — carrying on, this doesn't affect the build."
  echo "     To fix it once and for all, run:  gh auth login"
fi

echo ""
echo "Done. Opening Xcode."
echo ""
echo "Next: pick your iPhone in the device dropdown and press the ▶ button."
echo "Then in the app: You tab → tap Sign in with Apple."
echo ""
npm run open
