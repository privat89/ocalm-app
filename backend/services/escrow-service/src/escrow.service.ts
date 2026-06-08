import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { CreateTransactionDto, ValidateTransactionDto } from './escrow.dto';

// Frais OCALM : 1% du montant de la transaction
function calculateFees(montant: number): number {
  return Math.round(montant * 0.01);
}

@Injectable()
export class EscrowService {
  // TODO: Replace with real database queries (Knex)
  private transactions: Map<string, any> = new Map();

  /**
   * PROTOCOLE SHIELD — Étape 1: Création de la transaction
   * L'acheteur initie, les fonds seront bloqués après paiement
   */
  async createTransaction(dto: CreateTransactionDto) {
    const frais = calculateFees(dto.montant_article);
    const fraisLivraison = dto.avec_livraison ? 1500 : 0;
    const total = dto.montant_article + frais + fraisLivraison;

    const transaction = {
      id: uuidv4(),
      reference: `OC-${new Date().getFullYear()}-${String(Date.now() % 100000).padStart(5, '0')}`,
      acheteur_id: dto.acheteur_id,
      vendeur_id: dto.vendeur_id,
      livreur_id: null,
      montant_article: dto.montant_article,
      frais_ocalm: frais,
      frais_livraison: fraisLivraison,
      montant_total: total,
      description: dto.description,
      avec_livraison: dto.avec_livraison,
      statut: 'en_attente_paiement',
      code_secret_acheteur: Math.floor(100000 + Math.random() * 900000).toString(),
      qr_code_depart: uuidv4(),
      qr_code_arrivee: uuidv4(),
      en_litige: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    this.transactions.set(transaction.id, transaction);

    // TODO: Publish event 'transaction.created' to RabbitMQ
    // → Notification Service notifie le vendeur

    return {
      success: true,
      transaction,
      payment: {
        amount: total,
        message: `Paie ${total} FCFA via Wave pour sécuriser ta transaction`,
      },
    };
  }

  /**
   * PROTOCOLE SHIELD — Étape 2: Fonds bloqués
   * Appelé par le Wallet Service quand le paiement est confirmé
   */
  async lockFunds(transactionId: string) {
    const tx = this.transactions.get(transactionId);
    if (!tx) throw new NotFoundException('Transaction introuvable');
    if (tx.statut !== 'en_attente_paiement') {
      throw new BadRequestException('Transaction déjà payée');
    }

    tx.statut = 'fonds_bloques';
    tx.paid_at = new Date().toISOString();
    tx.updated_at = new Date().toISOString();

    // TODO: Publish events:
    // → 'escrow.locked' → Notification Service → SMS vendeur: "Fonds sécurisés. Vous pouvez livrer"
    // → Audit log

    return {
      success: true,
      message: 'Fonds bloqués en séquestre. Le vendeur est notifié.',
      transaction: tx,
    };
  }

  /**
   * PROTOCOLE SHIELD — Étape 4: Validation de réception
   * L'acheteur scanne le QR ou entre le code OTP
   */
  async validateReception(transactionId: string, dto: ValidateTransactionDto) {
    const tx = this.transactions.get(transactionId);
    if (!tx) throw new NotFoundException('Transaction introuvable');
    if (tx.statut !== 'en_livraison' && tx.statut !== 'fonds_bloques') {
      throw new BadRequestException('Transaction non validable dans cet état');
    }
    if (tx.en_litige) {
      throw new BadRequestException('Transaction en litige — validation impossible');
    }

    // Vérifier QR code ou OTP
    if (dto.qr_code) {
      if (dto.qr_code !== tx.qr_code_arrivee) {
        throw new BadRequestException('QR code invalide');
      }
    } else if (dto.otp_code) {
      if (dto.otp_code !== tx.code_secret_acheteur) {
        throw new BadRequestException('Code OTP invalide');
      }
    } else {
      throw new BadRequestException('Fournir un QR code ou un code OTP');
    }

    // Validation réussie !
    tx.statut = 'livre_valide';
    tx.validated_at = new Date().toISOString();
    tx.updated_at = new Date().toISOString();

    // TODO: Publish events:
    // → 'escrow.validated' → Wallet Service → Payer vendeur + livreur
    // → 'payout.vendor' { amount: tx.montant_article, vendeur_id: tx.vendeur_id }
    // → 'payout.livreur' { amount: tx.frais_livraison, livreur_id: tx.livreur_id }
    // → Notification: "Transaction validée ! Paiements automatiques en cours."

    return {
      success: true,
      message: 'Transaction validée ! Le vendeur et le livreur sont payés automatiquement.',
      payouts: {
        vendeur: { amount: tx.montant_article, status: 'processing' },
        livreur: tx.livreur_id ? { amount: tx.frais_livraison, status: 'processing' } : null,
        ocalm: { amount: tx.frais_ocalm, status: 'collected' },
      },
    };
  }

  /**
   * Ouvre un litige — Les fonds sont GELÉS immédiatement
   */
  async openDispute(transactionId: string, reason: string) {
    const tx = this.transactions.get(transactionId);
    if (!tx) throw new NotFoundException('Transaction introuvable');

    tx.en_litige = true;
    tx.statut = 'litige';
    tx.disputed_at = new Date().toISOString();
    tx.updated_at = new Date().toISOString();

    // TODO: Publish 'dispute.opened'
    // → Dispute Service crée le litige
    // → Notification à toutes les parties
    // → Fonds restent gelés jusqu'à résolution

    return {
      success: true,
      message: 'Litige ouvert. Les fonds sont gelés. Notre équipe va analyser la situation.',
    };
  }

  /**
   * Remboursement de l'acheteur (résolution litige en faveur acheteur)
   */
  async refund(transactionId: string) {
    const tx = this.transactions.get(transactionId);
    if (!tx) throw new NotFoundException('Transaction introuvable');

    tx.statut = 'rembourse';
    tx.updated_at = new Date().toISOString();

    // TODO: Publish 'payout.refund' → Wallet Service → rembourser l'acheteur

    return {
      success: true,
      message: 'Remboursement initié vers l\'acheteur.',
    };
  }

  async getTransaction(id: string) {
    const tx = this.transactions.get(id);
    if (!tx) throw new NotFoundException('Transaction introuvable');
    return tx;
  }

  async getByAcheteur(userId: string) {
    return Array.from(this.transactions.values())
      .filter(tx => tx.acheteur_id === userId)
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
  }

  async getByVendeur(userId: string) {
    return Array.from(this.transactions.values())
      .filter(tx => tx.vendeur_id === userId)
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
  }
}
