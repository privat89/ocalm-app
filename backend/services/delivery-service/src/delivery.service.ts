import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class DeliveryService {
  private deliveries: Map<string, any> = new Map();

  async assignLivreur(data: {
    transaction_id: string;
    livreur_id: string;
    pickup_address: string;
    delivery_address: string;
  }) {
    const delivery = {
      id: uuidv4(),
      transaction_id: data.transaction_id,
      livreur_id: data.livreur_id,
      pickup_address: data.pickup_address,
      delivery_address: data.delivery_address,
      status: 'assigned',
      qr_code_depart: uuidv4(),
      qr_code_arrivee: uuidv4(),
      otp_secours: Math.floor(100000 + Math.random() * 900000).toString(),
      gain_livreur: 1500,
      created_at: new Date().toISOString(),
    };

    this.deliveries.set(delivery.id, delivery);

    // TODO: Notify livreur via RabbitMQ
    return { success: true, delivery };
  }

  async getAvailableCourses() {
    return Array.from(this.deliveries.values())
      .filter(d => d.status === 'assigned')
      .map(d => ({
        id: d.id,
        pickup: d.pickup_address,
        drop: d.delivery_address,
        gain: d.gain_livreur,
      }));
  }

  async scanDeparture(deliveryId: string, qrCode: string) {
    const delivery = this.deliveries.get(deliveryId);
    if (!delivery) throw new NotFoundException('Livraison introuvable');
    if (delivery.qr_code_depart !== qrCode) {
      throw new BadRequestException('QR code de départ invalide');
    }

    delivery.status = 'picked_up';
    delivery.departure_scanned_at = new Date().toISOString();

    // TODO: Update transaction status to 'en_livraison'
    // TODO: Notify acheteur "Colis pris en charge"

    return { success: true, message: 'Colis pris en charge ! En route.', delivery };
  }

  async scanArrival(deliveryId: string, body: { qr_code?: string; otp_code?: string }) {
    const delivery = this.deliveries.get(deliveryId);
    if (!delivery) throw new NotFoundException('Livraison introuvable');

    if (body.qr_code && body.qr_code !== delivery.qr_code_arrivee) {
      throw new BadRequestException('QR code d\'arrivée invalide');
    }
    if (body.otp_code && body.otp_code !== delivery.otp_secours) {
      throw new BadRequestException('Code OTP invalide');
    }
    if (!body.qr_code && !body.otp_code) {
      throw new BadRequestException('QR code ou OTP requis');
    }

    delivery.status = 'delivered';
    delivery.arrival_scanned_at = new Date().toISOString();
    delivery.validation_method = body.qr_code ? 'qr' : 'otp';

    // TODO: Trigger escrow validation + payouts

    return {
      success: true,
      message: 'Livraison confirmée ! Paiement automatique en cours.',
      delivery,
    };
  }

  async updatePosition(deliveryId: string, lat: number, lng: number) {
    const delivery = this.deliveries.get(deliveryId);
    if (!delivery) throw new NotFoundException('Livraison introuvable');

    delivery.last_position = { lat, lng, timestamp: new Date().toISOString() };
    // TODO: Store in Redis for real-time tracking
    // TODO: Push to acheteur via WebSocket

    return { success: true };
  }

  async getLivreurHistory(livreurId: string) {
    return Array.from(this.deliveries.values())
      .filter(d => d.livreur_id === livreurId)
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
  }
}
