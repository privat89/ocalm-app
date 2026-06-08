import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SendOtpDto, VerifyOtpDto, SetRoleDto } from './auth.dto';

@Controller()
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  /**
   * POST /send-otp
   * Envoie un code OTP par SMS au numéro de téléphone
   */
  @Post('send-otp')
  @HttpCode(HttpStatus.OK)
  async sendOtp(@Body() dto: SendOtpDto) {
    return this.authService.sendOtp(dto.phone);
  }

  /**
   * POST /verify-otp
   * Vérifie le code OTP et retourne un JWT
   */
  @Post('verify-otp')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(dto.phone, dto.code);
  }

  /**
   * POST /refresh
   * Rafraîchit le token JWT
   */
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refreshToken(@Body('refreshToken') refreshToken: string) {
    return this.authService.refreshToken(refreshToken);
  }

  /**
   * POST /role
   * Définit le rôle de l'utilisateur (acheteur/vendeur/livreur)
   */
  @Post('role')
  @HttpCode(HttpStatus.OK)
  async setRole(@Body() dto: SetRoleDto) {
    return this.authService.setRole(dto.userId, dto.role);
  }
}
