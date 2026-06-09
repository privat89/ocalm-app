// OCALM PWA - Service Worker
const CACHE_NAME = 'ocalm-v1';
const STATIC_ASSETS = [
  '/ocalm-app/web-app/',
  '/ocalm-app/web-app/index.html',
  '/ocalm-app/web-app/css/style.css',
  '/ocalm-app/web-app/js/app.js',
  '/ocalm-app/web-app/manifest.json'
];

// Install - cache assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    })
  );
  self.skipWaiting();
});

// Activate - clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      );
    })
  );
  self.clients.claim();
});

// Fetch - network first, cache fallback
self.addEventListener('fetch', (event) => {
  const { request } = event;
  
  // API calls - network only
  if (request.url.includes('ocalm-backend')) {
    event.respondWith(fetch(request));
    return;
  }
  
  // Static assets - cache first
  event.respondWith(
    caches.match(request).then((cached) => {
      if (cached) return cached;
      return fetch(request).then((response) => {
        return caches.open(CACHE_NAME).then((cache) => {
          cache.put(request, response.clone());
          return response;
        });
      });
    })
  );
});

// Push notifications
self.addEventListener('push', (event) => {
  const data = event.data.json();
  event.waitUntil(
    self.registration.showNotification('OCALM', {
      body: data.body || 'Nouvelle notification',
      icon: '/ocalm-app/web-app/icons/icon-192x192.png',
      badge: '/ocalm-app/web-app/icons/icon-72x72.png',
      vibrate: [200, 100, 200]
    })
  );
});
