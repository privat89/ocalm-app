import { IsString, IsNotEmpty, IsNumber, IsBoolean, IsOptional, Min } from 'class-validator';

export class CreateTransactionDto {
  @IsString()
  @IsNotEmpty()
  acheteur_id: string;

  @IsString()
  @IsNotEmpty()
  vendeur_id: string;

  @IsNumber()
  @Min(100)
  montant_article: number;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsBoolean()
  avec_livraison: boolean;

  @IsOptional()
  @IsString()
  pickup_address?: string;

  @IsOptional()
  @IsString()
  delivery_address?: string;
}

export class ValidateTransactionDto {
  @IsOptional()
  @IsString()
  qr_code?: string;

  @IsOptional()
  @IsString()
  otp_code?: string;
}
