import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import * as crypto from 'crypto';

@Injectable()
export class WalletService {
  private payments: Map<string, any> = new Map();

  /**
   * Initie un paiement via Wave API
   * En production: appel à l'API Wave pour créer une session de paiement
   */
  async initiatePayment(data: {
    transaction_id: string;
    amount: number;
    phone: string;
    operator: string;
  }) {
    // Idempotency check
    const idempotencyKey = `pay_${data.transaction_id}_${data.amount}`;
    const existing = Array.from(this.payments.values())
      .find(p => p.idempotency_key === idempotencyKey && p.status !== 'failed');
    if (existing) {
      return { success: true, payment: existing, message: 'Paiement déjà initié' };
    }

    const payment = {
      id: uuidv4(),
      transaction_id: data.transaction_id,
      type: 'escrow_deposit',
      amount: data.amount,
      phone: data.phone,
      operator: data.operator,
      status: 'pending',
      idempotency_key: idempotencyKey,
      provider_ref: null,
      created_at: new Date().toISOString(),
    };

    this.payments.set(payment.id, payment);

    // TODO: En production — Appel API Wave:
    // const waveResponse = await axios.post('https://api.wave.com/v1/checkout/sessions', {
    //   amount: data.amount,
    //   currency: 'XOF',
    //   client_reference: payment.id,
    //   success_url: `https://api.ocalm.ci/api/v1/wallet/callback/success`,
    //   error_url: `https://api.ocalm.ci/api/v1/wallet/callback/error`,
    // }, { headers: { Authorization: `Bearer ${process.env.WAVE_API_KEY}` } });

    return {
      success: true,
      payment,
      checkout_url: `https://pay.wave.com/c/mock-${payment.id}`,
      message: 'Confirme le paiement sur ton téléphone Wave.',
    };
  }

  /**
   * Gère le webhook Wave — confirme que le paiement est reçu
   * SÉCURITÉ: Vérification signature HMAC-SHA256
   */
  async handleWaveWebhook(body: any, signature: string) {
    // Vérifier la signature HMAC
    const secret = process.env.WAVE_WEBHOOK_SECRET || 'wave_webhook_secret';
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(JSON.stringify(body))
      .digest('hex');

    if (signature !== expectedSignature) {
      throw new UnauthorizedException('Signature webhook invalide — tentative de fraude détectée');
    }

    // Traiter le webhook
    const { client_reference, status, wave_id } = body;
    const payment = this.payments.get(client_reference);
    if (!payment) {
      return { received: true, processed: false, reason: 'payment_not_found' };
    }

    if (status === 'succeeded') {
      payment.status = 'completed';
      payment.provider_ref = wave_id;
      payment.webhook_verified = true;
      payment.completed_at = new Date().toISOString();

      // TODO: Publish event 'payment.confirmed' → Escrow Service → lockFunds()
      // C'est ici que le Protocole Shield passe à l'étape 2 (fonds bloqués)
    } else if (status === 'failed') {
      payment.status = 'failed';
      payment.failed_at = new Date().toISOString();
    }

    return { received: true, processed: true };
  }

  /**
   * Effectue un paiement sortant (vendeur/livreur/remboursement)
   */
  async payout(data: {
    transaction_id: string;
    recipient_phone: string;
    amount: number;
    type: string;
  }) {
    const payout: Record<string, any> = {
      id: uuidv4(),
      transaction_id: data.transaction_id,
      type: data.type,
      amount: data.amount,
      phone: data.recipient_phone,
      operator: 'wave',
      status: 'processing',
      created_at: new Date().toISOString(),
    };

    this.payments.set(payout.id, payout);

    // TODO: Appel API Wave pour transfert sortant
    // En production: POST https://api.wave.com/v1/payout

    // Simuler le succès
    setTimeout(() => {
      payout.status = 'completed';
      payout.completed_at = new Date().toISOString();
    }, 2000);

    return {
      success: true,
      payout,
      message: `Paiement de ${data.amount} FCFA en cours vers ${data.recipient_phone}`,
    };
  }

  async getPaymentStatus(paymentId: string) {
    const payment = this.payments.get(paymentId);
    if (!payment) throw new BadRequestException('Paiement introuvable');
    return payment;
  }
}
