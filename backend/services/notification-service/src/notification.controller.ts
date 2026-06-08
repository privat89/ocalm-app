import { Controller, Post, Get, Body, Param, Put, HttpCode, HttpStatus } from '@nestjs/common';
import { NotificationService } from './notification.service';

@Controller()
export class NotificationController {
  constructor(private readonly notifService: NotificationService) {}

  @Post('send')
  @HttpCode(HttpStatus.OK)
  async send(@Body() body: {
    user_id: string;
    type: string;
    title: string;
    body: string;
    data?: any;
    via?: 'push' | 'sms' | 'both';
  }) {
    return this.notifService.send(body);
  }

  @Get('user/:userId')
  async getUserNotifications(@Param('userId') userId: string) {
    return this.notifService.getUserNotifications(userId);
  }

  @Put(':id/read')
  async markAsRead(@Param('id') id: string) {
    return this.notifService.markAsRead(id);
  }

  @Post('register-token')
  @HttpCode(HttpStatus.OK)
  async registerToken(@Body() body: { user_id: string; token: string; device_info?: any }) {
    return this.notifService.registerFCMToken(body);
  }

  @Post('sms')
  @HttpCode(HttpStatus.OK)
  async sendSMS(@Body() body: { phone: string; message: string }) {
    return this.notifService.sendSMS(body.phone, body.message);
  }
}
