// Mints Apple Music developer tokens (ES256 JWT) from the MusicKit private key.
// The key lives ONLY in Supabase secrets (APPLE_PRIVATE_KEY) — never in the repo.
// Developer tokens are public by design (every MusicKit site embeds one), so this
// endpoint needs no auth beyond Supabase's standard anon key header.
//
// Secrets required (Project Settings → Edge Functions → Secrets):
//   APPLE_TEAM_ID     — 10-char Team ID from developer.apple.com → Membership
//   APPLE_KEY_ID      — the MusicKit key's ID (starts 4NAP…)
//   APPLE_PRIVATE_KEY — the FULL contents of the .p8 file, BEGIN/END lines included
import { SignJWT, importPKCS8 } from "npm:jose@5";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    const teamId = Deno.env.get("APPLE_TEAM_ID");
    const keyId = Deno.env.get("APPLE_KEY_ID");
    let pem = Deno.env.get("APPLE_PRIVATE_KEY");
    if (!teamId || !keyId || !pem) {
      return new Response(JSON.stringify({ error: "missing secrets" }), { status: 500, headers: { ...CORS, "Content-Type": "application/json" } });
    }
    // tolerate a key pasted with literal \n instead of real newlines
    pem = pem.replace(/\\n/g, "\n").trim();
    const key = await importPKCS8(pem, "ES256");
    const now = Math.floor(Date.now() / 1000);
    const exp = now + 60 * 60 * 24 * 30; // 30 days; clients cache and re-fetch near expiry
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "ES256", kid: keyId })
      .setIssuer(teamId)
      .setIssuedAt(now)
      .setExpirationTime(exp)
      .sign(key);
    return new Response(JSON.stringify({ token, exp }), { headers: { ...CORS, "Content-Type": "application/json" } });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e?.message || e) }), { status: 500, headers: { ...CORS, "Content-Type": "application/json" } });
  }
});
