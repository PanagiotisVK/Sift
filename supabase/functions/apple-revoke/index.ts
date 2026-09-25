// Revokes a user's Sign in with Apple grant when they delete their Sift account.
// App Store Guideline 5.1.1(v): apps offering Sign in with Apple must revoke the user's
// Apple tokens on account deletion, via https://appleid.apple.com/auth/revoke.
//
// Sift never stores Apple refresh tokens. Instead, deleteAccount() in index.html asks
// Apple for a fresh authorization code (one Face ID tap) and posts it here; this
// function swaps the code for a refresh token and revokes it on the spot. Codes are
// single-use and expire after 5 minutes, so there is nothing worth stealing in transit.
//
// Secrets required (Project Settings → Edge Functions → Secrets). This is a SEPARATE
// key from the MusicKit one: developer.apple.com → Keys → + → "Sign in with Apple",
// configured for the primary App ID com.pvk.sift.
//   APPLE_TEAM_ID          — shared with apple-token
//   APPLE_SIWA_KEY_ID      — the Sign in with Apple key's ID
//   APPLE_SIWA_PRIVATE_KEY — the FULL contents of that key's .p8, BEGIN/END lines included
import { SignJWT, importPKCS8 } from "npm:jose@5";

const CLIENT_ID = "com.pvk.sift";   // the bundle ID: native sign-in uses it as the client
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    const teamId = Deno.env.get("APPLE_TEAM_ID");
    const keyId = Deno.env.get("APPLE_SIWA_KEY_ID");
    let pem = Deno.env.get("APPLE_SIWA_PRIVATE_KEY");
    if (!teamId || !keyId || !pem) return json({ error: "missing secrets" }, 500);
    const { code } = await req.json().catch(() => ({}));
    if (!code || typeof code !== "string") return json({ error: "missing code" }, 400);

    // Apple's client_secret is a short-lived ES256 JWT signed with the SIWA key.
    pem = pem.replace(/\\n/g, "\n").trim();
    const key = await importPKCS8(pem, "ES256");
    const now = Math.floor(Date.now() / 1000);
    const secret = await new SignJWT({})
      .setProtectedHeader({ alg: "ES256", kid: keyId })
      .setIssuer(teamId)
      .setSubject(CLIENT_ID)
      .setAudience("https://appleid.apple.com")
      .setIssuedAt(now)
      .setExpirationTime(now + 300)
      .sign(key);

    const form = (o: Record<string, string>) => ({
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams(o),
    });
    const tr = await fetch("https://appleid.apple.com/auth/token",
      form({ grant_type: "authorization_code", code, client_id: CLIENT_ID, client_secret: secret }));
    const tok = await tr.json().catch(() => ({}));
    const token = tok.refresh_token || tok.access_token;
    if (!tr.ok || !token) return json({ error: "exchange failed", apple: tok.error || tr.status }, 502);

    const rr = await fetch("https://appleid.apple.com/auth/revoke", form({
      client_id: CLIENT_ID, client_secret: secret, token,
      token_type_hint: tok.refresh_token ? "refresh_token" : "access_token",
    }));
    if (!rr.ok) return json({ error: "revoke failed", apple: rr.status }, 502);
    return json({ revoked: true });
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
