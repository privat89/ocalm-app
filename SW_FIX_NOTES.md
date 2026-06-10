# OCALM Emergency Fix — Service Worker v1 Breakout

## Problem
The old service worker (`service-worker.js` v1) was aggressively caching the PWA and intercepting API calls with a fake `503` error. Even after code fixes were pushed, browsers that had already visited the PWA continued to serve the broken cached version. The `index.html` unregister script and `app.js` cleanup code were also being cached by the old SW, making them ineffective.

## Solution Applied
1. **New service worker file**: `sw-v3.js` — uses a completely different filename so the old SW cannot intercept its registration.
2. **Force-unregister in `index.html`**: Added an IIFE that runs synchronously in the `<head>` to unregister ALL existing service workers and clear ALL caches before any other script runs.
3. **Removed old `service-worker.js`** from `docs/` deployment.
4. **Updated `app.js`**: Points to `./sw-v3.js` instead of `./service-worker.js`.
5. **Cache-busting query strings**: Added `?v=3` to CSS and manifest links.

## Files Modified
- `web-app/index.html`
- `web-app/js/app.js`
- `web-app/sw-v3.js` (new)
- `docs/web-app/index.html`
- `docs/web-app/js/app.js`
- `docs/web-app/sw-v3.js` (new)
- `docs/web-app/service-worker.js` (deleted)

## Next Steps
- Commit and push to GitHub.
- Instruct user to clear site data manually (F12 → Application → Clear site data) OR use Incognito mode.
- Test the OTP button again.
