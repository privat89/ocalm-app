import { Controller, Post, Get, Put, Body, Param, HttpCode, HttpStatus } from '@nestjs/common';
import { EscrowService } from './escrow.service';
import { CreateTransactionDto, ValidateTransactionDto } from './escrow.dto';

@Controller()
export class EscrowController {
  constructor(private readonly escrowService: EscrowService) {}

  /**
   * POST /create
   * Crée une nouvelle transaction sécurisée (séquestre)
   */
  @Post('create')
  @HttpCode(HttpStatus.CREATED)
  async createTransaction(@Body() dto: CreateTransactionDto) {
    return this.escrowService.createTransaction(dto);
  }

  /**
   * GET /:id
   * Récupère les détails d'une transaction
   */
  @Get(':id')
  async getTransaction(@Param('id') id: string) {
    return this.escrowService.getTransaction(id);
  }

  /**
   * GET /acheteur/:userId
   * Récupère les transactions de l'acheteur
   */
  @Get('acheteur/:userId')
  async getAcheteurTransactions(@Param('userId') userId: string) {
    return this.escrowService.getByAcheteur(userId);
  }

  /**
   * GET /vendeur/:userId
   * Récupère les ventes du vendeur
   */
  @Get('vendeur/:userId')
  async getVendeurTransactions(@Param('userId') userId: string) {
    return this.escrowService.getByVendeur(userId);
  }

  /**
   * POST /:id/lock
   * Confirme que les fonds sont bloqués (appelé par Wallet Service après paiement)
   */
  @Post(':id/lock')
  @HttpCode(HttpStatus.OK)
  async lockFunds(@Param('id') id: string) {
    return this.escrowService.lockFunds(id);
  }

  /**
   * POST /:id/validate
   * Valide la réception (acheteur scanne QR ou entre OTP)
   */
  @Post(':id/validate')
  @HttpCode(HttpStatus.OK)
  async validateReception(@Param('id') id: string, @Body() dto: ValidateTransactionDto) {
    return this.escrowService.validateReception(id, dto);
  }

  /**
   * POST /:id/dispute
   * Ouvre un litige — gèle les fonds immédiatement
   */
  @Post(':id/dispute')
  @HttpCode(HttpStatus.OK)
  async openDispute(@Param('id') id: string, @Body('reason') reason: string) {
    return this.escrowService.openDispute(id, reason);
  }

  /**
   * POST /:id/refund
   * Rembourse l'acheteur (admin uniquement)
   */
  @Post(':id/refund')
  @HttpCode(HttpStatus.OK)
  async refund(@Param('id') id: string) {
    return this.escrowService.refund(id);
  }
}
