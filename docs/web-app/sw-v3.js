// OCALM PWA - Service Worker v3
// SAFE: does NOT intercept API calls

const CACHE_NAME = 'ocalm-v3';
const STATIC_ASSETS = [
  '/ocalm-app/web-app/',
  '/ocalm-app/web-app/index.html',
  '/ocalm-app/web-app/css/style.css',
  '/ocalm-app/web-app/js/app.js',
  '/ocalm-app/web-app/manifest.json'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.keys().then((names) => {
      return Promise.all(names.map((name) => caches.delete(name)));
    }).then(() => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.addAll(STATIC_ASSETS);
      });
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((names) => {
      return Promise.all(
        names
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;

  // NEVER intercept API calls
  if (request.url.includes('ocalm-backend')) {
    return;
  }

  if (request.method !== 'GET') {
    return;
  }

  event.respondWith(
    fetch(request).then((response) => {
      if (response.ok) {
        const clone = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
      }
      return response;
    }).catch(() => {
      return caches.match(request);
    })
  );
});
