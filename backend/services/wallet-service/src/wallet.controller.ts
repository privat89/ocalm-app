import { Controller, Post, Get, Body, Param, Headers, HttpCode, HttpStatus, RawBodyRequest, Req } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { Request } from 'express';

@Controller()
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  /**
   * POST /pay
   * Initie un paiement Wave pour une transaction
   */
  @Post('pay')
  @HttpCode(HttpStatus.OK)
  async initiatePayment(@Body() body: {
    transaction_id: string;
    amount: number;
    phone: string;
    operator: string;
  }) {
    return this.walletService.initiatePayment(body);
  }

  /**
   * GET /status/:paymentId
   * Vérifie le statut d'un paiement
   */
  @Get('status/:paymentId')
  async getPaymentStatus(@Param('paymentId') paymentId: string) {
    return this.walletService.getPaymentStatus(paymentId);
  }

  /**
   * POST /webhooks/wave
   * Webhook appelé par Wave pour confirmer un paiement
   * SÉCURITÉ: Vérification HMAC obligatoire
   */
  @Post('webhooks/wave')
  @HttpCode(HttpStatus.OK)
  async waveWebhook(
    @Body() body: any,
    @Headers('wave-signature') signature: string,
  ) {
    return this.walletService.handleWaveWebhook(body, signature);
  }

  /**
   * POST /payout
   * Effectue un paiement sortant (vers vendeur ou livreur)
   */
  @Post('payout')
  @HttpCode(HttpStatus.OK)
  async payout(@Body() body: {
    transaction_id: string;
    recipient_phone: string;
    amount: number;
    type: 'seller_payout' | 'livreur_payout' | 'refund';
  }) {
    return this.walletService.payout(body);
  }
}
