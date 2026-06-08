import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { EscrowController } from './escrow.controller';
import { EscrowService } from './escrow.service';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true })],
  controllers: [EscrowController],
  providers: [EscrowService],
})
export class AppModule {}
