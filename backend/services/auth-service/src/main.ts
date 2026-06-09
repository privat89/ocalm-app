import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
  }));

  app.enableCors({
    origin: [
      'http://localhost:3000',
      'http://localhost:8080',
      'https://localhost',
      'https://privat89.github.io',
      /^https:\/\/.*\.github\.io$/,
    ],
    methods: 'GET,POST,PUT,DELETE,PATCH,OPTIONS',
    credentials: true,
    allowedHeaders: 'Content-Type, Authorization, X-Requested-With',
  });

  const port = process.env.PORT || 3001;
  await app.listen(port);
  console.log(`🔐 OCALM Auth Service running on port ${port}`);
}
bootstrap();
