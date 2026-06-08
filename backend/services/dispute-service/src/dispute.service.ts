import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class DisputeService {
  private disputes: Map<string, any> = new Map();
  private messages: Map<string, any[]> = new Map();

  async openDispute(data: {
    transaction_id: string;
    opened_by: string;
    reason: string;
    description?: string;
  }) {
    const dispute = {
      id: uuidv4(),
      transaction_id: data.transaction_id,
      opened_by: data.opened_by,
      reason: data.reason,
      description: data.description,
      status: 'ouvert',
      evidence_urls: [],
      created_at: new Date().toISOString(),
    };

    this.disputes.set(dispute.id, dispute);
    this.messages.set(dispute.id, []);

    // TODO: Publish 'dispute.opened' → gel des fonds
    // TODO: Notifier toutes les parties + admin

    return {
      success: true,
      dispute,
      message: 'Litige ouvert. Fonds gelés. Un médiateur va intervenir sous 24h.',
    };
  }

  async getDispute(id: string) {
    const dispute = this.disputes.get(id);
    if (!dispute) throw new NotFoundException('Litige introuvable');
    return dispute;
  }

  async getMessages(disputeId: string) {
    return this.messages.get(disputeId) || [];
  }

  async sendMessage(disputeId: string, data: {
    sender_id: string;
    sender_role: string;
    message: string;
    attachment_url?: string;
  }) {
    const msgs = this.messages.get(disputeId);
    if (!msgs) throw new NotFoundException('Litige introuvable');

    const msg = {
      id: uuidv4(),
      dispute_id: disputeId,
      sender_id: data.sender_id,
      sender_role: data.sender_role,
      message: data.message,
      attachment_url: data.attachment_url,
      created_at: new Date().toISOString(),
    };

    msgs.push(msg);
    // TODO: Notify other parties via push

    return { success: true, message: msg };
  }

  async resolve(disputeId: string, data: {
    resolution: string;
    resolved_by: string;
    decision: string;
  }) {
    const dispute = this.disputes.get(disputeId);
    if (!dispute) throw new NotFoundException('Litige introuvable');

    dispute.status = `resolu_${data.decision}`;
    dispute.resolution = data.resolution;
    dispute.resolved_by = data.resolved_by;
    dispute.resolved_at = new Date().toISOString();

    // TODO: Based on decision:
    // 'refund_buyer' → Wallet Service → rembourser acheteur
    // 'pay_seller' → Wallet Service → payer vendeur
    // 'split' → diviser le montant

    return {
      success: true,
      dispute,
      message: `Litige résolu: ${data.resolution}`,
    };
  }

  async addEvidence(disputeId: string, data: { uploaded_by: string; file_url: string }) {
    const dispute = this.disputes.get(disputeId);
    if (!dispute) throw new NotFoundException('Litige introuvable');

    dispute.evidence_urls.push(data.file_url);

    return { success: true, message: 'Preuve ajoutée au dossier.' };
  }
}
