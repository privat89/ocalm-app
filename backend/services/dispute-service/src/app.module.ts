import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DisputeController } from './dispute.controller';
import { DisputeService } from './dispute.service';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true })],
  controllers: [DisputeController],
  providers: [DisputeService],
})
export class AppModule {}
