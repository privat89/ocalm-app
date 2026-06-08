import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DeliveryController } from './delivery.controller';
import { DeliveryService } from './delivery.service';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true })],
  controllers: [DeliveryController],
  providers: [DeliveryService],
})
export class AppModule {}
