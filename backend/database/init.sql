-- OCALM Database Schema
-- PostgreSQL 15 — Initialization Script

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- TABLE: users
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(20) NOT NULL UNIQUE,
    phone_verified BOOLEAN DEFAULT FALSE,
    name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'acheteur',
    avatar_url TEXT,
    cni_photo_url TEXT,
    selfie_url TEXT,
    livreur_verified BOOLEAN DEFAULT FALSE,
    caution_paid BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_transactions INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    is_blocked BOOLEAN DEFAULT FALSE,
    blocked_reason TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: transactions_escrow
-- ============================================
CREATE TABLE IF NOT EXISTS transactions_escrow (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reference VARCHAR(50) NOT NULL UNIQUE,
    acheteur_id UUID NOT NULL REFERENCES users(id),
    vendeur_id UUID NOT NULL REFERENCES users(id),
    livreur_id UUID REFERENCES users(id),
    montant_article INTEGER NOT NULL,
    frais_ocalm INTEGER NOT NULL,
    frais_livraison INTEGER DEFAULT 0,
    montant_total INTEGER NOT NULL,
    description TEXT NOT NULL,
    statut VARCHAR(30) DEFAULT 'en_attente_paiement',
    code_secret_acheteur VARCHAR(6),
    qr_code_depart UUID DEFAULT uuid_generate_v4(),
    qr_code_arrivee UUID DEFAULT uuid_generate_v4(),
    avec_livraison BOOLEAN DEFAULT FALSE,
    pickup_address TEXT,
    delivery_address TEXT,
    en_litige BOOLEAN DEFAULT FALSE,
    paid_at TIMESTAMP,
    picked_up_at TIMESTAMP,
    delivered_at TIMESTAMP,
    validated_at TIMESTAMP,
    disputed_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: payments
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions_escrow(id),
    type VARCHAR(30) NOT NULL,
    amount INTEGER NOT NULL,
    operator VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    provider_ref VARCHAR(100),
    provider_response JSONB,
    idempotency_key VARCHAR(100) UNIQUE,
    webhook_verified BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    failed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: deliveries
-- ============================================
CREATE TABLE IF NOT EXISTS deliveries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions_escrow(id),
    livreur_id UUID NOT NULL REFERENCES users(id),
    pickup_address TEXT NOT NULL,
    pickup_lat DECIMAL(10, 7),
    pickup_lng DECIMAL(10, 7),
    delivery_address TEXT NOT NULL,
    delivery_lat DECIMAL(10, 7),
    delivery_lng DECIMAL(10, 7),
    distance_km DECIMAL(5, 2),
    status VARCHAR(20) DEFAULT 'assigned',
    departure_scanned_at TIMESTAMP,
    arrival_scanned_at TIMESTAMP,
    validation_method VARCHAR(10),
    gain_livreur INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: disputes
-- ============================================
CREATE TABLE IF NOT EXISTS disputes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions_escrow(id),
    opened_by UUID NOT NULL REFERENCES users(id),
    reason TEXT NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ouvert',
    resolution TEXT,
    resolved_by UUID REFERENCES users(id),
    resolved_at TIMESTAMP,
    evidence_urls TEXT[],
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: dispute_messages
-- ============================================
CREATE TABLE IF NOT EXISTS dispute_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dispute_id UUID NOT NULL REFERENCES disputes(id),
    sender_id UUID NOT NULL REFERENCES users(id),
    sender_role VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    attachment_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: notifications
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    type VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    data JSONB,
    read BOOLEAN DEFAULT FALSE,
    sent_via VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: otp_codes
-- ============================================
CREATE TABLE IF NOT EXISTS otp_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(20) NOT NULL,
    code VARCHAR(6) NOT NULL,
    purpose VARCHAR(20) DEFAULT 'login',
    used BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: audit_logs
-- ============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(30) NOT NULL,
    entity_id UUID,
    details JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- TABLE: fcm_tokens
-- ============================================
CREATE TABLE IF NOT EXISTS fcm_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    token TEXT NOT NULL,
    device_info JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX IF NOT EXISTS idx_transactions_acheteur ON transactions_escrow(acheteur_id);
CREATE INDEX IF NOT EXISTS idx_transactions_vendeur ON transactions_escrow(vendeur_id);
CREATE INDEX IF NOT EXISTS idx_transactions_livreur ON transactions_escrow(livreur_id);
CREATE INDEX IF NOT EXISTS idx_transactions_statut ON transactions_escrow(statut);
CREATE INDEX IF NOT EXISTS idx_transactions_reference ON transactions_escrow(reference);
CREATE INDEX IF NOT EXISTS idx_payments_transaction ON payments(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_idempotency ON payments(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_deliveries_livreur ON deliveries(livreur_id);
CREATE INDEX IF NOT EXISTS idx_disputes_transaction ON disputes(transaction_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, read);
CREATE INDEX IF NOT EXISTS idx_otp_phone ON otp_codes(phone, used, expires_at);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_logs(entity_type, entity_id);

-- ============================================
-- FUNCTIONS
-- ============================================
CREATE OR REPLACE FUNCTION calculate_ocalm_fees(montant INTEGER)
RETURNS INTEGER AS $$
BEGIN
    IF montant <= 10000 THEN RETURN 100;
    ELSIF montant <= 30000 THEN RETURN 300;
    ELSIF montant <= 100000 THEN RETURN 500;
    ELSIF montant <= 500000 THEN RETURN 1000;
    ELSE RETURN 2500;
    END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGERS (dropped first to prevent dup errors)
-- ============================================
DROP TRIGGER IF EXISTS users_updated_at ON users;
CREATE TRIGGER users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS transactions_updated_at ON transactions_escrow;
CREATE TRIGGER transactions_updated_at BEFORE UPDATE ON transactions_escrow FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS deliveries_updated_at ON deliveries;
CREATE TRIGGER deliveries_updated_at BEFORE UPDATE ON deliveries FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS disputes_updated_at ON disputes;
CREATE TRIGGER disputes_updated_at BEFORE UPDATE ON disputes FOR EACH ROW EXECUTE FUNCTION update_updated_at();
