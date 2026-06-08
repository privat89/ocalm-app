import { Controller, Post, Get, Body, Param, HttpCode, HttpStatus } from '@nestjs/common';
import { DisputeService } from './dispute.service';

@Controller()
export class DisputeController {
  constructor(private readonly disputeService: DisputeService) {}

  @Post('open')
  @HttpCode(HttpStatus.CREATED)
  async openDispute(@Body() body: {
    transaction_id: string;
    opened_by: string;
    reason: string;
    description?: string;
  }) {
    return this.disputeService.openDispute(body);
  }

  @Get(':id')
  async getDispute(@Param('id') id: string) {
    return this.disputeService.getDispute(id);
  }

  @Get(':id/messages')
  async getMessages(@Param('id') id: string) {
    return this.disputeService.getMessages(id);
  }

  @Post(':id/message')
  @HttpCode(HttpStatus.OK)
  async sendMessage(@Param('id') id: string, @Body() body: {
    sender_id: string;
    sender_role: string;
    message: string;
    attachment_url?: string;
  }) {
    return this.disputeService.sendMessage(id, body);
  }

  @Post(':id/resolve')
  @HttpCode(HttpStatus.OK)
  async resolve(@Param('id') id: string, @Body() body: {
    resolution: string;
    resolved_by: string;
    decision: 'refund_buyer' | 'pay_seller' | 'split';
  }) {
    return this.disputeService.resolve(id, body);
  }

  @Post(':id/evidence')
  @HttpCode(HttpStatus.OK)
  async uploadEvidence(@Param('id') id: string, @Body() body: {
    uploaded_by: string;
    file_url: string;
  }) {
    return this.disputeService.addEvidence(id, body);
  }
}
