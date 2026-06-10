const API_BASE = 'https://ocalm-backend-s3hx.onrender.com';

// =================== AUTH ===================
async function apiRequest(endpoint, options = {}) {
  const url = `${API_BASE}${endpoint}`;
  const config = {
    method: 'GET',
    mode: 'cors',
    headers: { 'Content-Type': 'application/json' },
    ...options,
  };
  if (config.body && typeof config.body === 'object') config.body = JSON.stringify(config.body);

  let res;
  try {
    res = await fetch(url, config);
  } catch (networkErr) {
    const msg = 'Serveur injoignable. Vérifiez votre connexion ou réessayez.';
    showToast(msg, 'error');
    console.error('[API Network Error]', networkErr);
    throw new Error(msg);
  }

  if (!res.ok) {
    let errMsg = `Erreur serveur (${res.status})`;
    try {
      const errData = await res.json();
      errMsg = errData.message || errData.error || errMsg;
    } catch (_) { /* ignore */ }
    showToast(errMsg, 'error');
    throw new Error(errMsg);
  }
  return await res.json();
}

async function sendOTP(phone) {
  return apiRequest('/auth/send-otp', {
    method: 'POST',
    body: { phone },
  });
}

async function verifyOTP(phone, code) {
  const data = await apiRequest('/auth/verify-otp', {
    method: 'POST',
    body: { phone, code },
  });
  localStorage.setItem('ocalm_token', data.token);
  localStorage.setItem('ocalm_user', JSON.stringify(data.user));
  return data;
}

function getToken() {
  return localStorage.getItem('ocalm_token');
}

function isLoggedIn() {
  return !!getToken();
}

function logout() {
  localStorage.clear();
  navigateTo('page-login');
}

// =================== API Calls ===================
async function createEscrow(article, montant, vendeurPhone) {
  const token = getToken();
  const frais = Math.round(montant * 0.01);
  
  const data = await apiRequest('/escrow/create', {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
    body: { article, montant, frais_ocalm: frais, vendeur_phone: vendeurPhone },
  });
  return data;
}

async function getEscrows() {
  const token = getToken();
  return apiRequest('/escrow/list', {
    headers: { Authorization: `Bearer ${token}` },
  });
}

async function getWallet() {
  const token = getToken();
  return apiRequest('/wallet/balance', {
    headers: { Authorization: `Bearer ${token}` },
  });
}

// =================== UI Helpers ===================
function showToast(message, type = 'info') {
  const existing = document.querySelector('.toast');
  if (existing) existing.remove();
  
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.textContent = message;
  document.body.appendChild(toast);
  
  requestAnimationFrame(() => toast.classList.add('show'));
  setTimeout(() => toast.classList.remove('show'), 3000);
}

function navigateTo(pageId) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  const target = document.getElementById(pageId);
  if (target) {
    target.classList.add('active');
    window.scrollTo(0, 0);
  }
  
  // Nav active state
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
  const navMap = {
    'page-dashboard': 'nav-home',
    'page-transactions': 'nav-transactions',
    'page-profile': 'nav-profile',
  };
  if (navMap[pageId]) {
    document.getElementById(navMap[pageId])?.classList.add('active');
  }
}

function formatMoney(amount) {
  return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + ' F';
}

function dateToStr(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  return d.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
}

// =================== RENDER ===================
function renderDashboard() {
  const name = JSON.parse(localStorage.getItem('ocalm_user') || '{}').name || 'Utilisateur';
  document.getElementById('dash-name').textContent = name + ' \ud83d\udc4b';
}

function renderTransactions(escrows) {
  const list = document.getElementById('tx-list');
  if (!escrows.length) {
    list.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:20px;">Aucune transaction</p>';
    return;
  }
  
  const icons = {
    'en_attente': '\ud83d\udcbc',
    'en_escrow': '\ud83d\udecd\ufe0f',
    'en_livraison': '\ud83d\ude9a',
    'livré': '\u2705',
  };
  
  const badges = {
    'en_attente': 'badge-pending',
    'en_escrow': 'badge-escrow',
    'en_livraison': 'badge-escrow',
    'livré': 'badge-delivered',
  };
  
  const labels = {
    'en_attente': 'En attente',
    'en_escrow': 'En escrow',
    'en_livraison': 'Livraison',
    'livré': 'Livré',
  };
  
  list.innerHTML = escrows.map(tx => `
    <div class="tx-item" data-id="${tx.id}">
      <div class="tx-icon" style="background:rgba(0,102,255,0.08);">${icons[tx.status] || '\ud83d\udecd\ufe0f'}</div>
      <div class="tx-info">
        <div class="name">${tx.article || 'Transaction'}</div>
        <div class="date">${dateToStr(tx.created_at)} <span class="badge ${badges[tx.status] || 'badge-pending'}">${labels[tx.status] || tx.status}</span></div>
      </div>
      <div class="tx-amount negative">${formatMoney(tx.montant + tx.frais_ocalm)}</div>
    </div>
  `).join('');
}

