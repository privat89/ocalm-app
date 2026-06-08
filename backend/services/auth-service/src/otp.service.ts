import { Injectable } from '@nestjs/common';
import Redis from 'ioredis';

@Injectable()
export class OtpService {
  private redis: Redis;
  private readonly OTP_EXPIRY = 300; // 5 minutes

  constructor() {
    this.redis = new Redis(process.env.REDIS_URL || 'redis://localhost:6379');
  }

  /**
   * Génère un code OTP à 6 chiffres
   */
  generateCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  /**
   * Stocke le code OTP dans Redis avec expiration
   */
  async storeCode(phone: string, code: string): Promise<void> {
    const key = `otp:${phone}`;
    
    // Rate limiting: max 3 OTP par phone par 15 min
    const rateLimitKey = `otp_rate:${phone}`;
    const attempts = await this.redis.incr(rateLimitKey);
    if (attempts === 1) {
      await this.redis.expire(rateLimitKey, 900); // 15 min
    }
    if (attempts > 3) {
      throw new Error('Trop de tentatives. Réessaie dans 15 minutes.');
    }

    await this.redis.setex(key, this.OTP_EXPIRY, code);
  }

  /**
   * Vérifie le code OTP
   */
  async verifyCode(phone: string, code: string): Promise<boolean> {
    const key = `otp:${phone}`;
    const storedCode = await this.redis.get(key);

    if (!storedCode || storedCode !== code) {
      // Incrémenter les tentatives échouées
      const failKey = `otp_fail:${phone}`;
      const fails = await this.redis.incr(failKey);
      await this.redis.expire(failKey, 900);
      
      // Bloquer après 5 tentatives échouées
      if (fails >= 5) {
        await this.redis.del(key); // Invalider le code
      }
      
      return false;
    }

    // Supprimer le code utilisé (one-time use)
    await this.redis.del(key);
    return true;
  }
}
