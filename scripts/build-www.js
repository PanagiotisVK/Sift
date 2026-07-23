// Packages the web app into www/ for Capacitor. The app IS index.html + a few
// assets at repo root (GitHub Pages serves the same files) — this just copies
// the shippable subset so the iOS bundle never picks up repo clutter.
const fs = require("fs"), path = require("path");
const root = path.join(__dirname, "..");
const out = path.join(root, "www");
const FILES = [
  "index.html",
  "privacy.html",
  "manifest.json",
  "logo-mark.png",
  "favicon.png",
  "icon-180.png",
  "icon-192.png",
  "icon-512.png",
];
fs.rmSync(out, { recursive: true, force: true });
fs.mkdirSync(out);
let copied = 0;
for (const f of FILES) {
  const src = path.join(root, f);
  if (!fs.existsSync(src)) { console.warn("skip (missing):", f); continue; }
  fs.copyFileSync(src, path.join(out, f));
  copied++;
}
console.log("www/ built:", copied, "files");