// =================== EVENT HANDLERS ===================
document.addEventListener('DOMContentLoaded', () => {
  // Splash
  setTimeout(() => {
    document.getElementById('splash').classList.add('done');
    if (isLoggedIn()) {
      navigateTo('page-dashboard');
      loadDashboard();
    } else {
      navigateTo('page-login');
    }
  }, 2000);
  
  // Login
  document.getElementById('btn-login')?.addEventListener('click', () => {
    const phone = document.getElementById('login-phone').value.trim();
    if (!phone || phone.length < 10) {
      showToast('Entrez un numéro valide (+225...)', 'error');
      return;
    }
    localStorage.setItem('ocalm_phone', phone);
    sendOTP(phone)
      .then(() => navigateTo('page-otp'))
      .catch(err => showToast(err.message, 'error'));
  });
  
  // OTP
  const otpInputs = document.querySelectorAll('.otp-box');
  otpInputs.forEach((input, i) => {
    input.addEventListener('input', (e) => {
      input.classList.add('filled');
      if (e.target.value && i < otpInputs.length - 1) {
        otpInputs[i + 1].focus();
      }
    });
  });
  
  document.getElementById('btn-verify')?.addEventListener('click', async () => {
    const code = Array.from(otpInputs).map(i => i.value).join('');
    const phone = localStorage.getItem('ocalm_phone');
    
    if (code.length !== 4) {
      showToast('Entrez le code à 4 chiffres', 'error');
      return;
    }
    
    try {
      await verifyOTP(phone, code);
      showToast('Connexion réussie !', 'success');
      navigateTo('page-dashboard');
      loadDashboard();
    } catch (e) {
      showToast('Code incorrect', 'error');
    }
  });
  
  // New Transaction
  document.getElementById('btn-new-tx')?.addEventListener('click', () => {
    navigateTo('page-new-tx');
  });
  
  document.getElementById('confirm-tx')?.addEventListener('click', async () => {
    const article = document.getElementById('tx-article').value;
    const montant = parseInt(document.getElementById('tx-montant').value);
    const vendeur = document.getElementById('tx-vendeur').value;
    
    if (!article || !montant || !vendeur) {
      showToast('Remplissez tous les champs', 'error');
      return;
    }
    
    try {
      await createEscrow(article, montant, vendeur);
      showToast('Transaction créée !', 'success');
      loadDashboard();
      navigateTo('page-dashboard');
    } catch (e) {
      showToast('Erreur lors de la création', 'error');
    }
  });
  
  // Bottom nav
  document.getElementById('nav-home')?.addEventListener('click', () => { loadDashboard(); navigateTo('page-dashboard'); });
  document.getElementById('nav-transactions')?.addEventListener('click', () => { loadTransactions(); navigateTo('page-dashboard'); });
  document.getElementById('nav-profile')?.addEventListener('click', () => navigateTo('page-profile'));
  document.getElementById('btn-logout')?.addEventListener('click', logout);
  
  // Register / cleanup service worker
  if ('serviceWorker' in navigator) {
    // Force-unregister any existing service worker to bypass cache issues
    navigator.serviceWorker.getRegistrations().then(registrations => {
      registrations.forEach(reg => {
        console.log('[SW] Unregistering old service worker');
        reg.unregister();
      });
    });
    // Clear all caches
    if ('caches' in window) {
      caches.keys().then(names => {
        names.forEach(name => {
          console.log('[SW] Deleting cache:', name);
          caches.delete(name);
        });
      });
    }
    // OPTIONNEL: réactiver quand tout est stable
    // navigator.serviceWorker.register('./service-worker.js')
    //   .then(() => console.log('PWA ready'))
    //   .catch(e => console.log('SW error', e));
  }
});

// =================== LOADERS ===================
async function loadDashboard() {
  renderDashboard();
  try {
    const escrows = await getEscrows();
    renderTransactions(escrows);
    
    const balance = await getWallet();
    document.getElementById('wallet-amount').textContent = formatMoney(balance.solde || 0);
  } catch (e) {
    console.log('Erreur chargement dashboard', e);
  }
}

async function loadTransactions() {
  // Déjà géré par loadDashboard
}

// =================== MODAL ===================
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }

// Montant update
const montantInput = document.getElementById('tx-montant');
if (montantInput) {
  montantInput.addEventListener('input', () => {
    const montant = parseInt(montantInput.value) || 0;
    document.getElementById('calc-article').textContent = formatMoney(montant);
    document.getElementById('calc-frais').textContent = formatMoney(Math.round(montant * 0.01));
    document.getElementById('calc-total').textContent = formatMoney(montant + Math.round(montant * 0.01));
  });
}
