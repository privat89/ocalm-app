import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';

// Templates de notification OCALM
const TEMPLATES = {
  escrow_locked: {
    title: 'Fonds sécurisés ✓',
    body: (data: any) => `${data.acheteur_name} a payé ${data.amount} F pour "${data.article}". Vous pouvez livrer !`,
  },
  delivery_pickup: {
    title: 'Colis pris en charge',
    body: (data: any) => `Le livreur ${data.livreur_name} a récupéré votre colis. Suivi activé.`,
  },
  delivery_arriving: {
    title: 'Livreur en approche',
    body: (data: any) => `Votre colis arrive dans ~${data.eta} minutes. Préparez-vous à scanner.`,
  },
  transaction_validated: {
    title: 'Transaction validée ! 🎉',
    body: (data: any) => `Paiement de ${data.amount} F envoyé automatiquement. Merci d'utiliser OCALM !`,
  },
  dispute_opened: {
    title: 'Litige ouvert',
    body: (data: any) => `Un litige a été signalé sur la transaction ${data.reference}. Fonds gelés.`,
  },
  dispute_resolved: {
    title: 'Litige résolu',
    body: (data: any) => `Le litige ${data.reference} a été résolu. ${data.resolution}`,
  },
  payout_received: {
    title: 'Paiement reçu ! 💰',
    body: (data: any) => `Vous avez reçu ${data.amount} F sur votre compte Wave.`,
  },
};

@Injectable()
export class NotificationService {
  private notifications: Map<string, any> = new Map();
  private fcmTokens: Map<string, string[]> = new Map();

  async send(data: {
    user_id: string;
    type: string;
    title: string;
    body: string;
    data?: any;
    via?: string;
  }) {
    const notif = {
      id: uuidv4(),
      user_id: data.user_id,
      type: data.type,
      title: data.title,
      body: data.body,
      data: data.data,
      read: false,
      sent_via: data.via || 'push',
      created_at: new Date().toISOString(),
    };

    this.notifications.set(notif.id, notif);

    // Send push notification
    if (data.via !== 'sms') {
      await this.sendPush(data.user_id, notif);
    }

    // Send SMS
    if (data.via === 'sms' || data.via === 'both') {
      // TODO: Get user phone from database
      // await this.sendSMS(userPhone, data.body);
    }

    return { success: true, notification: notif };
  }

  private async sendPush(userId: string, notif: any) {
    const tokens = this.fcmTokens.get(userId) || [];
    if (tokens.length === 0) return;

    // TODO: Firebase Admin SDK
    // await admin.messaging().sendEachForMulticast({
    //   tokens,
    //   notification: { title: notif.title, body: notif.body },
    //   data: notif.data,
    // });

    console.log(`📲 Push → ${userId}: ${notif.title}`);
  }

  async sendSMS(phone: string, message: string) {
    // TODO: Integration avec fournisseur SMS (ex: Twilio, Vonage, ou API locale)
    console.log(`📱 SMS → ${phone}: ${message}`);
    return { success: true, message: 'SMS envoyé' };
  }

  async getUserNotifications(userId: string) {
    return Array.from(this.notifications.values())
      .filter(n => n.user_id === userId)
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
  }

  async markAsRead(notifId: string) {
    const notif = this.notifications.get(notifId);
    if (notif) notif.read = true;
    return { success: true };
  }

  async registerFCMToken(data: { user_id: string; token: string; device_info?: any }) {
    const tokens = this.fcmTokens.get(data.user_id) || [];
    if (!tokens.includes(data.token)) {
      tokens.push(data.token);
      this.fcmTokens.set(data.user_id, tokens);
    }
    return { success: true };
  }
}
