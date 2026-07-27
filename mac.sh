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
# --no-edit matters as much as --no-rebase. When the Mac has a local commit Xcode made
# and GitHub has newer ones, the merge is fine — but git stops to open vim asking for a
# commit message it has already written itself. That drops you into an editor with no
# obvious way out, mid-script. Take the default message and keep going.
git pull --no-rebase --no-edit

echo ""
echo "3/6  Installing dependencies…"
npm install

echo ""
echo "4/6  Checking the native plugins are present…"
if [ -d node_modules/@capacitor-community/apple-sign-in ]; then
  echo "     OK — @capacitor-community/apple-sign-in is installed"
else
  echo "     MISSING. Sign in with Apple cannot work in this build."
  echo "     Tell Claude that step 4 failed."
  exit 1
fi
if [ -d node_modules/@capacitor/haptics ]; then
  echo "     OK — @capacitor/haptics is installed (swipe feedback)"
else
  echo "     MISSING. The app still works, but swipes won't buzz."
  echo "     Tell Claude that haptics didn't install."
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
# GIT_TERMINAL_PROMPT=0 alone wasn't enough: it stops git's own prompt but not the
# macOS keychain credential helper, which asked for a username anyway and blocked the
# script. `-c credential.helper=` empties the helper list for this one command, so
# there is nothing left that can prompt and it just fails fast.
if GIT_TERMINAL_PROMPT=0 git -c credential.helper= push 2>/dev/null; then
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
