import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { OtpService } from './otp.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly otpService: OtpService,
  ) {}

  /**
   * Envoie un OTP au numéro de téléphone
   */
  async sendOtp(phone: string) {
    // Valider le format du numéro (Côte d'Ivoire: +225 XX XX XX XX XX)
    const cleanPhone = phone.replace(/\s/g, '');
    
    // Générer OTP 6 chiffres
    const code = this.otpService.generateCode();
    
    // Stocker dans Redis avec expiration 5 min
    await this.otpService.storeCode(cleanPhone, code);
    
    // Envoyer par SMS via le Notification Service (RabbitMQ)
    // TODO: Publish to RabbitMQ queue 'sms.send'
    console.log(`📱 OTP for ${cleanPhone}: ${code}`); // Dev only

    return {
      success: true,
      message: 'Code envoyé par SMS',
      // En dev, on renvoie le code pour faciliter les tests
      ...(process.env.NODE_ENV === 'development' && { code }),
    };
  }

  /**
   * Vérifie l'OTP et crée/connecte l'utilisateur
   */
  async verifyOtp(phone: string, code: string) {
    const cleanPhone = phone.replace(/\s/g, '');
    
    // Vérifier le code
    const isValid = await this.otpService.verifyCode(cleanPhone, code);
    if (!isValid) {
      throw new UnauthorizedException('Code invalide ou expiré');
    }

    // Chercher ou créer l'utilisateur
    // TODO: Database query
    const user = {
      id: uuidv4(),
      phone: cleanPhone,
      name: null,
      role: null,
      created_at: new Date().toISOString(),
    };

    // Générer les tokens
    const payload = { sub: user.id, phone: user.phone, role: user.role };
    const token = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '30d' });

    // Log dans audit_logs
    // TODO: Insert audit log

    return {
      success: true,
      token,
      refreshToken,
      user,
      isNewUser: true, // TODO: check if existing
    };
  }

  /**
   * Rafraîchit le JWT
   */
  async refreshToken(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken);
      const newToken = this.jwtService.sign({
        sub: payload.sub,
        phone: payload.phone,
        role: payload.role,
      });
      return { success: true, token: newToken };
    } catch {
      throw new UnauthorizedException('Refresh token invalide');
    }
  }

  /**
   * Définit le rôle de l'utilisateur
   */
  async setRole(userId: string, role: string) {
    const validRoles = ['acheteur', 'vendeur', 'livreur'];
    if (!validRoles.includes(role)) {
      throw new BadRequestException('Rôle invalide. Choisis: acheteur, vendeur, ou livreur');
    }

    // TODO: Update user in database
    // If livreur, mark as needing verification

    return {
      success: true,
      role,
      message: role === 'livreur'
        ? 'Rôle livreur choisi. Vérification d\'identité requise.'
        : `Rôle ${role} activé. Bienvenue sur OCALM !`,
    };
  }
}
