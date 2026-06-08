import { Controller, Post, Get, Body, Param, HttpCode, HttpStatus } from '@nestjs/common';
import { DeliveryService } from './delivery.service';

@Controller()
export class DeliveryController {
  constructor(private readonly deliveryService: DeliveryService) {}

  @Post('assign')
  @HttpCode(HttpStatus.OK)
  async assignLivreur(@Body() body: {
    transaction_id: string;
    livreur_id: string;
    pickup_address: string;
    delivery_address: string;
  }) {
    return this.deliveryService.assignLivreur(body);
  }

  @Get('available')
  async getAvailableCourses() {
    return this.deliveryService.getAvailableCourses();
  }

  @Post(':id/scan-departure')
  @HttpCode(HttpStatus.OK)
  async scanDeparture(@Param('id') id: string, @Body('qr_code') qrCode: string) {
    return this.deliveryService.scanDeparture(id, qrCode);
  }

  @Post(':id/scan-arrival')
  @HttpCode(HttpStatus.OK)
  async scanArrival(@Param('id') id: string, @Body() body: { qr_code?: string; otp_code?: string }) {
    return this.deliveryService.scanArrival(id, body);
  }

  @Post(':id/position')
  @HttpCode(HttpStatus.OK)
  async updatePosition(@Param('id') id: string, @Body() body: { lat: number; lng: number }) {
    return this.deliveryService.updatePosition(id, body.lat, body.lng);
  }

  @Get('livreur/:livreurId/history')
  async getLivreurHistory(@Param('livreurId') livreurId: string) {
    return this.deliveryService.getLivreurHistory(livreurId);
  }
}
