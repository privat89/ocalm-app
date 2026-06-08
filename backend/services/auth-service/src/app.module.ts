import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { OtpService } from './otp.service';
import { DatabaseModule } from './database.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'ocalm_jwt_secret_change_in_production',
      signOptions: { expiresIn: '7d' },
    }),
    DatabaseModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, OtpService],
})
export class AppModule {}
