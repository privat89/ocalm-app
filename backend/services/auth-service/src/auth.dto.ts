import { IsString, IsNotEmpty, Length, IsIn } from 'class-validator';

export class SendOtpDto {
  @IsString()
  @IsNotEmpty()
  phone: string;
}

export class VerifyOtpDto {
  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsString()
  @Length(6, 6)
  code: string;
}

export class SetRoleDto {
  @IsString()
  @IsNotEmpty()
  userId: string;

  @IsString()
  @IsIn(['acheteur', 'vendeur', 'livreur'])
  role: string;
}
